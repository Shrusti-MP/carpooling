package controller;

import dao.BookingDAO;
import dao.RideDAO;
import model.Booking;
import model.User;

import java.io.IOException;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet("/BookingServlet")
public class BookingServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    // Handles fetching bookings
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
            
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("loggedUser") == null) {
            response.sendRedirect("login.jsp");
            return;
        }
        
        User user = (User) session.getAttribute("loggedUser");
        BookingDAO bookingDAO = new BookingDAO();
        
        String action = request.getParameter("action");
        if ("cancel".equals(action)) {
            int bookingId = Integer.parseInt(request.getParameter("id"));
            if (bookingDAO.cancelBooking(bookingId)) {
                request.setAttribute("successMessage", "Booking cancelled successfully.");
            } else {
                request.setAttribute("errorMessage", "Failed to cancel booking.");
            }
        }

        List<Booking> myBookings = bookingDAO.getBookingsByPassenger(user.getId());
        request.setAttribute("myBookings", myBookings);
        request.getRequestDispatcher("myBookings.jsp").forward(request, response);
    }

    // Handles creating a booking
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
            
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("loggedUser") == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        User user = (User) session.getAttribute("loggedUser");
        try {
            int rideId = Integer.parseInt(request.getParameter("rideId"));
            int seatsToBook = Integer.parseInt(request.getParameter("seatsToBook"));
            
            Booking booking = new Booking(rideId, user.getId(), seatsToBook, "CONFIRMED");
            BookingDAO bookingDAO = new BookingDAO();
            
            if (bookingDAO.bookRide(booking)) {
                response.sendRedirect("BookingServlet?success=true");
            } else {
                request.setAttribute("errorMessage", "Booking failed! Seats might not be available.");
                // Redirect back to search with error
                request.getRequestDispatcher("SearchServlet").forward(request, response);
            }
            
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Invalid booking request.");
            request.getRequestDispatcher("dashboard.jsp").forward(request, response);
        }
    }
}
