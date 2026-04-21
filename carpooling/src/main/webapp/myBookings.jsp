<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="model.Booking" %>
<%@ page import="model.Ride" %>
<% 
    if (session == null || session.getAttribute("loggedUser") == null) {
        response.sendRedirect("login.jsp");
        return;
    }
    List<Booking> myBookings = (List<Booking>) request.getAttribute("myBookings");
%>
<jsp:include page="header.jsp" />

<div class="row">
    <div class="col-md-12 mb-4 mt-3">
        <h2>My Bookings</h2>
        <% if("true".equals(request.getParameter("success"))) { %>
            <div class="alert alert-success mt-2">Booking confirmed successfully!</div>
        <% } %>
        <% if(request.getAttribute("successMessage") != null) { %>
            <div class="alert alert-success mt-2"><%= request.getAttribute("successMessage") %></div>
        <% } %>
        <% if(request.getAttribute("errorMessage") != null) { %>
            <div class="alert alert-danger mt-2"><%= request.getAttribute("errorMessage") %></div>
        <% } %>
    </div>
</div>

<div class="row">
    <div class="col-md-12">
        <div class="card shadow-sm border-0">
            <div class="card-body">
                <% if(myBookings == null || myBookings.isEmpty()) { %>
                    <div class="alert alert-info text-center">
                        You have not booked any rides yet. <a href="SearchServlet" class="alert-link">Search for rides!</a>
                    </div>
                <% } else { %>
                    <div class="table-responsive">
                        <table class="table table-hover align-middle">
                            <thead class="table-light">
                                <tr>
                                    <th>Booking ID</th>
                                    <th>Route</th>
                                    <th>Date & Time</th>
                                    <th>Seats Booked</th>
                                    <th>Status</th>
                                    <th>Action</th>
                                </tr>
                            </thead>
                            <tbody>
                                <% for(Booking booking : myBookings) { 
                                       Ride ride = booking.getRideDetails();
                                %>
                                    <tr>
                                        <td>#<%= booking.getId() %></td>
                                        <td><strong><%= ride.getSource() %></strong> &rarr; <strong><%= ride.getDestination() %></strong></td>
                                        <td><%= ride.getRideDate() %> <br> <small class="text-muted"><%= ride.getRideTime() %></small></td>
                                        <td><%= booking.getSeatsBooked() %></td>
                                        <td>
                                            <% if("CONFIRMED".equals(booking.getBookingStatus())) { %>
                                                <span class="badge bg-success">Confirmed</span>
                                            <% } else { %>
                                                <span class="badge bg-secondary"><%= booking.getBookingStatus() %></span>
                                            <% } %>
                                        </td>
                                        <td>
                                            <% if("CONFIRMED".equals(booking.getBookingStatus())) { %>
                                                <a href="BookingServlet?action=cancel&id=<%= booking.getId() %>" class="btn btn-sm btn-outline-danger" onclick="return confirm('Are you sure you want to cancel this booking?');">Cancel</a>
                                            <% } else { %>
                                                <button class="btn btn-sm btn-outline-secondary disabled">Cancelled</button>
                                            <% } %>
                                        </td>
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
