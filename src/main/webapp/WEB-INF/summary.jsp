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
<title>Review flight · SkyWay</title>
<%@ include file="partials/head-common.jspf" %>
</head>
<body class="sw-body sw-layout">
<%@ include file="partials/sidebar.jspf" %>
<main class="sw-main">
<div class="sw-wrap sw-wrap--narrow">
  <div class="sw-summary">
    <h2>Review your flight</h2>
    <p class="sw-lead">Check details and confirm — only your account will see this booking on the dashboard.</p>

    <div class="sw-details">
      <div class="sw-item">
        <div class="label">From</div>
        <div class="value">${from}</div>
      </div>
      <div class="sw-item">
        <div class="label">To</div>
        <div class="value">${to}</div>
      </div>
      <div class="sw-item">
        <div class="label">Departure</div>
        <div class="value">${empty departure ? '—' : departure}</div>
      </div>
      <div class="sw-item">
        <div class="label">Return</div>
        <div class="value">${returnDate}</div>
      </div>
      <div class="sw-item">
        <div class="label">Passengers</div>
        <div class="value">${passengers}</div>
      </div>
      <div class="sw-item">
        <div class="label">Class</div>
        <div class="value">${travelClass}</div>
      </div>
      <div class="sw-item">
        <div class="label">Airline</div>
        <div class="value">${airline}</div>
      </div>
      <div class="sw-item">
        <div class="label">Est. duration</div>
        <div class="value">${duration}</div>
      </div>
      <div class="sw-item sw-highlight">
        <div class="label">Estimated fare</div>
        <div class="value">₹ ${estFare}</div>
      </div>
    </div>

    <form class="sw-form-actions" action="booking" method="post">
      <input type="hidden" name="action" value="confirmFlightBooking">
      <input type="hidden" name="from" value="${from}">
      <input type="hidden" name="to" value="${to}">
      <input type="hidden" name="departure" value="${departure}">
      <input type="hidden" name="returnDate" value="${returnDate}">
      <input type="hidden" name="passengers" value="${passengers}">
      <input type="hidden" name="travelClass" value="${travelClass}">
      <input type="hidden" name="airline" value="${airline}">
      <input type="hidden" name="totalAmount" value="${totalAmount}">
      <button type="submit" class="sw-btn">Confirm &amp; pay later</button>
      <a class="sw-btn sw-btn-secondary" href="booking?action=flight">Change search</a>
    </form>
  </div>
</div>
</main>
</body>
</html>
