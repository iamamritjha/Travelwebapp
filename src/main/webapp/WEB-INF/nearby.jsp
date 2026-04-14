<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="org.bson.Document" %>
<%
if (session.getAttribute("user") == null) {
    response.sendRedirect("auth?action=signin");
    return;
}
@SuppressWarnings("unchecked")
List<Document> places = (List<Document>) request.getAttribute("places");
Document selected = (Document) request.getAttribute("selectedPlace");
@SuppressWarnings("unchecked")
List<Document> nearbyHotels = (List<Document>) request.getAttribute("nearbyHotels");
%>
<!DOCTYPE html>
<html lang="en">
<head>
<title>Stay nearby · SkyWay</title>
<%@ include file="partials/head-common.jspf" %>
</head>
<body class="sw-body sw-layout">
<%@ include file="partials/sidebar.jspf" %>
<main class="sw-main">
<div class="sw-wrap">
  <div class="sw-hero">
    <h1>Stays near your vibe</h1>
    <p class="sw-lead">Each spotlight destination maps to a partner city where we hold hotel inventory — pick a place, then book a stay that lands on <em>your</em> dashboard only.</p>
  </div>

  <h2 class="sw-section-title">Choose a spotlight</h2>
  <div class="sw-grid sw-grid--tight">
<% if (places != null) {
     for (Document p : places) {
       String pid = p.getObjectId("_id").toHexString();
       boolean active = selected != null && pid.equals(selected.getObjectId("_id").toHexString());
%>
    <a class="sw-tile" href="booking?action=stayNearby&placeId=<%= pid %>" style="<%= active ? "border-color: rgba(56,189,248,0.55);" : "" %>">
      <div class="emoji">📍</div>
      <h3><%= p.getString("name") %></h3>
      <p><%= p.getString("country") %> · Hotels via <%= p.getString("nearCity") != null ? p.getString("nearCity") : "partner city" %></p>
    </a>
<%   }
   } %>
  </div>

<% if (selected != null) { %>
  <h2 class="sw-section-title">Hotels near <%= selected.getString("name") %></h2>
  <p class="sw-lead" style="margin-top:-6px;">Showing inventory in <strong style="color:#e2e8f0;"><%= selected.getString("nearCity") != null ? selected.getString("nearCity") : "nearby partner hubs" %></strong>.</p>

<%   if (nearbyHotels == null || nearbyHotels.isEmpty()) { %>
  <p class="sw-lead">No mapped hotels for this pairing yet — try another spotlight.</p>
<%   } else { %>
  <div class="sw-grid">
<%     for (Document h : nearbyHotels) {
         String hid = h.getObjectId("_id").toHexString();
%>
    <article class="sw-card">
      <img class="sw-card-img" src="<%= h.getString("imageUrl") %>" alt="<%= h.getString("name") %>">
      <div class="sw-card-body">
        <h3><%= h.getString("name") %></h3>
        <p><%= h.getString("city") %>, <%= h.getString("country") %></p>
        <p class="sw-meta"><%= h.getString("description") %></p>
        <div class="sw-price">₹ <%= h.getInteger("pricePerNight", 0) %> / night · ★ <%= h.get("rating") %></div>
        <form method="post" action="booking" style="margin-top:12px;">
          <input type="hidden" name="action" value="bookHotel">
          <input type="hidden" name="hotelId" value="<%= hid %>">
          <label class="sw-field" style="margin-bottom:10px;">
            <span style="display:block;color:var(--muted);font-size:0.8rem;margin-bottom:6px;">Nights</span>
            <input type="number" name="nights" value="2" min="1" max="30">
          </label>
          <button type="submit" class="sw-btn" style="width:100%;">Book stay</button>
        </form>
      </div>
    </article>
<%     } %>
  </div>
<%   }
   } %>
</div>
</main>
</body>
</html>
