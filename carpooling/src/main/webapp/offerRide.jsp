<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<% 
    if (session == null || session.getAttribute("loggedUser") == null) {
        response.sendRedirect("login.jsp");
        return;
    }
%>
<jsp:include page="header.jsp" />

<div class="row justify-content-center">
    <div class="col-md-8">
        <div class="card shadow-sm border-0 mt-4">
            <div class="card-body p-4">
                <h3 class="mb-4">Offer a New Ride</h3>
                
                <% if(request.getAttribute("errorMessage") != null) { %>
                    <div class="alert alert-danger"><%= request.getAttribute("errorMessage") %></div>
                <% } %>
                <% if(request.getAttribute("successMessage") != null) { %>
                    <div class="alert alert-success"><%= request.getAttribute("successMessage") %></div>
                <% } %>
                
                <form action="RideServlet" method="POST">
                    <div class="row g-3">
                        <div class="col-md-6">
                            <label class="form-label">Source City</label>
                            <input type="text" name="source" class="form-control" placeholder="E.g., New York" required>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label">Destination City</label>
                            <input type="text" name="destination" class="form-control" placeholder="E.g., Boston" required>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label">Date</label>
                            <input type="date" name="rideDate" class="form-control" required>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label">Time</label>
                            <input type="time" name="rideTime" class="form-control" required>
                        </div>
                        <div class="col-md-4">
                            <label class="form-label">Available Seats</label>
                            <input type="number" name="availableSeats" class="form-control" min="1" max="10" required>
                        </div>
                        <div class="col-md-4">
                            <label class="form-label">Price per Seat ($)</label>
                            <input type="number" step="0.01" name="pricePerSeat" class="form-control" min="0" required>
                        </div>
                        <div class="col-md-4">
                            <label class="form-label">Vehicle Name</label>
                            <input type="text" name="vehicleName" class="form-control" placeholder="Toyota Camry" required>
                        </div>
                    </div>
                    <div class="mt-4 text-end">
                        <button type="submit" class="btn btn-primary btn-lg">Post Ride</button>
                    </div>
                </form>
            </div>
        </div>
    </div>
</div>

<jsp:include page="footer.jsp" />
