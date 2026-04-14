package com.amrit;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

import org.bson.Document;
import com.mongodb.client.MongoDatabase;

@WebServlet("/booking")
public class BookingServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        if (session.getAttribute("user") == null) {
            response.sendRedirect("auth?action=signin");
            return;
        }

        String action = request.getParameter("action");
        if (action == null || action.isBlank()) {
            action = "dashboard";
        }

        MongoDatabase db = MongoUtil.getDatabase();
        String userId = (String) session.getAttribute("user");

        switch (action) {
            case "dashboard" -> forwardDashboard(request, response, db, userId);
            case "flight" -> request.getRequestDispatcher("WEB-INF/booking.jsp").forward(request, response);
            case "hotel" -> {
                List<Document> hotels = TravelRepository.listHotels(db);
                request.setAttribute("hotels", hotels);
                request.getRequestDispatcher("WEB-INF/hotel.jsp").forward(request, response);
            }
            case "package" -> {
                List<Document> packages = TravelRepository.listPackages(db);
                request.setAttribute("packages", packages);
                request.getRequestDispatcher("WEB-INF/package.jsp").forward(request, response);
            }
            case "places" -> {
                List<Document> places = TravelRepository.listPlaces(db, 24);
                request.setAttribute("places", places);
                request.getRequestDispatcher("WEB-INF/places.jsp").forward(request, response);
            }
            case "explore" -> forwardExplore(request, response, db, userId);
            case "stayNearby" -> forwardStayNearby(request, response, db);
            case "mybookings" -> {
                List<Document> bookings = TravelRepository.listBookingsForUser(db, userId);
                request.setAttribute("bookings", bookings);
                request.getRequestDispatcher("WEB-INF/mybookings.jsp").forward(request, response);
            }
            case "success" -> forwardSuccess(request, response, session);
            default -> forwardDashboard(request, response, db, userId);
        }
    }

    private void forwardDashboard(HttpServletRequest request, HttpServletResponse response, MongoDatabase db,
            String userId) throws ServletException, IOException {
        List<Document> highlights = TravelRepository.listPlaces(db, 3);
        List<Document> recPackages = TravelRepository.recommendPackages(db, userId, 4);
        List<Document> recPlaces = TravelRepository.recommendPlaces(db, userId, 4);
        List<Document> allBookings = TravelRepository.listBookingsForUser(db, userId);
        List<Document> recent = new ArrayList<>();
        int n = Math.min(4, allBookings.size());
        for (int i = 0; i < n; i++) {
            recent.add(allBookings.get(i));
        }
        int totalBookings = TravelRepository.countBookingsForUser(db, userId);
        request.setAttribute("places", highlights);
        request.setAttribute("recPackages", recPackages);
        request.setAttribute("recPlaces", recPlaces);
        request.setAttribute("recentBookings", recent);
        request.setAttribute("totalBookings", totalBookings);
        request.getRequestDispatcher("WEB-INF/dashboard.jsp").forward(request, response);
    }

    private void forwardExplore(HttpServletRequest request, HttpServletResponse response, MongoDatabase db,
            String userId) throws ServletException, IOException {
        request.setAttribute("packages", TravelRepository.listPackages(db));
        request.setAttribute("places", TravelRepository.listPlaces(db, 8));
        request.setAttribute("routes", TravelRepository.listFlightRoutes(db, 12));
        request.setAttribute("recPackages", TravelRepository.recommendPackages(db, userId, 3));
        request.setAttribute("recPlaces", TravelRepository.recommendPlaces(db, userId, 3));
        request.getRequestDispatcher("WEB-INF/explore.jsp").forward(request, response);
    }

    private void forwardStayNearby(HttpServletRequest request, HttpServletResponse response, MongoDatabase db)
            throws ServletException, IOException {
        String placeId = request.getParameter("placeId");
        List<Document> places = TravelRepository.listPlaces(db, 24);
        request.setAttribute("places", places);
        Document selected = null;
        if (placeId != null && !placeId.isBlank()) {
            selected = TravelRepository.findPlaceById(db, placeId);
        }
        if (selected == null && !places.isEmpty()) {
            selected = places.get(0);
        }
        request.setAttribute("selectedPlace", selected);
        if (selected != null) {
            String near = selected.getString("nearCity");
            List<Document> nearbyHotels = TravelRepository.listHotelsByCity(db, near != null ? near : "");
            request.setAttribute("nearbyHotels", nearbyHotels);
        } else {
            request.setAttribute("nearbyHotels", List.of());
        }
        request.getRequestDispatcher("WEB-INF/nearby.jsp").forward(request, response);
    }

    private void forwardSuccess(HttpServletRequest request, HttpServletResponse response, HttpSession session)
            throws ServletException, IOException {
        Document last = (Document) session.getAttribute("lastBooking");
        if (last == null) {
            response.sendRedirect("booking?action=dashboard");
            return;
        }
        String type = last.getString("type");
        if (type != null) {
            type = type.toLowerCase();
        }
        int total = last.getInteger("totalAmount") != null ? last.getInteger("totalAmount")
                : last.getInteger("totalFare", 0);
        request.setAttribute("title", "Booking confirmed");
        request.setAttribute("subtitle", "Thank you — your reservation is saved to your SkyWay dashboard.");
        request.setAttribute("bookingRef", last.getObjectId("_id").toHexString());
        request.setAttribute("totalFare", total);

        List<String[]> extra = new ArrayList<>();
        Document d = last.get("details", Document.class);
        if ("flight".equals(type)) {
            if (d != null) {
                extra.add(new String[] { "Route", d.getString("from") + " → " + d.getString("to") });
                extra.add(new String[] { "Airline", last.getString("airline") != null ? last.getString("airline") : "—" });
                if (d.getString("departure") != null) {
                    extra.add(new String[] { "Departure", d.getString("departure") });
                }
            }
        } else if ("hotel".equals(type)) {
            if (d != null) {
                extra.add(new String[] { "Hotel", d.getString("hotelName") });
                extra.add(new String[] { "City", d.getString("city") });
                if (d.getInteger("nights") != null) {
                    extra.add(new String[] { "Nights", String.valueOf(d.getInteger("nights")) });
                }
            }
        } else if ("package".equals(type)) {
            if (d != null) {
                extra.add(new String[] { "Package", d.getString("packageName") });
                extra.add(new String[] { "Destination", d.getString("destination") });
            }
        }
        request.setAttribute("extraLines", extra);
        request.getRequestDispatcher("WEB-INF/booking-confirmation.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        if (session.getAttribute("user") == null) {
            response.sendRedirect("auth?action=signin");
            return;
        }

        String action = request.getParameter("action");
        MongoDatabase db = MongoUtil.getDatabase();
        String userId = (String) session.getAttribute("user");

        if (action == null) {
            response.sendRedirect("booking?action=dashboard");
            return;
        }

        switch (action) {
            case "flightBooking" -> handleFlightPreview(request, response, db);
            case "confirmFlightBooking" -> handleFlightConfirm(request, response, session, db, userId);
            case "bookHotel" -> handleHotelBook(request, response, session, db, userId);
            case "bookPackage" -> handlePackageBook(request, response, session, db, userId);
            default -> response.sendRedirect("booking?action=dashboard");
        }
    }

    private void handleFlightPreview(HttpServletRequest request, HttpServletResponse response, MongoDatabase db)
            throws ServletException, IOException {
        String from = request.getParameter("from");
        String to = request.getParameter("to");
        String departure = request.getParameter("departure");
        String returnDate = request.getParameter("returnDate");
        String passengersStr = request.getParameter("passengers");
        String travelClass = request.getParameter("travelClass");

        int passengers = 1;
        try {
            passengers = Integer.parseInt(passengersStr);
        } catch (Exception e) {
            passengers = 1;
        }

        Document route = TravelRepository.findRoute(db, from, to);
        int estFare = TravelRepository.estimateFlightFare(route, passengers, travelClass);

        request.setAttribute("from", from);
        request.setAttribute("to", to);
        request.setAttribute("departure", departure != null ? departure : "");
        request.setAttribute("returnDate", returnDate != null ? returnDate : "—");
        request.setAttribute("passengers", passengers);
        request.setAttribute("travelClass", travelClass != null ? travelClass : "Economy");
        request.setAttribute("estFare", estFare);
        request.setAttribute("totalAmount", estFare);

        if (route != null) {
            request.setAttribute("airline", route.getString("airline"));
            request.setAttribute("duration", route.getString("duration"));
        } else {
            request.setAttribute("airline", "SkyWay Air (Charter)");
            request.setAttribute("duration", "Varies");
        }

        request.getRequestDispatcher("WEB-INF/summary.jsp").forward(request, response);
    }

    private void handleFlightConfirm(HttpServletRequest request, HttpServletResponse response, HttpSession session,
            MongoDatabase db, String userId) throws IOException {
        String from = request.getParameter("from");
        String to = request.getParameter("to");
        String departure = request.getParameter("departure");
        String returnDate = request.getParameter("returnDate");
        int passengers = parsePositiveInt(request.getParameter("passengers"), 1);
        String travelClass = request.getParameter("travelClass");
        String airline = request.getParameter("airline");
        int total = parsePositiveInt(request.getParameter("totalAmount"), 0);

        Document details = new Document().append("from", from).append("to", to).append("departure",
                departure != null ? departure : "").append("returnDate", returnDate != null ? returnDate : "")
                .append("passengers", passengers).append("travelClass", travelClass != null ? travelClass : "Economy");

        Document booking = new Document().append("userId", userId).append("type", "flight").append("totalAmount", total)
                .append("details", details).append("airline", airline != null ? airline : "SkyWay");

        TravelRepository.insertBooking(db, booking);
        session.setAttribute("lastBooking", booking);
        response.sendRedirect("booking?action=success");
    }

    private void handleHotelBook(HttpServletRequest request, HttpServletResponse response, HttpSession session,
            MongoDatabase db, String userId) throws IOException {
        String hotelId = request.getParameter("hotelId");
        int nights = parsePositiveInt(request.getParameter("nights"), 1);
        Document hotel = TravelRepository.findHotelById(db, hotelId);
        if (hotel == null) {
            response.sendRedirect("booking?action=hotel");
            return;
        }
        int perNight = hotel.getInteger("pricePerNight", 0);
        int total = Math.max(0, perNight * Math.max(1, nights));
        Document details = new Document().append("hotelId", hotelId).append("hotelName", hotel.getString("name"))
                .append("city", hotel.getString("city")).append("nights", nights).append("pricePerNight", perNight);

        Document booking = new Document().append("userId", userId).append("type", "hotel").append("totalAmount", total)
                .append("details", details);

        TravelRepository.insertBooking(db, booking);
        session.setAttribute("lastBooking", booking);
        response.sendRedirect("booking?action=success");
    }

    private void handlePackageBook(HttpServletRequest request, HttpServletResponse response, HttpSession session,
            MongoDatabase db, String userId) throws IOException {
        String packageId = request.getParameter("packageId");
        Document pkg = TravelRepository.findPackageById(db, packageId);
        if (pkg == null) {
            response.sendRedirect("booking?action=package");
            return;
        }
        int price = pkg.getInteger("price", 0);
        Document details = new Document().append("packageId", packageId).append("packageName", pkg.getString("name"))
                .append("destination", pkg.getString("destination")).append("days", pkg.getInteger("days", 0));

        Document booking = new Document().append("userId", userId).append("type", "package").append("totalAmount", price)
                .append("details", details);

        TravelRepository.insertBooking(db, booking);
        session.setAttribute("lastBooking", booking);
        response.sendRedirect("booking?action=success");
    }

    private static int parsePositiveInt(String s, int def) {
        try {
            int v = Integer.parseInt(s);
            return v > 0 ? v : def;
        } catch (Exception e) {
            return def;
        }
    }
}
