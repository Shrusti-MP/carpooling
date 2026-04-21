package controller;

import dao.RideDAO;
import model.Ride;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/SearchServlet")
public class SearchServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
            
        String source = request.getParameter("source");
        String destination = request.getParameter("destination");
        String rideDate = request.getParameter("rideDate");
        
        RideDAO rideDAO = new RideDAO();
        List<Ride> rides = rideDAO.searchRides(source, destination, rideDate);
        
        // If it's an AJAX request, we return JSON. Otherwise forward to JSP
        String ajax = request.getParameter("ajax");
        if ("true".equals(ajax)) {
            response.setContentType("application/json");
            response.setCharacterEncoding("UTF-8");
            PrintWriter out = response.getWriter();
            out.print("[");
            for (int i = 0; i < rides.size(); i++) {
                Ride r = rides.get(i);
                out.print("{");
                out.print("\"id\":" + r.getId() + ",");
                out.print("\"driverName\":\"" + r.getDriverName() + "\",");
                out.print("\"source\":\"" + r.getSource() + "\",");
                out.print("\"destination\":\"" + r.getDestination() + "\",");
                out.print("\"rideDate\":\"" + r.getRideDate().toString() + "\",");
                out.print("\"rideTime\":\"" + r.getRideTime().toString() + "\",");
                out.print("\"availableSeats\":" + r.getAvailableSeats() + ",");
                out.print("\"pricePerSeat\":" + r.getPricePerSeat() + ",");
                out.print("\"vehicleName\":\"" + r.getVehicleName() + "\"");
                out.print("}");
                if (i < rides.size() - 1) out.print(",");
            }
            out.print("]");
            out.flush();
        } else {
            request.setAttribute("rides", rides);
            request.getRequestDispatcher("searchRide.jsp").forward(request, response);
        }
    }
}
