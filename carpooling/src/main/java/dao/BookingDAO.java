package dao;

import model.Booking;
import model.Ride;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class BookingDAO {

    public boolean bookRide(Booking booking) {
        boolean status = false;
        Connection conn = null;
        
        String checkSeatsQuery = "SELECT available_seats FROM rides WHERE id = ? FOR UPDATE";
        String insertBookingQuery = "INSERT INTO bookings (ride_id, passenger_id, seats_booked) VALUES (?, ?, ?)";
        String updateRideQuery = "UPDATE rides SET available_seats = available_seats - ? WHERE id = ?";
        
        try {
            conn = DBConnection.getConnection();
            conn.setAutoCommit(false); // Start transaction
            
            // 1. Check available seats and lock row
            int availableSeats = 0;
            try (PreparedStatement checkStmt = conn.prepareStatement(checkSeatsQuery)) {
                checkStmt.setInt(1, booking.getRideId());
                ResultSet rs = checkStmt.executeQuery();
                if (rs.next()) {
                    availableSeats = rs.getInt("available_seats");
                }
            }
            
            // 2. Prevent overbooking
            if (availableSeats >= booking.getSeatsBooked()) {
                // 3. Insert Booking
                try (PreparedStatement insertStmt = conn.prepareStatement(insertBookingQuery)) {
                    insertStmt.setInt(1, booking.getRideId());
                    insertStmt.setInt(2, booking.getPassengerId());
                    insertStmt.setInt(3, booking.getSeatsBooked());
                    insertStmt.executeUpdate();
                }
                
                // 4. Decrease available seats in ride
                try (PreparedStatement updateStmt = conn.prepareStatement(updateRideQuery)) {
                    updateStmt.setInt(1, booking.getSeatsBooked());
                    updateStmt.setInt(2, booking.getRideId());
                    updateStmt.executeUpdate();
                }
                
                conn.commit();
                status = true;
            } else {
                conn.rollback();
            }
        } catch (SQLException e) {
            e.printStackTrace();
            try {
                if (conn != null) conn.rollback();
            } catch (SQLException ex) {
                ex.printStackTrace();
            }
        } finally {
            try {
                if (conn != null) conn.setAutoCommit(true);
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
        return status;
    }

    public List<Booking> getBookingsByPassenger(int passengerId) {
        List<Booking> bookings = new ArrayList<>();
        String query = "SELECT b.*, r.source, r.destination, r.ride_date, r.ride_time, r.vehicle_name " +
                       "FROM bookings b JOIN rides r ON b.ride_id = r.id WHERE b.passenger_id = ? " +
                       "ORDER BY b.booking_time DESC";
                       
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pst = conn.prepareStatement(query)) {
            
            pst.setInt(1, passengerId);
            ResultSet rs = pst.executeQuery();
            while (rs.next()) {
                Booking booking = new Booking();
                booking.setId(rs.getInt("id"));
                booking.setRideId(rs.getInt("ride_id"));
                booking.setPassengerId(rs.getInt("passenger_id"));
                booking.setSeatsBooked(rs.getInt("seats_booked"));
                booking.setBookingStatus(rs.getString("booking_status"));
                booking.setBookingTime(rs.getTimestamp("booking_time"));
                
                Ride ride = new Ride();
                ride.setSource(rs.getString("source"));
                ride.setDestination(rs.getString("destination"));
                ride.setRideDate(rs.getDate("ride_date"));
                ride.setRideTime(rs.getTime("ride_time"));
                ride.setVehicleName(rs.getString("vehicle_name"));
                
                booking.setRideDetails(ride);
                bookings.add(booking);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return bookings;
    }

    public boolean cancelBooking(int bookingId) {
        boolean status = false;
        Connection conn = null;
        
        String getBookingInfo = "SELECT ride_id, seats_booked FROM bookings WHERE id = ? AND booking_status = 'CONFIRMED'";
        String updateBookingStatus = "UPDATE bookings SET booking_status = 'CANCELLED' WHERE id = ?";
        String updateRideSeats = "UPDATE rides SET available_seats = available_seats + ? WHERE id = ?";
        
        try {
            conn = DBConnection.getConnection();
            conn.setAutoCommit(false);
            
            int rideId = -1;
            int seatsBooked = 0;
            
            // Get booking details
            try (PreparedStatement getStmt = conn.prepareStatement(getBookingInfo)) {
                getStmt.setInt(1, bookingId);
                ResultSet rs = getStmt.executeQuery();
                if (rs.next()) {
                    rideId = rs.getInt("ride_id");
                    seatsBooked = rs.getInt("seats_booked");
                }
            }
            
            if (rideId != -1) {
                // Update booking status
                try (PreparedStatement updateBooking = conn.prepareStatement(updateBookingStatus)) {
                    updateBooking.setInt(1, bookingId);
                    updateBooking.executeUpdate();
                }
                
                // Return seats to ride
                try (PreparedStatement updateRide = conn.prepareStatement(updateRideSeats)) {
                    updateRide.setInt(1, seatsBooked);
                    updateRide.setInt(2, rideId);
                    updateRide.executeUpdate();
                }
                
                conn.commit();
                status = true;
            }
        } catch (SQLException e) {
            e.printStackTrace();
            try {
                if (conn != null) conn.rollback();
            } catch (SQLException ex) {
                ex.printStackTrace();
            }
        } finally {
            try {
                if (conn != null) conn.setAutoCommit(true);
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
        return status;
    }
}
