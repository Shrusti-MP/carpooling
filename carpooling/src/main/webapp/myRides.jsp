<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="model.Ride" %>
<% 
    if (session == null || session.getAttribute("loggedUser") == null) {
        response.sendRedirect("login.jsp");
        return;
    }
    List<Ride> myRides = (List<Ride>) request.getAttribute("myRides");
%>
<jsp:include page="header.jsp" />

<div class="row">
    <div class="col-md-12 mb-4 mt-3">
        <h2>My Offered Rides</h2>
    </div>
</div>

<div class="row">
    <div class="col-md-12">
        <div class="card shadow-sm border-0">
            <div class="card-body">
                <% if(myRides == null || myRides.isEmpty()) { %>
                    <div class="alert alert-info text-center">
                        You haven't offered any rides yet. <a href="offerRide.jsp" class="alert-link">Offer a ride now!</a>
                    </div>
                <% } else { %>
                    <div class="table-responsive">
                        <table class="table table-hover align-middle">
                            <thead class="table-light">
                                <tr>
                                    <th>Route</th>
                                    <th>Date & Time</th>
                                    <th>Vehicle</th>
                                    <th>Available Seats</th>
                                    <th>Price / Seat</th>
                                </tr>
                            </thead>
                            <tbody>
                                <% for(Ride ride : myRides) { %>
                                    <tr>
                                        <td><strong><%= ride.getSource() %></strong> &rarr; <strong><%= ride.getDestination() %></strong></td>
                                        <td><%= ride.getRideDate() %> <br> <small class="text-muted"><%= ride.getRideTime() %></small></td>
                                        <td><%= ride.getVehicleName() %></td>
                                        <td>
                                            <% if(ride.getAvailableSeats() > 0) { %>
                                                <span class="badge bg-success"><%= ride.getAvailableSeats() %> left</span>
                                            <% } else { %>
                                                <span class="badge bg-danger">Full</span>
                                            <% } %>
                                        </td>
                                        <td>$<%= ride.getPricePerSeat() %></td>
                                    </tr>
                                <% } %>
                            </tbody>
                        </table>
                    </div>
                <% } %>
            </div>
        </div>
    </div>
</div>

<jsp:include page="footer.jsp" />
