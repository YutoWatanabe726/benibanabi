<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html lang="ja">
<head>
<meta charset="UTF-8">
<title>管理者ログイン</title>
<meta name="viewport" content="width=device-width, initial-scale=1.0">

<style>
  body {
    font-family: "Noto Sans JP", sans-serif;
    background: #f3f4f6;
    margin: 0;
    padding: 0;
  }
  .container {
    width: 100%;
    max-width: 420px;
    margin: 80px auto;
    padding: 24px;
    background: #fff;
    border-radius: 10px;
    box-shadow: 0 4px 12px rgba(0,0,0,0.1);
  }
  h2 {
    text-align: center;
    color: #333;
    margin-bottom: 20px;
  }
  label {
    display: block;
    margin-top: 15px;
    font-size: 14px;
    color: #444;
  }
  input[type="text"],
  input[type="password"] {
    width: 100%;
    padding: 10px;
    margin-top: 5px;
    border-radius: 5px;
    border: 1px solid #ccc;
  }
  .btn-login {
    width: 100%;
    margin-top: 20px;
    background: #2563eb;
    color: white;
    padding: 12px;
    border-radius: 6px;
    border: none;
    cursor: pointer;
    font-size: 16px;
  }
  .btn-login:hover {
    background: #1e4db7;
  }
  .error {
    color: #e11d48;
    background: #ffe4e6;
    padding: 8px;
    border-radius: 5px;
    margin-top: 10px;
    text-align: center;
  }
</style>
</head>
<body>

<div class="container">
  <h2>管理者ログイン</h2>

  <!-- ログイン失敗時のエラー表示 -->
  <c:if test="${not empty error}">
      <div class="error">${error}</div>
  </c:if>

  <form action="AdminLogin.action" method="post">
    <label for="adminId">管理者ID</label>
    <input type="text" id="adminId" name="adminId" required>

    <label for="password">パスワード</label>
    <input type="password" id="password" name="password" required>

    <button type="submit" class="btn-login">ログイン</button>
  </form>
</div>

</body>
</html>
