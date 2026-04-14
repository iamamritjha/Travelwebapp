<%@ page contentType="text/html;charset=UTF-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
<title>Error · SkyWay</title>
<%@ include file="partials/head-common.jspf" %>
</head>
<body class="sw-body">
<div class="sw-wrap" style="min-height:70vh;display:grid;place-items:center;text-align:center;">
  <div class="sw-summary" style="max-width:480px;">
    <h2 style="margin:0 0 12px;color:var(--danger);">Something went wrong</h2>
    <p class="sw-lead" style="margin-bottom:1.5rem;">${errorMessage}</p>
    <a class="sw-btn sw-btn-secondary" href="auth?action=home">Back to home</a>
  </div>
</div>
</body>
</html>
