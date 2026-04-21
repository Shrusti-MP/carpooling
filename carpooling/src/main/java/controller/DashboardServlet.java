package controller;

import dao.BookingDAO;
import dao.RideDAO;
import model.Booking;
import model.Ride;
import model.User;

import java.io.IOException;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet("/DashboardServlet")
public class DashboardServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
            
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("loggedUser") == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        User user = (User) session.getAttribute("loggedUser");
        
        // Fetch recent data for the dashboard if needed
        RideDAO rideDAO = new RideDAO();
        List<Ride> myRides = rideDAO.getRidesByDriver(user.getId());
        
        BookingDAO bookingDAO = new BookingDAO();
        List<Booking> myBookings = bookingDAO.getBookingsByPassenger(user.getId());
        
        request.setAttribute("myRidesCount", myRides.size());
        request.setAttribute("myBookingsCount", myBookings.size());
        
        request.getRequestDispatcher("dashboard.jsp").forward(request, response);
    }
}
