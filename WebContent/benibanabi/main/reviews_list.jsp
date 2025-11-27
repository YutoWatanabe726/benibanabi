<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page import="java.util.*" %>
<%@ page import="bean.Spot" %>
<%@ page import="bean.Reviews" %>

<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<c:import url="/common/base.jsp">
<c:param name="title">口コミ一覧</c:param>
<c:param name="content">

<%
    Spot spot = (Spot) request.getAttribute("spot");
    List<Reviews> reviewList = (List<Reviews>) request.getAttribute("reviewList");

    if (spot == null) spot = new Spot();
    if (reviewList == null) reviewList = new ArrayList<>();

    // ページネーション用
    Integer currentPage = (Integer) request.getAttribute("page");
    if (currentPage == null) currentPage = 1;

    int pageSize = 10;
    int totalReviews = reviewList.size();
    int totalPages = (int) Math.ceil((double) totalReviews / pageSize);

    int startIndex = (currentPage - 1) * pageSize;
    int endIndex = Math.min(startIndex + pageSize, totalReviews);

    List<Reviews> displayReviews = reviewList.subList(startIndex, endIndex);
%>

<!DOCTYPE html>
<html lang="ja">
<head>
<meta charset="UTF-8">
<title><%= spot.getSpotName() %> の口コミ一覧</title>

<!-- 共通 CSS -->
<link rel="stylesheet" href="<%= request.getContextPath() %>/css/style.css">
<!-- 口コミ一覧専用 CSS -->
<link rel="stylesheet" href="<%= request.getContextPath() %>/css/spot_reviews.css">

<script>
function goPage(page) {
    const form = document.getElementById('pageForm');
    form.page.value = page;
    form.submit();
}
</script>
</head>

<body>

<div class="container">

    <!-- 上部戻るボタン -->
    <a href="SpotDetail.action?spot_id=<%= spot.getSpotId() %>" class="back-btn">スポット詳細へ戻る</a>

    <!-- タイトル -->
    <h1><%= spot.getSpotName() %> の口コミ一覧</h1>

    <!-- スポット情報（写真左・説明文右） -->
    <div class="spot-info">
        <img src="<%= request.getContextPath() + spot.getSpotPhoto() %>" class="spot-photo">
        <p><%= spot.getDescription() %></p>
    </div>

    <!-- 口コミ表示 -->
    <% if (displayReviews.isEmpty()) { %>
        <p>口コミはまだありません。</p>
    <% } else { %>
        <% for (Reviews r : displayReviews) { %>
            <div class="review-box">
                <div><strong>投稿者：</strong>匿名さん</div>
                <div><%= r.getReviewText() %></div>
                <div>投稿日：<%= r.getReviewDate() %></div>
            </div>
        <% } %>
    <% } %>

    <!-- ページネーション -->
    <div class="pagination">
        <form id="pageForm" action="ReviewsList.action" method="get" style="display:none;">
            <input type="hidden" name="spot_id" value="<%= spot.getSpotId() %>">
            <input type="hidden" name="page" value="<%= currentPage %>">
        </form>

        <% for(int i = 1; i <= totalPages; i++) { %>
            <button type="button" class="<%= (i == currentPage) ? "active" : "" %>" onclick="goPage(<%=i%>)">
                <%= i %>
            </button>
        <% } %>
    </div>

    <!-- 下部戻るボタン -->
    <a href="SpotDetail.action?spot_id=<%= spot.getSpotId() %>" class="back-btn">スポット詳細へ戻る</a>

</div>

</body>
</html>
</c:param>
</c:import>
