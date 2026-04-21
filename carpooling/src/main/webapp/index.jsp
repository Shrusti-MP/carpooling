<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<jsp:include page="header.jsp" />

<div class="row align-items-center">
    <div class="col-md-6">
        <h1 class="display-4 fw-bold">Carpool & Save the Environment</h1>
        <p class="lead text-muted">Join the fastest growing carpool community. Share your ride, share the cost, and make new friends.</p>
        <div class="d-grid gap-2 d-md-flex justify-content-md-start mb-4 mb-lg-3">
            <a href="register.jsp" class="btn btn-primary btn-lg px-4 me-md-2 fw-bold">Get Started</a>
            <a href="SearchServlet" class="btn btn-outline-secondary btn-lg px-4">Find a Ride</a>
        </div>
    </div>
    <div class="col-md-6">
        <img src="https://images.unsplash.com/photo-1449965408869-eaa3f722e40d?q=80&w=600&auto=format&fit=crop" class="img-fluid rounded shadow-lg" alt="Carpool Concept">
    </div>
</div>

<jsp:include page="footer.jsp" />
