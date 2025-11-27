<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page import="java.util.*" %>
<%@ page import="bean.Spot" %>
<%@ page import="bean.Reviews" %>

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

<style>
body {
    font-family: "メイリオ", sans-serif;
    margin: 0;
    padding: 0;
    background: #fafafa;
}

.container {
    width: 90%;
    margin: 20px auto;
}

h1 {
    font-size: 26px;
    border-left: 8px solid #4dabf7;
    padding-left: 10px;
}

.spot-info {
    display: flex;
    gap: 20px;
    margin-bottom: 25px;
}

.spot-photo {
    width: 220px;
    height: auto;
    border-radius: 10px;
}

.review-box {
    background: #fff;
    padding: 15px;
    border-radius: 8px;
    border-left: 5px solid #ffb74d;
    margin-bottom: 15px;
}

.back-btn {
    display: inline-block;
    margin-top: 25px;
    background: #4dabf7;
    color: white;
    padding: 10px 18px;
    text-decoration: none;
    border-radius: 6px;
}

.back-btn:hover {
    background: #339af0;
}

/* ページネーション */
.pagination {
    text-align: center;
    margin: 20px 0;
}
.pagination button {
    padding: 6px 12px;
    margin: 2px;
    border: none;
    border-radius: 4px;
    cursor: pointer;
}
.pagination button.active {
    background: #4dabf7;
    color: white;
}
.pagination button:hover:not(.active) {
    background: #8ecae6;
}
</style>
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

    <h1><%= spot.getSpotName() %> の口コミ一覧</h1>

    <div class="spot-info">
        <img src="<%= request.getContextPath() + spot.getSpotPhoto() %>" class="spot-photo">
        <div>
            <p style="font-size: 16px; line-height: 1.6;">
                <%= spot.getDescription() %>
            </p>
        </div>
    </div>

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
