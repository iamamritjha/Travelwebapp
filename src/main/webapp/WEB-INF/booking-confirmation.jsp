<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.util.List" %>
<%
if (session.getAttribute("user") == null) {
    response.sendRedirect("auth?action=signin");
    return;
}
@SuppressWarnings("unchecked")
List<String[]> extraLines = (List<String[]>) request.getAttribute("extraLines");
%>
<!DOCTYPE html>
<html lang="en">
<head>
<title>Booking confirmed · SkyWay</title>
<%@ include file="partials/head-common.jspf" %>
</head>
<body class="sw-body sw-layout">
<%@ include file="partials/sidebar.jspf" %>
<main class="sw-main">
<div class="sw-wrap">
  <div class="sw-summary">
    <h2>${title}</h2>
    <p style="text-align:center;color:var(--muted);margin:0 0 1rem;">${subtitle}</p>
    <div class="sw-item sw-highlight" style="margin-bottom:1rem;">
      Reference · ${bookingRef}
    </div>
    <div class="sw-details">
      <div class="sw-item">
        <div class="label">Total</div>
        <div class="value">₹ ${totalFare}</div>
      </div>
      <div class="sw-item">
        <div class="label">Status</div>
        <div class="value">Confirmed</div>
      </div>
<% if (extraLines != null) {
     for (String[] row : extraLines) { %>
      <div class="sw-item">
        <div class="label"><%= row[0] %></div>
        <div class="value"><%= row[1] %></div>
      </div>
<%   }
   } %>
    </div>
    <div class="sw-actions">
      <a class="sw-btn sw-btn-secondary" href="booking?action=mybookings">View all bookings</a>
      <a class="sw-btn" href="booking?action=dashboard">Back to hub</a>
    </div>
  </div>
</div>
</main>
</body>
</html>
