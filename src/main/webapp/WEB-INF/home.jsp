<%@ page contentType="text/html;charset=UTF-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
<title>SkyWay Travels — Plan smarter trips</title>
<%@ include file="partials/head-common.jspf" %>
</head>
<body class="sw-body sw-landing">
<nav class="sw-nav">
  <div class="sw-brand">
    <span class="sw-logo" aria-hidden="true"></span>
    SkyWay
  </div>
  <div class="sw-nav-links">
    <a href="auth?action=signin">Sign in</a>
    <a class="sw-btn sw-btn-secondary" href="auth?action=signup" style="padding:10px 20px;">Create account</a>
  </div>
</nav>

<section class="sw-hero-full">
  <div>
    <h1>Travel, tailored and trackable</h1>
    <p>Flights, hotels, and packages in one place — powered by MongoDB. Your bookings stay tied to your account only.</p>
    <div class="sw-cta">
      <a class="sw-btn" href="auth?action=signup">Get started</a>
      <a class="sw-btn sw-btn-secondary" href="auth?action=signin">Sign in</a>
    </div>
  </div>
</section>

<section class="sw-strip">
  <div class="sw-wrap">
    <h2 class="sw-section-title" style="margin-top:0;">Why SkyWay</h2>
    <div class="sw-feature-grid">
      <article class="sw-feature-card">
        <div class="sw-icon-lg" aria-hidden="true">
          <svg viewBox="0 0 24 24"><circle cx="12" cy="12" r="3"/><path d="M12 1v4M12 19v4M4.22 4.22l2.83 2.83M16.95 16.95l2.83 2.83M1 12h4M19 12h4M4.22 19.78l2.83-2.83M16.95 7.05l2.83-2.83"/></svg>
        </div>
        <h3>Smart recommendations</h3>
        <p>We rank destinations and packages using signals from your own history — not someone else’s.</p>
      </article>
      <article class="sw-feature-card">
        <div class="sw-icon-lg" aria-hidden="true">
          <svg viewBox="0 0 24 24"><path d="M3 9l9-7 9 7v11a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2z"/><path d="M9 22V12h6v10"/></svg>
        </div>
        <h3>Explore &amp; nearby stays</h3>
        <p>Featured routes, editorial picks, and hotels mapped near spotlight destinations.</p>
      </article>
      <article class="sw-feature-card">
        <div class="sw-icon-lg" aria-hidden="true">
          <svg viewBox="0 0 24 24"><rect x="5" y="11" width="14" height="10" rx="2"/><path d="M12 17v-1M9 11V7a3 3 0 0 1 6 0v4"/></svg>
        </div>
        <h3>Private dashboard</h3>
        <p>Every reservation is stored with your user id — your list never mixes with other travelers.</p>
      </article>
    </div>
  </div>
</section>

<footer class="sw-footer">
  SkyWay Travels · Demo stack: JSP · Servlets · MongoDB ·
  <a href="auth?action=signin">Sign in</a>
</footer>
</body>
</html>
