<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="bean.Reviews" %>
<%@ page import="bean.Spot" %>
<!DOCTYPE html>
<html lang="ja">
<head>
<meta charset="UTF-8">
<title>管理者用口コミ一覧</title>

<link rel="stylesheet" href="${pageContext.request.contextPath}/css/admin_reviews.css">

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

<a class="back" href="${pageContext.request.contextPath}/benibanabi/main/AdminReviewsSpotList.action">
    ← スポット一覧に戻る
</a>


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
