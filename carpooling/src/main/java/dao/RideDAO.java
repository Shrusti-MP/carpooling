package dao;

import model.Ride;
import java.sql.Connection;
import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class RideDAO {

    public boolean addRide(Ride ride) {
        boolean status = false;
        String query = "INSERT INTO rides (driver_id, source, destination, ride_date, ride_time, available_seats, price_per_seat, vehicle_name) VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pst = conn.prepareStatement(query)) {
            
            pst.setInt(1, ride.getDriverId());
            pst.setString(2, ride.getSource());
            pst.setString(3, ride.getDestination());
            pst.setDate(4, ride.getRideDate());
            pst.setTime(5, ride.getRideTime());
            pst.setInt(6, ride.getAvailableSeats());
            pst.setDouble(7, ride.getPricePerSeat());
            pst.setString(8, ride.getVehicleName());
            
            int rowsAffected = pst.executeUpdate();
            if (rowsAffected > 0) {
                status = true;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return status;
    }

    public List<Ride> searchRides(String source, String destination, String rideDate) {
        List<Ride> rides = new ArrayList<>();
        StringBuilder query = new StringBuilder(
            "SELECT r.*, u.username as driver_name FROM rides r " +
            "JOIN users u ON r.driver_id = u.id " +
            "WHERE r.available_seats > 0 AND r.ride_date >= CURDATE()"
        );
        
        if (source != null && !source.trim().isEmpty()) {
            query.append(" AND r.source LIKE ?");
        }
        if (destination != null && !destination.trim().isEmpty()) {
            query.append(" AND r.destination LIKE ?");
        }
        if (rideDate != null && !rideDate.trim().isEmpty()) {
            query.append(" AND r.ride_date = ?");
        }
        query.append(" ORDER BY r.ride_date, r.ride_time");

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pst = conn.prepareStatement(query.toString())) {
             
            int paramIndex = 1;
            if (source != null && !source.trim().isEmpty()) {
                pst.setString(paramIndex++, "%" + source + "%");
            }
            if (destination != null && !destination.trim().isEmpty()) {
                pst.setString(paramIndex++, "%" + destination + "%");
            }
            if (rideDate != null && !rideDate.trim().isEmpty()) {
                pst.setDate(paramIndex++, Date.valueOf(rideDate));
            }
            
            ResultSet rs = pst.executeQuery();
            while (rs.next()) {
                Ride ride = mapResultSetToRide(rs);
                ride.setDriverName(rs.getString("driver_name"));
                rides.add(ride);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return rides;
    }

    public List<Ride> getRidesByDriver(int driverId) {
        List<Ride> rides = new ArrayList<>();
        String query = "SELECT * FROM rides WHERE driver_id = ? ORDER BY ride_date DESC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pst = conn.prepareStatement(query)) {
            
            pst.setInt(1, driverId);
            ResultSet rs = pst.executeQuery();
            while (rs.next()) {
                rides.add(mapResultSetToRide(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return rides;
    }

    public Ride getRideById(int rideId) {
        Ride ride = null;
        String query = "SELECT r.*, u.username as driver_name FROM rides r JOIN users u ON r.driver_id = u.id WHERE r.id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pst = conn.prepareStatement(query)) {
            
            pst.setInt(1, rideId);
            ResultSet rs = pst.executeQuery();
            if (rs.next()) {
                ride = mapResultSetToRide(rs);
                ride.setDriverName(rs.getString("driver_name"));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return ride;
    }

    private Ride mapResultSetToRide(ResultSet rs) throws SQLException {
        Ride ride = new Ride();
        ride.setId(rs.getInt("id"));
        ride.setDriverId(rs.getInt("driver_id"));
        ride.setSource(rs.getString("source"));
        ride.setDestination(rs.getString("destination"));
        ride.setRideDate(rs.getDate("ride_date"));
        ride.setRideTime(rs.getTime("ride_time"));
        ride.setAvailableSeats(rs.getInt("available_seats"));
        ride.setPricePerSeat(rs.getDouble("price_per_seat"));
        ride.setVehicleName(rs.getString("vehicle_name"));
        return ride;
    }
}
