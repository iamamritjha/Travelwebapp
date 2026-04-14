<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="org.bson.Document" %>
<%@ page import="org.bson.types.ObjectId" %>
<%
if (session.getAttribute("user") == null) {
    response.sendRedirect("auth?action=signin");
    return;
}
@SuppressWarnings("unchecked")
List<Document> places = (List<Document>) request.getAttribute("places");
@SuppressWarnings("unchecked")
List<Document> recPackages = (List<Document>) request.getAttribute("recPackages");
@SuppressWarnings("unchecked")
List<Document> recPlaces = (List<Document>) request.getAttribute("recPlaces");
@SuppressWarnings("unchecked")
List<Document> recentBookings = (List<Document>) request.getAttribute("recentBookings");
Integer totalBookings = (Integer) request.getAttribute("totalBookings");
String displayName = (String) session.getAttribute("displayName");
if (displayName == null || displayName.isBlank()) {
    displayName = (String) session.getAttribute("user");
}
%>
<!DOCTYPE html>
<html lang="en">
<head>
<title>Your hub · SkyWay</title>
<%@ include file="partials/head-common.jspf" %>
</head>
<body class="sw-body sw-layout">
<%@ include file="partials/sidebar.jspf" %>
<main class="sw-main">
<div class="sw-wrap">
  <div class="sw-hero">
    <h1>Welcome back, <%= displayName %></h1>
    <p>Plan trips, lock stays, and track everything here — bookings stay private to your account.</p>
    <div style="margin-top:14px;">
      <span class="sw-pill">Signed in as <strong style="color:#e2e8f0;"><%= session.getAttribute("user") %></strong></span>
      <span class="sw-pill">Total bookings · <strong style="color:#e2e8f0;"><%= totalBookings != null ? totalBookings : 0 %></strong></span>
    </div>
  </div>

  <div class="sw-dash-hero">
    <div class="sw-stat">
      <div class="label" style="color:var(--muted);font-size:0.8rem;text-transform:uppercase;letter-spacing:0.08em;">Your travel snapshot</div>
      <div class="big" style="margin-top:8px;">Personalized picks</div>
      <p class="sw-lead" style="margin-top:10px;">
        Recommendations below use a simple content-based engine: we read cities and destinations from <em>your</em> past bookings
        and rank packages and places that match those signals.
      </p>
      <div class="sw-actions" style="margin-top:14px;">
        <a class="sw-btn" href="booking?action=flight">Book a flight</a>
        <a class="sw-btn sw-btn-secondary" href="booking?action=hotel">Book a hotel</a>
        <a class="sw-btn sw-btn-secondary" href="booking?action=package">View packages</a>
      </div>
    </div>
    <div class="sw-stat">
      <div class="label" style="color:var(--muted);font-size:0.8rem;text-transform:uppercase;letter-spacing:0.08em;">Recent activity</div>
<% if (recentBookings == null || recentBookings.isEmpty()) { %>
      <p class="sw-lead" style="margin-top:12px;">No bookings yet — start with Explore or book a flight.</p>
<% } else { %>
      <div style="margin-top:12px;">
<%   for (Document b : recentBookings) {
       ObjectId oid = b.getObjectId("_id");
       String ref = oid != null ? oid.toHexString() : "";
       String type = b.getString("type");
       int amt = b.getInteger("totalAmount", 0);
%>
        <div class="sw-route-row">
          <div>
            <div style="color:var(--muted);font-size:0.8rem;">#<%= ref.length() > 10 ? ref.substring(0, 10) + "…" : ref %></div>
            <strong><%= type != null ? type : "booking" %></strong>
          </div>
          <div style="text-align:right;">
            <div style="color:var(--success);font-weight:800;">₹ <%= amt %></div>
            <div style="color:var(--muted);font-size:0.85rem;">Confirmed</div>
          </div>
        </div>
<%   } %>
      </div>
      <a class="sw-btn sw-btn-ghost" href="booking?action=mybookings" style="margin-top:10px;">View all bookings</a>
<% } %>
    </div>
  </div>

  <h2 class="sw-section-title">Quick modules</h2>
  <div class="sw-tiles">
    <a class="sw-tile" href="booking?action=flight">
      <div class="sw-icon" aria-hidden="true"><svg viewBox="0 0 24 24"><path d="M21 16v-2l-8-5V3.5c0-.83-.67-1.5-1.5-1.5S10 2.67 10 3.5V9l-8 5v2l8-2.5V19l-2 1.5V22l3.5-1 3.5 1v-1.5L13 19v-5.5l8 2.5z"/></svg></div>
      <h3>Flights</h3>
      <p>Search routes, pick cabin class, and confirm with a fare estimate.</p>
    </a>
    <a class="sw-tile" href="booking?action=hotel">
      <div class="sw-icon" aria-hidden="true"><svg viewBox="0 0 24 24"><path d="M7 13c1.66 0 3-1.34 3-3S8.66 7 7 7s-3 1.34-3 3 1.34 3 3 3zm12-6h-8v7H3V5H1v15h2v-3h18v3h2v-9c0-2.21-1.79-4-4-4z"/></svg></div>
      <h3>Hotels</h3>
      <p>Curated stays with nightly rates from MongoDB.</p>
    </a>
    <a class="sw-tile" href="booking?action=package">
      <div class="sw-icon" aria-hidden="true"><svg viewBox="0 0 24 24"><path d="M12 2C6.48 2 2 6.48 2 12s4.48 10 10 10 10-4.48 10-10S17.52 2 12 2zm-1 17.93c-3.95-.49-7-3.85-7-7.93 0-.62.08-1.21.21-1.79L9 15v1c0 1.1.9 2 2 2v1.93zm6.9-2.54c-.26-.81-1-1.39-1.9-1.39h-1v-3c0-.55-.45-1-1-1H8v-2h2c.55 0 1-.45 1-1V7h2c1.1 0 2-.9 2-2v-.41c2.93 1.19 5 4.06 5 7.41 0 2.08-.8 3.97-2.1 5.39z"/></svg></div>
      <h3>Packages</h3>
      <p>Multi-day bundles with highlights and transparent pricing.</p>
    </a>
    <a class="sw-tile" href="booking?action=explore">
      <div class="sw-icon" aria-hidden="true"><svg viewBox="0 0 24 24"><path d="M20.5 3l-.16.03L15 5.1 9 3 3.36 4.9c-.21.07-.36.25-.36.48V20.5c0 .28.22.5.5.5l.16-.03L9 18.9l6 2.1 5.64-1.9c.21-.07.36-.25.36-.48V3.5c0-.28-.22-.5-.5-.5zM15 19l-6-2.11V5l6 2.11V19z"/></svg></div>
      <h3>Explore hub</h3>
      <p>Routes, destinations, and recommendations in one place.</p>
    </a>
    <a class="sw-tile" href="booking?action=stayNearby">
      <div class="sw-icon" aria-hidden="true"><svg viewBox="0 0 24 24"><path d="M21 10c0 7-9 13-9 13s-9-6-9-13a9 9 0 0 1 18 0z"/><circle cx="12" cy="10" r="3"/></svg></div>
      <h3>Stay nearby</h3>
      <p>Spotlight destinations and hotels in partner cities.</p>
    </a>
    <a class="sw-tile" href="booking?action=places">
      <div class="sw-icon" aria-hidden="true"><svg viewBox="0 0 24 24"><path d="M12 2l3.09 6.26L22 9.27l-5 4.87 1.18 6.88L12 17.77l-6.18 3.25L7 14.14 2 9.27l6.91-1.01L12 2z"/></svg></div>
      <h3>Curated places</h3>
      <p>Editorial picks with seasons and tags.</p>
    </a>
  </div>

  <h2 class="sw-section-title">Recommended packages</h2>
  <div class="sw-grid">
<% if (recPackages != null) {
     for (Document p : recPackages) {
       String name = p.getString("name");
       String dest = p.getString("destination");
       int price = p.getInteger("price", 0);
       String img = p.getString("imageUrl");
       String id = p.getObjectId("_id").toHexString();
%>
    <article class="sw-card">
      <img class="sw-card-img" src="<%= img %>" alt="<%= name %>">
      <div class="sw-card-body">
        <h3><%= name %></h3>
        <p><%= dest %></p>
        <div class="sw-price">From ₹ <%= price %></div>
        <form method="post" action="booking" style="margin-top:12px;">
          <input type="hidden" name="action" value="bookPackage">
          <input type="hidden" name="packageId" value="<%= id %>">
          <button type="submit" class="sw-btn" style="width:100%;">Book package</button>
        </form>
      </div>
    </article>
<%   }
   } %>
  </div>

  <h2 class="sw-section-title">Recommended places for you</h2>
  <div class="sw-grid">
<% if (recPlaces != null) {
     for (Document p : recPlaces) {
       String name = p.getString("name");
       String country = p.getString("country");
       String why = p.getString("whyVisit");
       String img = p.getString("imageUrl");
       String near = p.getString("nearCity");
%>
    <article class="sw-card">
      <img class="sw-card-img" src="<%= img %>" alt="<%= name %>">
      <div class="sw-card-body">
        <h3><%= name %></h3>
        <p><%= country %> · Nearby stays mapped to <strong style="color:#e2e8f0;"><%= near != null ? near : "—" %></strong></p>
        <p><%= why %></p>
        <a class="sw-btn sw-btn-secondary" style="margin-top:10px;display:inline-flex;" href="booking?action=stayNearby&placeId=<%= p.getObjectId("_id").toHexString() %>">Find stays</a>
      </div>
    </article>
<%   }
   } %>
  </div>

  <h2 class="sw-section-title">Destination highlights</h2>
  <div class="sw-grid">
<% if (places != null) {
     for (Document p : places) {
       String name = p.getString("name");
       String country = p.getString("country");
       String season = p.getString("bestSeason");
       String img = p.getString("imageUrl");
%>
    <article class="sw-card">
      <img class="sw-card-img" src="<%= img %>" alt="<%= name %>">
      <div class="sw-card-body">
        <h3><%= name %></h3>
        <p class="sw-meta"><%= country %> · Best <%= season %></p>
      </div>
    </article>
<%   }
   } %>
  </div>
</div>
</main>
</body>
</html>
