<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="org.bson.Document" %>
<%
if (session.getAttribute("user") == null) {
    response.sendRedirect("auth?action=signin");
    return;
}
@SuppressWarnings("unchecked")
List<Document> hotels = (List<Document>) request.getAttribute("hotels");
%>
<!DOCTYPE html>
<html lang="en">
<head>
<title>Hotels · SkyWay</title>
<%@ include file="partials/head-common.jspf" %>
</head>
<body class="sw-body sw-layout">
<%@ include file="partials/sidebar.jspf" %>
<main class="sw-main">
<div class="sw-wrap">
  <div class="sw-hero">
    <h1>Stays that feel intentional</h1>
    <p class="sw-lead">Every booking is stored with your user id — you will only see these reservations under <strong>My bookings</strong>.</p>
  </div>

  <div class="sw-grid">
<% if (hotels != null) {
     for (Document h : hotels) {
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
            <input type="number" name="nights" value="1" min="1" max="30">
          </label>
          <button type="submit" class="sw-btn" style="width:100%;">Book now</button>
        </form>
      </div>
    </article>
<%   }
   } %>
  </div>
</div>
</main>
</body>
</html>
