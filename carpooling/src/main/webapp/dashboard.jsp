<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="model.User" %>
<% 
    User user = (session != null) ? (User) session.getAttribute("loggedUser") : null;
    if (user == null) {
        response.sendRedirect("login.jsp");
        return;
    }
%>
<jsp:include page="header.jsp" />

<div class="hero-section text-center shadow-sm">
    <h1 class="display-5 fw-bold">Welcome back, <%= user.getUsername() %>!</h1>
    <p class="lead">Manage your carpooling activities from your dashboard.</p>
</div>

<div class="row g-4 mt-2">
    <div class="col-md-4">
        <div class="card shadow-sm border-0 h-100">
            <div class="card-body text-center">
                <h5>Rides Offered</h5>
                <h2 class="text-primary"><%= request.getAttribute("myRidesCount") != null ? request.getAttribute("myRidesCount") : 0 %></h2>
                <p class="text-muted">Total rides you have posted</p>
                <a href="MyRidesServlet" class="btn btn-outline-primary btn-sm">View Details</a>
            </div>
        </div>
    </div>
    <div class="col-md-4">
        <div class="card shadow-sm border-0 h-100">
            <div class="card-body text-center">
                <h5>Rides Booked</h5>
                <h2 class="text-success"><%= request.getAttribute("myBookingsCount") != null ? request.getAttribute("myBookingsCount") : 0 %></h2>
                <p class="text-muted">Total seats you have reserved</p>
                <a href="BookingServlet" class="btn btn-outline-success btn-sm">View Details</a>
            </div>
        </div>
    </div>
    <div class="col-md-4">
        <div class="card shadow-sm border-0 h-100">
            <div class="card-body text-center">
                <h5>Quick Actions</h5>
                <div class="d-grid gap-2 mt-3">
                    <a href="offerRide.jsp" class="btn btn-primary btn-sm">Offer a New Ride</a>
                    <a href="SearchServlet" class="btn btn-secondary btn-sm">Search for a Ride</a>
                </div>
            </div>
        </div>
    </div>
</div>

<jsp:include page="footer.jsp" />
