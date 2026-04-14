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
%>
<!DOCTYPE html>
<html lang="en">
<head>
<title>Packages · SkyWay</title>
<%@ include file="partials/head-common.jspf" %>
</head>
<body class="sw-body sw-layout">
<%@ include file="partials/sidebar.jspf" %>
<main class="sw-main">
<div class="sw-wrap">
  <div class="sw-hero">
    <h1>Curated multi-day journeys</h1>
    <p class="sw-lead">Transparent pricing, iconic highlights — confirm in one click and track the trip on your private dashboard.</p>
  </div>

  <div class="sw-grid">
<% if (packages != null) {
     for (Document p : packages) {
       String pid = p.getObjectId("_id").toHexString();
%>
    <article class="sw-card">
      <img class="sw-card-img" src="<%= p.getString("imageUrl") %>" alt="<%= p.getString("name") %>">
      <div class="sw-card-body">
        <h3><%= p.getString("name") %></h3>
        <p><%= p.getString("destination") %> · <%= p.getInteger("days", 0) %> days</p>
        <p class="sw-meta"><%= p.getString("highlights") %></p>
        <div class="sw-price">₹ <%= p.getInteger("price", 0) %></div>
        <form method="post" action="booking" style="margin-top:12px;">
          <input type="hidden" name="action" value="bookPackage">
          <input type="hidden" name="packageId" value="<%= pid %>">
          <button type="submit" class="sw-btn" style="width:100%;">Book package</button>
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
