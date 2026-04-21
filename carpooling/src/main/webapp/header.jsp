<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="model.User" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Java Carpooling</title>
    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        .navbar-brand { font-weight: bold; font-size: 1.5rem; }
        .hero-section { background: linear-gradient(135deg, #0d6efd, #0dcaf0); color: white; padding: 3rem 0; border-radius: 8px; margin-bottom: 2rem; }
    </style>
</head>
<body class="bg-light">

<nav class="navbar navbar-expand-lg navbar-dark bg-primary mb-4 shadow-sm">
    <div class="container">
        <a class="navbar-brand" href="index.jsp">🚖 Java Carpool</a>
        <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-toggle="collapse" data-bs-target="#navbarNav">
            <span class="navbar-toggler-icon"></span>
        </button>
        <div class="collapse navbar-collapse" id="navbarNav">
            <ul class="navbar-nav ms-auto">
                <% 
                   User user = (session != null) ? (User) session.getAttribute("loggedUser") : null;
                   if (user != null) { 
                %>
                    <li class="nav-item"><a class="nav-link" href="DashboardServlet">Dashboard</a></li>
                    <li class="nav-item"><a class="nav-link" href="offerRide.jsp">Offer Ride</a></li>
                    <li class="nav-item"><a class="nav-link" href="SearchServlet">Search Ride</a></li>
                    <li class="nav-item"><a class="nav-link" href="MyRidesServlet">My Rides</a></li>
                    <li class="nav-item"><a class="nav-link" href="BookingServlet">My Bookings</a></li>
                    <li class="nav-item dropdown">
                        <a class="nav-link dropdown-toggle" href="#" role="button" data-bs-toggle="dropdown">
                            Welcome, <%= user.getUsername() %>
                        </a>
                        <ul class="dropdown-menu">
                            <li><a class="dropdown-item text-danger" href="LogoutServlet">Logout</a></li>
                        </ul>
                    </li>
                <% } else { %>
                    <li class="nav-item"><a class="nav-link" href="login.jsp">Login</a></li>
                    <li class="nav-item"><a class="nav-link" href="register.jsp">Register</a></li>
                <% } %>
            </ul>
        </div>
    </div>
</nav>
<div class="container min-vh-100">
