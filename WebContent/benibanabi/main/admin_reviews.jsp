<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="bean.Reviews" %>
<%@ page import="bean.Spot" %>
<!DOCTYPE html>
<html lang="ja">
<head>
<meta charset="UTF-8">
<title>管理者用口コミ一覧</title>
<style>
  body { font-family: "Noto Sans JP", sans-serif; background-color: #f9f9f9; color: #333; margin: 0; padding: 20px; }
  h1 { margin-bottom: 20px; }
  table { width: 100%; border-collapse: collapse; margin-top: 20px; }
  th, td { border: 1px solid #ccc; padding: 8px; text-align: left; }
  th { background-color: #eee; }
  .delete-btn { padding: 4px 8px; background-color: #cc0000; color: #fff; border: none; border-radius: 4px; cursor: pointer; }
  .delete-btn:hover { background-color: #990000; }
  a.back { display: inline-block; margin-bottom: 20px; color: #0066cc; text-decoration: none; }
  a.back:hover { text-decoration: underline; }
</style>
</head>
<body>

<%
    String error = (String) request.getAttribute("error");
    Spot spot = (Spot) request.getAttribute("spot");
    List<Reviews> reviews = (List<Reviews>) request.getAttribute("reviews");

    if (error != null) {
%>
    <p><%= error %></p>
<%
        return;
    }

    if (spot == null) {
%>
    <p>スポットが見つかりません。</p>
<%
        return;
    }
%>

<h1>「<%= spot.getSpotName() %>」の口コミ一覧</h1>
<a href="<%= request.getContextPath() %>/benibanabi/main/admin_spot_list.jsp" class="back">← スポット一覧に戻る</a>



<%
    if (reviews == null || reviews.isEmpty()) {
%>
<p>このスポットにはまだ口コミがありません。</p>
<%
    } else {
%>

<table>
    <thead>
        <tr>
            <th>口コミID</th>
            <th>内容</th>
            <th>投稿日</th>
            <th>操作</th>
        </tr>
    </thead>
    <tbody>
<%
        for (Reviews rv : reviews) {
%>
        <tr>
            <td><%= rv.getReviewId() %></td>
            <td><%= rv.getReviewText() %></td>
            <td><%= rv.getReviewDate() %></td>
            <td>
                <form method="post" action="<%= request.getContextPath() %>/benibanabi/main/AdminDeleteReview.action"
                      onsubmit="return confirm('本当に削除しますか？');">
                    <input type="hidden" name="reviewId" value="<%= rv.getReviewId() %>">
                    <input type="hidden" name="spotId" value="<%= spot.getSpotId() %>">
                    <button type="submit" class="delete-btn">削除</button>
                </form>
            </td>
        </tr>
<%
        }
%>
    </tbody>
</table>

<%
    }
%>

</body>
</html>