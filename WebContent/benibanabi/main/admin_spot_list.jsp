<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="bean.Spot" %>
<%@ page import="dao.SpotDAO" %>
<!DOCTYPE html>
<html lang="ja">
<head>
<meta charset="UTF-8">
<title>観光スポット一覧</title>
<style>
  body { font-family: "Noto Sans JP", sans-serif; background-color: #f9f9f9; color: #333; margin: 0; padding: 20px; }
  .spot-container { display: flex; flex-wrap: wrap; gap: 20px; }
  .spot-card { background: #fff; border-radius: 8px; box-shadow: 0 2px 6px rgba(0,0,0,0.1); width: 250px; overflow: hidden; text-align: center; padding-bottom: 10px; }
  .spot-card img { width: 100%; height: 150px; object-fit: cover; }
  .spot-card h3 { margin: 10px 0 5px; font-size: 1.2em; }
  .spot-card p { margin: 5px 0; font-size: 0.9em; color: #666; }
  .spot-card a { display: inline-block; margin: 10px 0; padding: 6px 12px; background-color: #0066cc; color: #fff; text-decoration: none; border-radius: 4px; }
  .spot-card a:hover { background-color: #004999; }
</style>
</head>
<body>
<h1>観光スポット一覧</h1>

<%
    try {
        SpotDAO dao = new SpotDAO();
        List<Spot> spotList = dao.searchSpots(null, null, null); // 条件なしで全件取得

        if (spotList.isEmpty()) {
%>
<p>現在、登録されているスポットはありません。</p>
<%
        } else {
%>
<div class="spot-container">
<%
            for (Spot sp : spotList) {
%>
    <div class="spot-card">
        <%
            if (sp.getSpotPhoto() != null && !sp.getSpotPhoto().isEmpty()) {
        %>
        <img src="<%= sp.getSpotPhoto() %>" alt="<%= sp.getSpotName() %>">
        <%
            } else {
        %>
        <img src="images/noimage.png" alt="No Image">
        <%
            }
        %>
        <h3><%= sp.getSpotName() %></h3>
        <p>エリア: <%= sp.getArea() %></p>
        <!-- 口コミを見るボタン -->
        <a href="admin_reviews.jsp?spotId=<%= sp.getSpotId() %>">口コミを見る</a>
    </div>
<%
            }
%>
</div>
<%
        }
    } catch (Exception e) {
%>
<p>スポットの取得中にエラーが発生しました: <%= e.getMessage() %></p>
<%
        e.printStackTrace();
    }
%>

</body>
</html>
