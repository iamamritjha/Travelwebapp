<%@ page contentType="text/html;charset=UTF-8" %>
<%
if (session.getAttribute("user") == null) {
    response.sendRedirect("auth?action=signin");
    return;
}
%>
<!DOCTYPE html>
<html lang="en">
<head>
<title>Flight search · SkyWay</title>
<%@ include file="partials/head-common.jspf" %>
</head>
<body class="sw-body sw-layout">
<%@ include file="partials/sidebar.jspf" %>
<main class="sw-main">
<div class="sw-booking-shell">
  <h2>Search flights</h2>
  <p class="sw-lead">We match known routes for live-ish fares. Unknown pairs still get a fair charter estimate.</p>

  <form action="booking" method="post" style="margin-top:16px;">
    <input type="hidden" name="action" value="flightBooking">
    <div class="sw-form-grid">
      <label class="sw-field">
        From city
        <input type="text" name="from" placeholder="e.g. Mumbai" required>
      </label>
      <label class="sw-field">
        To city
        <input type="text" name="to" placeholder="e.g. Dubai" required>
      </label>
      <label class="sw-field">
        Departure
        <input type="date" name="departure">
      </label>
      <label class="sw-field">
        Return
        <input type="date" name="returnDate">
      </label>
      <label class="sw-field">
        Passengers
        <input type="number" name="passengers" value="1" min="1" max="9">
      </label>
      <label class="sw-field">
        Cabin
        <select name="travelClass">
          <option>Economy</option>
          <option>Business</option>
          <option>First Class</option>
        </select>
      </label>
    </div>
    <div class="sw-actions" style="margin-top:16px;">
      <button type="submit" class="sw-btn">Continue</button>
      <a class="sw-btn sw-btn-secondary" href="booking?action=dashboard">Back</a>
    </div>
  </form>
</div>
</main>
</body>
</html>
