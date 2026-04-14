package com.amrit;

import java.util.ArrayList;
import java.util.Collections;
import java.util.Comparator;
import java.util.Date;
import java.util.HashSet;
import java.util.List;
import java.util.Locale;
import java.util.Set;

import org.bson.Document;
import org.bson.types.ObjectId;

import com.mongodb.client.MongoCollection;
import com.mongodb.client.MongoDatabase;
import com.mongodb.client.model.Filters;
import com.mongodb.client.model.Sorts;

/**
 * MongoDB access for hotels, packages, places, flight routes, and user bookings.
 */
public final class TravelRepository {

    private static volatile boolean seeded;

    private TravelRepository() {
    }

    public static void ensureSeed(MongoDatabase db) {
        if (seeded) {
            return;
        }
        synchronized (TravelRepository.class) {
            if (seeded) {
                return;
            }
            seedHotels(db);
            seedPackages(db);
            seedPlaces(db);
            seedFlightRoutes(db);
            seeded = true;
        }
    }

    private static void seedHotels(MongoDatabase db) {
        MongoCollection<Document> c = db.getCollection("hotels");
        if (c.countDocuments(new Document()) > 0) {
            return;
        }
        c.insertMany(List.of(
                new Document("name", "Hilton Skyline").append("city", "Mumbai").append("country", "India")
                        .append("imageUrl", "https://images.unsplash.com/photo-1566073771259-6a8506099945?w=800")
                        .append("pricePerNight", 8999).append("rating", 4.7).append("description",
                                "Infinity pool, spa, and airport shuttle."),
                new Document("name", "Marriott Grand").append("city", "Delhi").append("country", "India")
                        .append("imageUrl", "https://images.unsplash.com/photo-1582719508461-905c673771fd?w=800")
                        .append("pricePerNight", 7499).append("rating", 4.6).append("description",
                                "Business lounge and metro-linked location."),
                new Document("name", "Taj Palace").append("city", "Jaipur").append("country", "India")
                        .append("imageUrl", "https://images.unsplash.com/photo-1590490360182-c33d57733427?w=800")
                        .append("pricePerNight", 12499).append("rating", 4.9).append("description",
                                "Heritage suites and royal dining."),
                new Document("name", "Azure Resort").append("city", "Goa").append("country", "India")
                        .append("imageUrl", "https://images.unsplash.com/photo-1520250497591-112f2f40a3f4?w=800")
                        .append("pricePerNight", 11299).append("rating", 4.8).append("description",
                                "Beachfront villas and water sports."),
                new Document("name", "Nordic Lodge").append("city", "Bergen").append("country", "Norway")
                        .append("imageUrl", "https://images.unsplash.com/photo-1518548419970-58e3b4079ab2?w=800")
                        .append("pricePerNight", 18999).append("rating", 4.7).append("description",
                                "Fjord views and Nordic breakfast."),
                new Document("name", "Desert Oasis").append("city", "Dubai").append("country", "UAE")
                        .append("imageUrl", "https://images.unsplash.com/photo-1512453979798-5ea266f8880c?w=800")
                        .append("pricePerNight", 15999).append("rating", 4.8).append("description",
                                "Sky pool and desert safari desk.")));
    }

    private static void seedPackages(MongoDatabase db) {
        MongoCollection<Document> c = db.getCollection("travel_packages");
        if (c.countDocuments(new Document()) > 0) {
            return;
        }
        c.insertMany(List.of(
                new Document("name", "Paris Romance").append("destination", "Paris, France").append("days", 5)
                        .append("imageUrl", "https://images.unsplash.com/photo-1502602898657-3e91760cbb34?w=800")
                        .append("price", 120000).append("highlights", "Eiffel Tower, Seine cruise, Louvre pass"),
                new Document("name", "Maldives Escape").append("destination", "Maldives").append("days", 4)
                        .append("imageUrl", "https://images.unsplash.com/photo-1507525428034-b723cf961d3e?w=800")
                        .append("price", 180000).append("highlights", "Water villa, snorkeling, half-board"),
                new Document("name", "Dubai Luxury").append("destination", "Dubai, UAE").append("days", 5)
                        .append("imageUrl", "https://images.unsplash.com/photo-1512453979798-5ea266f8880c?w=800")
                        .append("price", 140000).append("highlights", "Burj Khalifa, desert safari, yacht dinner"),
                new Document("name", "Swiss Alps").append("destination", "Interlaken, Switzerland").append("days", 6)
                        .append("imageUrl", "https://images.unsplash.com/photo-1530122037265-a5f1f91d3b99?w=800")
                        .append("price", 210000).append("highlights", "Jungfrau train, lakes, chocolate tour"),
                new Document("name", "Tokyo & Kyoto").append("destination", "Japan").append("days", 7)
                        .append("imageUrl", "https://images.unsplash.com/photo-1540959733332-eab4deabeeaf?w=800")
                        .append("price", 195000).append("highlights", "Bullet train, temples, sushi masterclass"),
                new Document("name", "Bali Bliss").append("destination", "Bali, Indonesia").append("days", 5)
                        .append("imageUrl", "https://images.unsplash.com/photo-1537996194471-e657df975ab4?w=800")
                        .append("price", 95000).append("highlights", "Ubud rice terraces, spa, beach clubs")));
    }

    private static void seedPlaces(MongoDatabase db) {
        MongoCollection<Document> c = db.getCollection("recommended_places");
        if (c.countDocuments(new Document()) > 0) {
            return;
        }
        c.insertMany(List.of(
                new Document("name", "Santorini").append("country", "Greece").append("bestSeason", "Apr–Oct")
                        .append("nearCity", "Dubai")
                        .append("tags", List.of("Islands", "Sunset", "Honeymoon"))
                        .append("whyVisit", "Iconic white villages and caldera views.")
                        .append("imageUrl", "https://images.unsplash.com/photo-1613395877344-13d4c79e4284?w=800"),
                new Document("name", "Kyoto").append("country", "Japan").append("bestSeason", "Mar–May, Oct–Nov")
                        .append("nearCity", "Mumbai")
                        .append("tags", List.of("Culture", "Temples", "Food"))
                        .append("whyVisit", "Geisha districts, bamboo groves, kaiseki dining.")
                        .append("imageUrl", "https://images.unsplash.com/photo-1493976040374-85c8e12ec0d8?w=800"),
                new Document("name", "Banff").append("country", "Canada").append("bestSeason", "Jun–Sep, Dec–Mar")
                        .append("nearCity", "Bergen")
                        .append("tags", List.of("Nature", "Hiking", "Ski"))
                        .append("whyVisit", "Turquoise lakes and Rocky Mountain peaks.")
                        .append("imageUrl", "https://images.unsplash.com/photo-1503614472-8c93e56e8ce1?w=800"),
                new Document("name", "Lisbon").append("country", "Portugal").append("bestSeason", "Mar–Jun, Sep–Nov")
                        .append("nearCity", "Dubai")
                        .append("tags", List.of("City break", "Coast", "Nightlife"))
                        .append("whyVisit", "Trams, tiles, pastel de nata, and nearby Sintra.")
                        .append("imageUrl", "https://images.unsplash.com/photo-1585208798176-8afe7d7cbd4c?w=800"),
                new Document("name", "Queenstown").append("country", "New Zealand").append("bestSeason", "Dec–Feb")
                        .append("nearCity", "Goa")
                        .append("tags", List.of("Adventure", "Lake", "Scenic"))
                        .append("whyVisit", "Bungee, fjords, and Milford Sound day trips.")
                        .append("imageUrl", "https://images.unsplash.com/photo-1507699622108-4be3abd695ad?w=800"),
                new Document("name", "Hampi").append("country", "India").append("bestSeason", "Oct–Feb")
                        .append("nearCity", "Jaipur")
                        .append("tags", List.of("Heritage", "Boulders", "Budget"))
                        .append("whyVisit", "UNESCO ruins and surreal granite landscapes.")
                        .append("imageUrl", "https://images.unsplash.com/photo-1590054008627-292886091776?w=800")));
    }

    private static void seedFlightRoutes(MongoDatabase db) {
        MongoCollection<Document> c = db.getCollection("flight_routes");
        if (c.countDocuments(new Document()) > 0) {
            return;
        }
        c.insertMany(List.of(
                new Document("fromCity", "Mumbai").append("toCity", "Dubai").append("airline", "SkyWay Express")
                        .append("baseFare", 18500).append("duration", "3h 10m"),
                new Document("fromCity", "Delhi").append("toCity", "London").append("airline", "SkyWay Express")
                        .append("baseFare", 42000).append("duration", "9h 30m"),
                new Document("fromCity", "Bengaluru").append("toCity", "Singapore").append("airline", "SkyWay Express")
                        .append("baseFare", 16500).append("duration", "4h 25m"),
                new Document("fromCity", "Mumbai").append("toCity", "Maldives").append("airline", "SkyWay Express")
                        .append("baseFare", 22000).append("duration", "2h 45m"),
                new Document("fromCity", "Chennai").append("toCity", "Colombo").append("airline", "SkyWay Express")
                        .append("baseFare", 8900).append("duration", "1h 20m"),
                new Document("fromCity", "Delhi").append("toCity", "Paris").append("airline", "SkyWay Express")
                        .append("baseFare", 38500).append("duration", "8h 50m")));
    }

    public static List<Document> listHotels(MongoDatabase db) {
        ensureSeed(db);
        List<Document> out = new ArrayList<>();
        db.getCollection("hotels").find().sort(Sorts.ascending("name")).into(out);
        return out;
    }

    public static Document findHotelById(MongoDatabase db, String id) {
        ensureSeed(db);
        try {
            return db.getCollection("hotels").find(Filters.eq("_id", new ObjectId(id))).first();
        } catch (IllegalArgumentException e) {
            return null;
        }
    }

    public static List<Document> listPackages(MongoDatabase db) {
        ensureSeed(db);
        List<Document> out = new ArrayList<>();
        db.getCollection("travel_packages").find().sort(Sorts.ascending("name")).into(out);
        return out;
    }

    public static Document findPackageById(MongoDatabase db, String id) {
        ensureSeed(db);
        try {
            return db.getCollection("travel_packages").find(Filters.eq("_id", new ObjectId(id))).first();
        } catch (IllegalArgumentException e) {
            return null;
        }
    }

    public static List<Document> listPlaces(MongoDatabase db, int limit) {
        ensureSeed(db);
        List<Document> out = new ArrayList<>();
        db.getCollection("recommended_places").find().sort(Sorts.ascending("name")).limit(limit).into(out);
        return out;
    }

    public static Document findRoute(MongoDatabase db, String fromCity, String toCity) {
        ensureSeed(db);
        return db.getCollection("flight_routes")
                .find(Filters.and(Filters.regex("fromCity", "^" + escapeRegex(fromCity) + "$", "i"),
                        Filters.regex("toCity", "^" + escapeRegex(toCity) + "$", "i")))
                .first();
    }

    private static String escapeRegex(String s) {
        if (s == null) {
            return "";
        }
        return s.replace("\\", "\\\\").replace(".", "\\.").replace("*", "\\*").replace("+", "\\+")
                .replace("?", "\\?").replace("^", "\\^").replace("$", "\\$").replace("[", "\\[")
                .replace("]", "\\]").replace("(", "\\(").replace(")", "\\)").replace("{", "\\{")
                .replace("}", "\\}").replace("|", "\\|");
    }

    public static double classMultiplier(String travelClass) {
        if (travelClass == null) {
            return 1.0;
        }
        return switch (travelClass) {
            case "Business" -> 2.2;
            case "First Class" -> 3.5;
            default -> 1.0;
        };
    }

    public static int estimateFlightFare(Document route, int passengers, String travelClass) {
        if (route == null) {
            return 12500 * Math.max(1, passengers);
        }
        int base = route.getInteger("baseFare", 15000);
        double mult = classMultiplier(travelClass);
        return (int) Math.round(base * mult * Math.max(1, passengers));
    }

    /** Persists booking with a client-generated {@code _id} for immediate reference on receipts. */
    public static void insertBooking(MongoDatabase db, Document booking) {
        ensureSeed(db);
        if (!booking.containsKey("_id")) {
            booking.append("_id", new ObjectId());
        }
        booking.append("createdAt", new Date());
        if (!booking.containsKey("status")) {
            booking.append("status", "confirmed");
        }
        db.getCollection("bookings").insertOne(booking);
    }

    public static List<Document> listBookingsForUser(MongoDatabase db, String userId) {
        ensureSeed(db);
        List<Document> out = loadBookingsRaw(db, userId);
        for (Document b : out) {
            normalizeBookingForView(b);
        }
        return out;
    }

    private static List<Document> loadBookingsRaw(MongoDatabase db, String userId) {
        List<Document> out = new ArrayList<>();
        db.getCollection("bookings").find(Filters.eq("userId", userId)).sort(Sorts.descending("createdAt")).into(out);
        return out;
    }

    public static int countBookingsForUser(MongoDatabase db, String userId) {
        ensureSeed(db);
        return (int) db.getCollection("bookings").countDocuments(Filters.eq("userId", userId));
    }

    public static List<Document> listHotelsByCity(MongoDatabase db, String city) {
        ensureSeed(db);
        List<Document> out = new ArrayList<>();
        if (city == null || city.isBlank()) {
            return listHotels(db);
        }
        db.getCollection("hotels")
                .find(Filters.regex("city", "^" + escapeRegex(city.trim()) + "$", "i"))
                .sort(Sorts.ascending("name"))
                .into(out);
        return out;
    }

    public static List<Document> listFlightRoutes(MongoDatabase db, int limit) {
        ensureSeed(db);
        List<Document> out = new ArrayList<>();
        db.getCollection("flight_routes").find().sort(Sorts.ascending("fromCity", "toCity")).limit(Math.max(1, limit))
                .into(out);
        return out;
    }

    public static Document findPlaceById(MongoDatabase db, String id) {
        ensureSeed(db);
        try {
            return db.getCollection("recommended_places").find(Filters.eq("_id", new ObjectId(id))).first();
        } catch (IllegalArgumentException e) {
            return null;
        }
    }

    /**
     * Simple content-based recommendations from past booking text (destinations, cities, routes).
     */
    public static List<Document> recommendPackages(MongoDatabase db, String userId, int limit) {
        ensureSeed(db);
        Set<String> tokens = extractPreferenceTokens(db, userId);
        List<Document> all = listPackages(db);
        List<Document> copy = new ArrayList<>(all);
        copy.sort(Comparator.comparingInt((Document p) -> -scoreAgainstTokens(
                (p.getString("destination") + " " + p.getString("name")).toLowerCase(Locale.ROOT), tokens)));
        if (tokens.isEmpty()) {
            Collections.shuffle(copy);
        }
        return copy.subList(0, Math.min(Math.max(1, limit), copy.size()));
    }

    public static List<Document> recommendPlaces(MongoDatabase db, String userId, int limit) {
        ensureSeed(db);
        Set<String> tokens = extractPreferenceTokens(db, userId);
        List<Document> all = new ArrayList<>();
        db.getCollection("recommended_places").find().into(all);
        all.sort(Comparator.comparingInt((Document p) -> {
            java.util.List<String> tags = p.getList("tags", String.class);
            String tagStr = tags == null ? "" : String.join(" ", tags);
            String text = (p.getString("country") + " " + p.getString("name") + " " + tagStr).toLowerCase(Locale.ROOT);
            return -scoreAgainstTokens(text, tokens);
        }));
        if (tokens.isEmpty()) {
            Collections.shuffle(all);
        }
        return all.subList(0, Math.min(Math.max(1, limit), all.size()));
    }

    private static int scoreAgainstTokens(String text, Set<String> tokens) {
        int score = 0;
        if (text == null || text.isBlank()) {
            return 0;
        }
        String t = text.toLowerCase(Locale.ROOT);
        for (String tok : tokens) {
            if (tok.length() < 3) {
                continue;
            }
            if (t.contains(tok)) {
                score += 2;
            }
        }
        return score;
    }

    private static Set<String> extractPreferenceTokens(MongoDatabase db, String userId) {
        Set<String> tokens = new HashSet<>();
        for (Document b : loadBookingsRaw(db, userId)) {
            collectTokensFromBooking(b, tokens);
        }
        return tokens;
    }

    private static void collectTokensFromBooking(Document b, Set<String> tokens) {
        String type = b.getString("type");
        if (type != null) {
            type = type.toLowerCase(Locale.ROOT);
        }
        Document d = b.get("details", Document.class);
        if (d != null) {
            if ("flight".equals(type)) {
                addTokens(tokens, d.getString("to"));
                addTokens(tokens, d.getString("from"));
            } else if ("hotel".equals(type)) {
                addTokens(tokens, d.getString("city"));
            } else if ("package".equals(type)) {
                addTokens(tokens, d.getString("destination"));
            }
            return;
        }
        if ("flight".equals(type)) {
            addTokens(tokens, b.getString("to"));
            addTokens(tokens, b.getString("from"));
        } else if ("hotel".equals(type)) {
            addTokens(tokens, b.getString("city"));
        } else if ("package".equals(type)) {
            addTokens(tokens, b.getString("destination"));
        }
    }

    private static void addTokens(Set<String> tokens, String raw) {
        if (raw == null || raw.isBlank()) {
            return;
        }
        String s = raw.toLowerCase(Locale.ROOT);
        tokens.add(s);
        for (String part : s.split("[,\\s/]+")) {
            if (part.length() >= 3) {
                tokens.add(part);
            }
        }
    }

    private static void normalizeBookingForView(Document b) {
        String t = b.getString("type");
        if (t != null) {
            b.put("type", t.toLowerCase(Locale.ROOT));
        }
        if (b.getInteger("totalAmount") == null) {
            b.put("totalAmount", b.getInteger("totalFare", 0));
        }
        if (b.get("details") == null) {
            Document d = new Document();
            String type = b.getString("type");
            if ("flight".equals(type)) {
                d.append("from", nz(b.getString("from"))).append("to", nz(b.getString("to")));
                Object pax = b.get("passengers");
                if (pax != null) {
                    d.append("passengers", pax);
                }
                if (b.getString("travelClass") != null) {
                    d.append("travelClass", b.getString("travelClass"));
                }
            } else if ("hotel".equals(type)) {
                d.append("hotelName", nz(b.getString("name"))).append("city", nz(b.getString("city")));
            } else if ("package".equals(type)) {
                d.append("packageName", nz(b.getString("name"))).append("destination", nz(b.getString("destination")));
            }
            b.put("details", d);
        }
    }

    private static String nz(String s) {
        return s == null ? "" : s;
    }
}
