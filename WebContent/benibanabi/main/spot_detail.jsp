<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page import="java.util.*" %>
<%@ page import="bean.Spot" %>
<%@ page import="bean.Tag" %>
<%@ page import="bean.Reviews" %>

<%
    Spot spot = (Spot) request.getAttribute("spot");
    ArrayList<Tag> tagList = (ArrayList<Tag>) request.getAttribute("tagList");
    List<Reviews> reviewList = (List<Reviews>) request.getAttribute("reviewList");

    if (spot == null) spot = new Spot();
    if (tagList == null) tagList = new ArrayList<>();
    if (reviewList == null) reviewList = new ArrayList<>();
%>

<!DOCTYPE html>
<html lang="ja">
<head>
<meta charset="UTF-8">
<title><%= spot.getSpotName() %> の詳細</title>

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
    font-size: 28px;
    margin-bottom: 10px;
    border-left: 8px solid #ff6b6b;
    padding-left: 10px;
}

.section-title {
    font-size: 22px;
    margin-top: 30px;
    margin-bottom: 10px;
    border-left: 6px solid #4dabf7;
    padding-left: 8px;
}

.detail-box {
    background: white;
    padding: 20px;
    border-radius: 10px;
    box-shadow: 0 2px 4px rgba(0,0,0,0.2);
    margin-bottom: 20px;
}

img.spot-img {
    width: 100%;
    max-width: 500px;
    border-radius: 10px;
}

.tag {
    display: inline-block;
    background: #eee;
    padding: 5px 10px;
    margin: 3px;
    border-radius: 20px;
    font-size: 14px;
}

.review-box {
    background: white;
    padding: 15px;
    margin-bottom: 10px;
    border-radius: 8px;
    border-left: 5px solid #ffb74d;
}

.review-user {
    font-weight: bold;
}

.more-btn {
    display: inline-block;
    margin-top: 10px;
    background: #ff9800;
    color: white;
    padding: 10px 18px;
    text-decoration: none;
    border-radius: 6px;
}

.more-btn:hover {
    background: #fb8c00;
}

.back-btn {
    display: inline-block;
    margin-top: 20px;
    background: #4dabf7;
    color: white;
    padding: 10px 18px;
    text-decoration: none;
    border-radius: 6px;
}

.back-btn:hover {
    background: #339af0;
}
</style>
</head>

<body>

<div class="container">

    <h1><%= spot.getSpotName() %></h1>

    <div class="detail-box">

        <img src="<%= request.getContextPath() + spot.getSpotPhoto() %>"
             class="spot-img" alt="spot image">

        <p style="margin-top: 15px; font-size: 16px; line-height: 1.6;">
            <%= spot.getDescription() %>
        </p>

        <div class="tag-container">
            <strong>タグ：</strong>
            <% for (Tag t : tagList) { %>
                <span class="tag"><%= t.getTagName() %></span>
            <% } %>
        </div>
    </div>

    <h2 class="section-title">所在地</h2>

    <div class="detail-box">
        <p style="font-size: 16px;">
            <strong>住所：</strong> <%= spot.getAddress() %>
        </p>

        <div style="margin-top: 15px;">
            <iframe
                width="100%"
                height="350"
                style="border:0; border-radius: 10px;"
                loading="lazy"
                allowfullscreen
                src="https://maps.google.com/maps?q=<%= spot.getLatitude() %>,<%= spot.getLongitude() %>&z=16&output=embed">
            </iframe>
        </div>
    </div>

    <h2 class="section-title">口コミ</h2>

    <%
        int limit = 3;
        int totalReviews = reviewList.size();
    %>

    <% if (totalReviews == 0) { %>

        <p>口コミはまだありません。</p>

    <% } else { %>

        <% for (int i = 0; i < Math.min(limit, totalReviews); i++) {
            Reviews r = reviewList.get(i); %>

            <div class="review-box">
                <div class="review-user">投稿者：匿名さん</div>
                <div class="review-content"><%= r.getReviewText() %></div>
                <div>投稿日：<%= r.getReviewDate() %></div>
            </div>

        <% } %>

        <% if (totalReviews > limit) { %>
            <!-- もっと見るボタン -->
            <a class="more-btn" href="ReviewsList.action?spot_id=<%= spot.getSpotId() %>">
                もっと見る（全 <%= totalReviews %> 件）
            </a>
        <% } %>

    <% } %>

    <a href="SpotList.action" class="back-btn">一覧へ戻る</a>

</div>

</body>
</html>
