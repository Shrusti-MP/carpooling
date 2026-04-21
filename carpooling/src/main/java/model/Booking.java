package model;

import java.sql.Timestamp;

public class Booking {
    private int id;
    private int rideId;
    private int passengerId;
    private int seatsBooked;
    private String bookingStatus;
    private Timestamp bookingTime;

    // Extra fields for UI convenience
    private Ride rideDetails;

    public Booking() {}

    public Booking(int rideId, int passengerId, int seatsBooked, String bookingStatus) {
        this.rideId = rideId;
        this.passengerId = passengerId;
        this.seatsBooked = seatsBooked;
        this.bookingStatus = bookingStatus;
    }

    // Getters and Setters
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public int getRideId() { return rideId; }
    public void setRideId(int rideId) { this.rideId = rideId; }

    public int getPassengerId() { return passengerId; }
    public void setPassengerId(int passengerId) { this.passengerId = passengerId; }

    public int getSeatsBooked() { return seatsBooked; }
    public void setSeatsBooked(int seatsBooked) { this.seatsBooked = seatsBooked; }

    public String getBookingStatus() { return bookingStatus; }
    public void setBookingStatus(String bookingStatus) { this.bookingStatus = bookingStatus; }

    public Timestamp getBookingTime() { return bookingTime; }
    public void setBookingTime(Timestamp bookingTime) { this.bookingTime = bookingTime; }

    public Ride getRideDetails() { return rideDetails; }
    public void setRideDetails(Ride rideDetails) { this.rideDetails = rideDetails; }
}
