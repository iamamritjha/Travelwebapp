<%@ page contentType="text/html;charset=UTF-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
<title>Sign in · SkyWay</title>
<%@ include file="partials/head-common.jspf" %>
</head>
<body class="sw-body sw-auth-page">
<div class="sw-auth-visual" role="img" aria-label=""></div>
<div class="sw-auth-panel">
  <div class="sw-auth-card">
    <h2>Welcome back</h2>
    <form action="auth" method="post">
      <input type="hidden" name="action" value="login">
      <input type="text" name="userid" placeholder="User ID" required autocomplete="username">
      <input type="password" name="password" placeholder="Password" required autocomplete="current-password">
      <button type="submit" class="sw-btn">Sign in</button>
    </form>
    <div class="link">
      <a href="auth?action=signup">Create an account</a>
    </div>
  </div>
</div>
</body>
</html>
