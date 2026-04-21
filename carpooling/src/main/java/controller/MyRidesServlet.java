package controller;

import dao.RideDAO;
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

@WebServlet("/MyRidesServlet")
public class MyRidesServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
            
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("loggedUser") == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        User user = (User) session.getAttribute("loggedUser");
        RideDAO rideDAO = new RideDAO();
        
        List<Ride> myRides = rideDAO.getRidesByDriver(user.getId());
        request.setAttribute("myRides", myRides);
        request.getRequestDispatcher("myRides.jsp").forward(request, response);
    }
}
