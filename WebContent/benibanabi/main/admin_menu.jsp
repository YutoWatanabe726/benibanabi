<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="ja">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0" />
  <title>管理者メニュー</title>
  <style>
    body {
      margin: 0;
      font-family: "Segoe UI", sans-serif;
      background-color: #f3f4f6;
      height: 100vh;
      display: flex;
      justify-content: center;
      align-items: center;
    }

    .container {
      background-color: #ffffff;
      border-radius: 16px;
      box-shadow: 0 8px 20px rgba(0, 0, 0, 0.1);
      width: 600px;
      padding: 40px;
      text-align: center;
    }

    h1 {
      color: #1f2937;
      margin-bottom: 30px;
      font-size: 1.8rem;
      border-bottom: 2px solid #040913;
      display: inline-block;
      padding-bottom: 8px;
    }

    .menu-item {
      background-color: #030710;
      color: white;
      padding: 15px 20px;
      margin: 12px 0;
      border-radius: 10px;
      font-size: 1.1rem;
      cursor: pointer;
      transition: background-color 0.3s, transform 0.2s;
      text-decoration: none;
      display: block;
    }

    .menu-item:hover {
      background-color: #040814;
      transform: scale(1.03);
    }

    .menu-item.active {
      background-color: #05060a;
    }
  </style>
</head>
<body>
  <div class="container">
    <h1>管理者機能</h1>


    <a href="admin_spot.jsp" class="menu-item">観光スポットの登録・更新・削除</a>
    <a href="admin_comment.jsp" class="menu-item">コメント管理</a>
    <a href="admin_acount.jsp" class="menu-item">アカウント削除</a>
    <a href="AdminPasswordUpdate.action" class="menu-item">パスワード編集</a>

  </div>

  <script>
    const items = document.querySelectorAll(".menu-item");
    items.forEach(item => {
      item.addEventListener("click", () => {
        items.forEach(i => i.classList.remove("active"));
        item.classList.add("active");
      });
    });
  </script>
</body>
</html>
