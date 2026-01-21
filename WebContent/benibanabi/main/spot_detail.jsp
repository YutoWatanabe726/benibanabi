<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page import="java.util.*" %>
<%@ page import="bean.Spot" %>
<%@ page import="bean.Tag" %>
<%@ page import="bean.Reviews" %>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<c:import url="/common/base.jsp">
<c:param name="title">観光スポット詳細</c:param>
<c:param name="content">

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


<link rel="stylesheet" href="<%= request.getContextPath() %>/css/spot_detail.css">

<script>
// Cookie お気に入り管理
function getFavoriteList() {
    const match = document.cookie.match(/favoriteIds=([^;]+)/);
    if (!match) return [];
    return decodeURIComponent(match[1]).split(",").filter(v => v);
}
function saveFavoriteList(list) {
    const unique = [...new Set(list)];
    document.cookie = "favoriteIds=" + encodeURIComponent(unique.join(",")) + "; path=/; max-age=" + (60*60*24*365);
}

function initFavorite() {
    const btn = document.getElementById("favoriteBtn");
    const spotId = btn.dataset.id;
    const favs = getFavoriteList();
    updateFavoriteButton(btn, favs.includes(spotId));

    btn.onclick = function() {
        let list = getFavoriteList();
        if(list.includes(spotId)) list = list.filter(id => id !== spotId);
        else list.push(spotId);
        saveFavoriteList(list);
        updateFavoriteButton(btn, list.includes(spotId));
    };
}

function updateFavoriteButton(btn, isFav) {
    btn.classList.toggle("active", isFav);
    btn.textContent = isFav ? "★ お気に入り解除" : "☆ お気に入り追加";
}

window.addEventListener("DOMContentLoaded", initFavorite);

/* ===== ここから口コミカウンタ ===== */
function initReviewCounter() {
    const textarea = document.getElementById("reviewText");
    const countSpan = document.getElementById("currentCount");

    if (!textarea || !countSpan) return;

    const update = () => {
        countSpan.textContent = textarea.value.length;
    };

    textarea.addEventListener("input", update);
    update(); // 初期表示
}
/* ================================ */

window.addEventListener("DOMContentLoaded", function () {
    initFavorite();
    initReviewCounter();
});
</script>

</script>

</head>
<body>

<div class="container">

    <a href="SpotSearch.action?page=${page}" class="back-btn">一覧へ戻る</a>

    <div class="spot-header">
        <h1><%= spot.getSpotName() %></h1>
        <button id="favoriteBtn" data-id="<%= spot.getSpotId() %>" class="favorite-star">☆ お気に入り追加</button>
    </div>

    <div class="card detail-box">
        <img src="<%= request.getContextPath() + spot.getSpotPhoto() %>" class="card-img" alt="spot image">
        <p class="card-description"><%= spot.getDescription() %></p>

        <div class="tag-container">
            <% for(Tag t : tagList) { %>
                <span class="tag"><%= t.getTagName() %></span>
            <% } %>
        </div>
    </div>

    <h2 class="section-title">所在地</h2>
    <div class="card detail-box">
        <p><strong>住所：</strong> <%= spot.getAddress() %></p>
        <iframe width="100%" height="350" class="map-frame"
            loading="lazy" allowfullscreen
            referrerpolicy="no-referrer-when-downgrade"
            src="https://www.google.com/maps?q=<%= spot.getLatitude() %>,<%= spot.getLongitude() %>&z=16&output=embed">
        </iframe>
    </div>

    <h2 class="section-title">口コミ</h2>
    <%
        int limit = 3;
        int totalReviews = reviewList.size();
    %>
    <% if(totalReviews == 0) { %>
        <p>口コミはまだありません。</p>
    <% } else { %>
        <% for(int i=0;i<Math.min(limit,totalReviews);i++){
            Reviews r = reviewList.get(i);
        %>
        <div class="card review-box">
            <div class="review-user">投稿者：匿名さん</div>
            <div class="review-content"><%= r.getReviewText() %></div>
            <div>投稿日：<%= r.getReviewDate() %></div>
        </div>
        <% } %>
        <% if(totalReviews > limit){ %>
        <a href="ReviewsList.action?spot_id=<%= spot.getSpotId() %>" class="more-btn">もっと見る（全 <%= totalReviews %> 件）</a>
        <% } %>
    <% } %>

    <h2 class="section-title">口コミ投稿</h2>
<div class="card detail-box">
    <form action="ReviewsPost.action" method="post" onsubmit="return checkReviewLength();">
        <input type="hidden" name="spot_id" value="<%= spot.getSpotId() %>">

        <textarea id="reviewText"
          name="review_text"
          rows="4"
          placeholder="ここに口コミを入力してください...（300文字以内）"
          maxlength="300"
          required></textarea>

<div class="char-count">
    <span id="currentCount">0</span> / 300 文字
</div>


        <button type="submit" class="more-btn">投稿する</button>
    </form>
</div>


    <a href="SpotSearch.action?page=${page}" class="back-btn">一覧へ戻る</a>

</div>

</body>
</html>
</c:param>
</c:import>
