<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="model.Ride" %>
<% 
    if (session == null || session.getAttribute("loggedUser") == null) {
        response.sendRedirect("login.jsp");
        return;
    }
%>
<jsp:include page="header.jsp" />

<div class="row">
    <div class="col-md-12 text-center mb-4 mt-3">
        <h2>Find Your Perfect Ride</h2>
    </div>
</div>

<div class="row">
    <!-- Filters Sidebar -->
    <div class="col-md-4">
        <div class="card shadow-sm border-0 mb-4 position-sticky" style="top: 20px;">
            <div class="card-body">
                <h5 class="card-title">Filter Options</h5>
                <hr>
                <form id="searchForm" onsubmit="event.preventDefault(); fetchRides();">
                    <div class="mb-3">
                        <label class="form-label">Leaving from</label>
                        <input type="text" id="source" name="source" class="form-control" placeholder="City or location">
                    </div>
                    <div class="mb-3">
                        <label class="form-label">Going to</label>
                        <input type="text" id="destination" name="destination" class="form-control" placeholder="City or location">
                    </div>
                    <div class="mb-3">
                        <label class="form-label">Date</label>
                        <input type="date" id="rideDate" name="rideDate" class="form-control">
                    </div>
                    <button type="submit" class="btn btn-primary w-100">Search with AJAX</button>
                    <button type="button" class="btn btn-outline-secondary w-100 mt-2" onclick="clearFilters()">Clear</button>
                </form>
            </div>
        </div>
    </div>

    <!-- Results Area -->
    <div class="col-md-8">
        <% if(request.getAttribute("errorMessage") != null) { %>
            <div class="alert alert-danger"><%= request.getAttribute("errorMessage") %></div>
        <% } %>
        
        <div id="resultsArea" class="row g-3">
            <!-- Dynamic AJAX content rendered here -->
        </div>
        
        <div id="noResults" class="alert alert-info text-center" style="display: none;">
            No rides found matching your search criteria.
        </div>
    </div>
</div>

<!-- Modal for Booking -->
<div class="modal fade" id="bookingModal" tabindex="-1" aria-hidden="true">
  <div class="modal-dialog">
    <div class="modal-content">
      <div class="modal-header">
        <h5 class="modal-title">Book Seat</h5>
        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
      </div>
      <form action="BookingServlet" method="POST">
          <div class="modal-body">
            <input type="hidden" id="modalRideId" name="rideId">
            <p><strong>Route:</strong> <span id="modalRoute"></span></p>
            <p><strong>Date & Time:</strong> <span id="modalDateTime"></span></p>
            <p><strong>Price per Seat:</strong> $<span id="modalPrice"></span></p>
            
            <div class="mb-3">
                <label class="form-label">Seats to Book</label>
                <input type="number" id="seatsToBook" name="seatsToBook" class="form-control" min="1" value="1" required>
                <small class="text-muted">Available: <span id="modalMaxSeats"></span></small>
            </div>
            <h5 class="text-end">Total Price: $<span id="modalTotalPrice">0.00</span></h5>
          </div>
          <div class="modal-footer">
            <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
            <button type="submit" class="btn btn-success">Confirm Booking</button>
          </div>
      </form>
    </div>
  </div>
</div>

<script>
    document.addEventListener("DOMContentLoaded", function() {
        fetchRides(); // Fetch all rides on load
        
        // Setup price calculation
        document.getElementById('seatsToBook').addEventListener('input', function() {
            let seats = this.value;
            let price = parseFloat(document.getElementById('modalPrice').innerText);
            if(seats && price) {
                document.getElementById('modalTotalPrice').innerText = (seats * price).toFixed(2);
            }
        });
    });

    function fetchRides() {
        const source = document.getElementById('source').value;
        const destination = document.getElementById('destination').value;
        const rideDate = document.getElementById('rideDate').value;
        
        const url = `SearchServlet?ajax=true&source=\${encodeURIComponent(source)}&destination=\${encodeURIComponent(destination)}&rideDate=\${encodeURIComponent(rideDate)}`;
        
        fetch(url)
            .then(response => response.json())
            .then(data => renderRides(data))
            .catch(error => {
                console.error("Error fetching rides: ", error);
                document.getElementById('resultsArea').innerHTML = '<div class="alert alert-danger w-100">Failed to load rides. Cannot parse AJAX response.</div>';
            });
    }
    
    function clearFilters() {
        document.getElementById('searchForm').reset();
        fetchRides();
    }

    function renderRides(rides) {
        const resultsArea = document.getElementById('resultsArea');
        const noResults = document.getElementById('noResults');
        resultsArea.innerHTML = '';
        
        if (rides.length === 0) {
            noResults.style.display = 'block';
            return;
        }
        noResults.style.display = 'none';

        rides.forEach(ride => {
            const card = document.createElement('div');
            card.className = 'col-md-12';
            card.innerHTML = `
                <div class="card shadow-sm border-0 mb-3">
                    <div class="card-body">
                        <div class="d-flex justify-content-between align-items-center">
                            <h5 class="card-title text-primary"><i class="bi bi-car-front-fill"></i> \${ride.source} <span class="text-dark">&rarr;</span> \${ride.destination}</h5>
                            <span class="badge bg-success rounded-pill px-3 py-2">$\${ride.pricePerSeat} / set</span>
                        </div>
                        <div class="row mt-3">
                            <div class="col-sm-4">
                                <p class="mb-1 text-muted"><small>Driver</small></p>
                                <p class="fw-bold">\${ride.driverName}</p>
                            </div>
                            <div class="col-sm-4">
                                <p class="mb-1 text-muted"><small>Date & Time</small></p>
                                <p class="fw-bold">\${ride.rideDate} at \${ride.rideTime}</p>
                            </div>
                            <div class="col-sm-4 text-end align-self-center">
                                <p class="mb-1 text-muted"><small>Available Seats</small></p>
                                <h4 class="text-info">\${ride.availableSeats}</h4>
                            </div>
                        </div>
                        <hr>
                        <div class="d-flex justify-content-between align-items-center">
                            <small class="text-muted">Vehicle: \${ride.vehicleName}</small>
                            <button class="btn btn-outline-primary" onclick="openBookingModal(\${ride.id}, '\${ride.source}', '\${ride.destination}', '\${ride.rideDate}', '\${ride.rideTime}', \${ride.pricePerSeat}, \${ride.availableSeats})">Book Seat</button>
                        </div>
                    </div>
                </div>
            `;
            resultsArea.appendChild(card);
        });
    }

    function openBookingModal(id, source, destination, date, time, price, maxSeats) {
        document.getElementById('modalRideId').value = id;
        document.getElementById('modalRoute').innerText = source + ' to ' + destination;
        document.getElementById('modalDateTime').innerText = date + ' at ' + time;
        document.getElementById('modalPrice').innerText = price;
        document.getElementById('modalMaxSeats').innerText = maxSeats;
        
        let seatInput = document.getElementById('seatsToBook');
        seatInput.max = maxSeats;
        seatInput.value = 1;
        
        document.getElementById('modalTotalPrice').innerText = (1 * price).toFixed(2);
        
        var modal = new bootstrap.Modal(document.getElementById('bookingModal'));
        modal.show();
    }
</script>

<jsp:include page="footer.jsp" />
