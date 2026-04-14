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
%>
<!DOCTYPE html>
<html>
<head>
<title>Recommended places · SkyWay</title>
<%@ include file="partials/head-common.jspf" %>
</head>
<body class="sw-body sw-layout">
<%@ include file="partials/sidebar.jspf" %>
<main class="sw-main">
<div class="sw-wrap">
  <div class="sw-hero">
    <h1>Curated for you</h1>
    <p>Hand-picked destinations from our travel desk — seasonality, vibe, and value in one place.</p>
  </div>
  <h2 class="sw-section-title">Recommended places</h2>
  <div class="sw-grid">
<% if (places != null) {
     for (Document p : places) {
       String name = p.getString("name");
       String country = p.getString("country");
       String season = p.getString("bestSeason");
       String why = p.getString("whyVisit");
       String img = p.getString("imageUrl");
       java.util.List<?> tags = p.getList("tags", String.class);
%>
    <article class="sw-card">
      <img class="sw-card-img" src="<%= img %>" alt="<%= name %>">
      <div class="sw-card-body">
        <h3><%= name %></h3>
        <p><%= country %> · Best <%= season %></p>
        <p><%= why %></p>
<%     if (tags != null) {
         for (Object t : tags) { %>
        <span class="sw-tag"><%= t %></span>
<%       }
       } %>
      </div>
    </article>
<%   }
   } %>
  </div>
</div>
</main>
</body>
</html>
