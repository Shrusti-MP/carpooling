package controller;

import dao.RideDAO;
import model.Ride;
import model.User;

import java.io.IOException;
import java.sql.Date;
import java.sql.Time;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet("/RideServlet")
public class RideServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
            
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("loggedUser") == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        User user = (User) session.getAttribute("loggedUser");
        
        try {
            String source = request.getParameter("source");
            String destination = request.getParameter("destination");
            Date rideDate = Date.valueOf(request.getParameter("rideDate"));
            
            // Standardizing time format dynamically appending seconds if needed
            String timeStr = request.getParameter("rideTime");
            if (timeStr.length() == 5) timeStr += ":00";
            Time rideTime = Time.valueOf(timeStr);
            
            int availableSeats = Integer.parseInt(request.getParameter("availableSeats"));
            double pricePerSeat = Double.parseDouble(request.getParameter("pricePerSeat"));
            String vehicleName = request.getParameter("vehicleName");
            
            Ride ride = new Ride(user.getId(), source, destination, rideDate, rideTime, availableSeats, pricePerSeat, vehicleName);
            RideDAO rideDAO = new RideDAO();
            
            if (rideDAO.addRide(ride)) {
                request.setAttribute("successMessage", "Ride offered successfully!");
                request.getRequestDispatcher("offerRide.jsp").forward(request, response);
            } else {
                request.setAttribute("errorMessage", "Failed to offer ride. Please try again.");
                request.getRequestDispatcher("offerRide.jsp").forward(request, response);
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Invalid inputs provided.");
            request.getRequestDispatcher("offerRide.jsp").forward(request, response);
        }
    }
}
