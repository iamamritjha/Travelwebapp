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
List<Document> bookings = (List<Document>) request.getAttribute("bookings");
%>
<%!
private static String nz(String s) { return s == null ? "" : s; }
%>
<!DOCTYPE html>
<html lang="en">
<head>
<title>My bookings · SkyWay</title>
<%@ include file="partials/head-common.jspf" %>
</head>
<body class="sw-body sw-layout">
<%@ include file="partials/sidebar.jspf" %>
<main class="sw-main">
<div class="sw-wrap">
  <div class="sw-hero">
    <h1>Your reservations</h1>
    <p class="sw-lead">Every row is filtered by <code style="color:#e2e8f0;">userId = <%= session.getAttribute("user") %></code> in MongoDB — other travelers never see this list.</p>
  </div>
<% if (bookings == null || bookings.isEmpty()) { %>
  <p style="text-align:center;color:var(--muted);">No bookings yet. Start from Explore or book a flight.</p>
  <p style="text-align:center;"><a class="sw-btn" href="booking?action=explore">Open explore hub</a></p>
<% } else { %>
  <div class="sw-table-wrap">
    <table class="sw-table">
      <thead>
        <tr>
          <th>Reference</th>
          <th>Type</th>
          <th>Summary</th>
          <th>Amount (₹)</th>
          <th>When</th>
        </tr>
      </thead>
      <tbody>
<%   for (Document b : bookings) {
       ObjectId oid = b.getObjectId("_id");
       String ref = oid != null ? oid.toHexString() : "";
       String type = b.getString("type");
       int amt = b.getInteger("totalAmount", 0);
       java.util.Date created = b.getDate("createdAt");
       Document d = b.get("details", Document.class);
       String summary = "—";
       if (d != null && type != null) {
         if ("flight".equals(type)) {
           summary = nz(d.getString("from")) + " → " + nz(d.getString("to"));
           Object pax = d.get("passengers");
           if (pax != null) {
             summary += " · " + pax + " pax";
           }
         } else if ("hotel".equals(type)) {
           summary = nz(d.getString("hotelName")) + ", " + nz(d.getString("city"));
         } else if ("package".equals(type)) {
           summary = nz(d.getString("packageName")) + " · " + nz(d.getString("destination"));
         }
       }
       String badgeClass = "sw-badge-flight";
       if ("hotel".equals(type)) badgeClass = "sw-badge-hotel";
       if ("package".equals(type)) badgeClass = "sw-badge-package";
%>
        <tr>
          <td><code style="font-size:0.8rem;"><%= ref.length() > 12 ? ref.substring(0, 12) + "…" : ref %></code></td>
          <td><span class="sw-badge <%= badgeClass %>"><%= type != null ? type : "—" %></span></td>
          <td><%= summary %></td>
          <td><%= amt %></td>
          <td><%= created != null ? created.toString().substring(0, 16) : "—" %></td>
        </tr>
<%   } %>
      </tbody>
    </table>
  </div>
<% } %>
</div>
</main>
</body>
</html>
