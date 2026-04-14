<%@ page contentType="text/html;charset=UTF-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
<title>Create account · SkyWay</title>
<%@ include file="partials/head-common.jspf" %>
</head>
<body class="sw-body sw-auth-page">
<div class="sw-auth-visual" style="background-image:linear-gradient(145deg, rgba(5,8,22,0.88), rgba(5,8,22,0.45)), url('https://images.unsplash.com/photo-1491553895911-0055eca6402d?w=1200&q=80');" role="img" aria-label=""></div>
<div class="sw-auth-panel">
  <div class="sw-auth-card">
    <h2>Create your account</h2>
    <form action="auth" method="post">
      <input type="hidden" name="action" value="register">
      <input type="text" name="fullname" placeholder="Full name" required autocomplete="name">
      <input type="email" name="email" placeholder="Email" required autocomplete="email">
      <input type="text" name="phone" placeholder="Phone" required autocomplete="tel">
      <input type="text" name="userid" placeholder="Choose a user ID" required autocomplete="username">
      <input type="password" name="password" placeholder="Password" required autocomplete="new-password">
      <button type="submit" class="sw-btn">Register</button>
    </form>
    <div class="link">
      Already registered? <a href="auth?action=signin">Sign in</a>
    </div>
  </div>
</div>
</body>
</html>
