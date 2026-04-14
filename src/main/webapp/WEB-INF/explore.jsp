<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="org.bson.Document" %>
<%
if (session.getAttribute("user") == null) {
    response.sendRedirect("auth?action=signin");
    return;
}
@SuppressWarnings("unchecked")
List<Document> packages = (List<Document>) request.getAttribute("packages");
@SuppressWarnings("unchecked")
List<Document> places = (List<Document>) request.getAttribute("places");
@SuppressWarnings("unchecked")
List<Document> routes = (List<Document>) request.getAttribute("routes");
@SuppressWarnings("unchecked")
List<Document> recPackages = (List<Document>) request.getAttribute("recPackages");
@SuppressWarnings("unchecked")
List<Document> recPlaces = (List<Document>) request.getAttribute("recPlaces");
%>
<!DOCTYPE html>
<html lang="en">
<head>
<title>Explore hub · SkyWay</title>
<%@ include file="partials/head-common.jspf" %>
</head>
<body class="sw-body sw-layout">
<%@ include file="partials/sidebar.jspf" %>
<main class="sw-main">
<div class="sw-wrap">
  <div class="sw-hero">
    <h1>Explore hub</h1>
    <p class="sw-lead">Flights, packages, and hand-picked destinations — with recommendations tuned to what you already book.</p>
  </div>

  <h2 class="sw-section-title">Top picks for you</h2>
  <div class="sw-grid sw-grid--tight">
<% if (recPackages != null) {
     for (Document p : recPackages) {
       String id = p.getObjectId("_id").toHexString();
%>
    <article class="sw-card">
      <img class="sw-card-img" src="<%= p.getString("imageUrl") %>" alt="<%= p.getString("name") %>">
      <div class="sw-card-body">
        <h3><%= p.getString("name") %></h3>
        <p><%= p.getString("destination") %></p>
        <div class="sw-price">₹ <%= p.getInteger("price", 0) %></div>
        <form method="post" action="booking" style="margin-top:10px;">
          <input type="hidden" name="action" value="bookPackage">
          <input type="hidden" name="packageId" value="<%= id %>">
          <button type="submit" class="sw-btn" style="width:100%;">Book</button>
        </form>
      </div>
    </article>
<%   }
   } %>
<% if (recPlaces != null) {
     for (Document p : recPlaces) { %>
    <article class="sw-card">
      <img class="sw-card-img" src="<%= p.getString("imageUrl") %>" alt="<%= p.getString("name") %>">
      <div class="sw-card-body">
        <h3><%= p.getString("name") %></h3>
        <p><%= p.getString("country") %></p>
        <a class="sw-btn sw-btn-secondary" href="booking?action=stayNearby&placeId=<%= p.getObjectId("_id").toHexString() %>">Nearby stays</a>
      </div>
    </article>
<%   }
   } %>
  </div>

  <h2 class="sw-section-title">Featured routes</h2>
<% if (routes != null) {
     for (Document r : routes) {
       int fare = r.getInteger("baseFare", 0);
%>
  <div class="sw-route-row">
    <div>
      <strong><%= r.getString("fromCity") %> → <%= r.getString("toCity") %></strong>
      <div class="sw-meta"><%= r.getString("airline") %> · <%= r.getString("duration") %></div>
    </div>
    <div style="text-align:right;">
      <div style="font-weight:800;color:var(--ok);">from ₹ <%= fare %></div>
      <a class="sw-btn sw-btn-ghost" href="booking?action=flight" style="margin-top:8px;padding:8px 10px;">Book flight</a>
    </div>
  </div>
<%   }
   } %>

  <h2 class="sw-section-title">All packages</h2>
  <div class="sw-grid">
<% if (packages != null) {
     for (Document p : packages) {
       String id = p.getObjectId("_id").toHexString();
%>
    <article class="sw-card">
      <img class="sw-card-img" src="<%= p.getString("imageUrl") %>" alt="<%= p.getString("name") %>">
      <div class="sw-card-body">
        <h3><%= p.getString("name") %></h3>
        <p><%= p.getString("highlights") %></p>
        <div class="sw-price">₹ <%= p.getInteger("price", 0) %></div>
        <form method="post" action="booking" style="margin-top:10px;">
          <input type="hidden" name="action" value="bookPackage">
          <input type="hidden" name="packageId" value="<%= id %>">
          <button type="submit" class="sw-btn sw-btn-secondary" style="width:100%;">Reserve</button>
        </form>
      </div>
    </article>
<%   }
   } %>
  </div>

  <h2 class="sw-section-title">Curated destinations</h2>
  <div class="sw-grid">
<% if (places != null) {
     for (Document p : places) {
       java.util.List<?> tags = p.getList("tags", String.class);
%>
    <article class="sw-card">
      <img class="sw-card-img" src="<%= p.getString("imageUrl") %>" alt="<%= p.getString("name") %>">
      <div class="sw-card-body">
        <h3><%= p.getString("name") %></h3>
        <p><%= p.getString("whyVisit") %></p>
<%     if (tags != null) {
         for (Object t : tags) { %>
        <span class="sw-tag"><%= t %></span>
<%       }
       } %>
        <div style="margin-top:10px;">
          <a class="sw-btn sw-btn-secondary" href="booking?action=stayNearby&placeId=<%= p.getObjectId("_id").toHexString() %>">Explore stays</a>
        </div>
      </div>
    </article>
<%   }
   } %>
  </div>
</div>
</main>
</body>
</html>
