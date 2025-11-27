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

<script>
// -----------------------------
// Cookie 読み込み・保存
// -----------------------------
function getFavoriteList() {
    const match = document.cookie.match(/favoriteIds=([^;]+)/);
    if (!match) return [];
    return decodeURIComponent(match[1]).split(",").filter(v => v);
}

function saveFavoriteList(list) {
    const unique = [...new Set(list)];
    document.cookie =
        "favoriteIds=" + encodeURIComponent(unique.join(",")) +
        "; path=/; max-age=" + (60*60*24*365);
}

// -----------------------------
// お気に入りボタン初期化
// -----------------------------
function initFavorite() {
    const btn = document.getElementById("favoriteBtn");
    const spotId = btn.dataset.id;

    let list = getFavoriteList();
    const isFav = list.includes(spotId);

    // 表示と色
    updateFavoriteButton(btn, isFav);

    btn.onclick = function() {
        let list = getFavoriteList();

        if (list.includes(spotId)) {
            list = list.filter(id => id !== spotId);
        } else {
            list.push(spotId);
        }
        saveFavoriteList(list);

        const nowFav = list.includes(spotId);
        updateFavoriteButton(btn, nowFav);
    };
}

// -----------------------------
// ボタンの色と表示を変える関数
// -----------------------------
function updateFavoriteButton(btn, isFav) {
    if (isFav) {
        btn.textContent = "★ お気に入り解除";
        btn.style.background = "#4dabf7";   // 水色
        btn.style.color = "#fff";
    } else {
        btn.textContent = "☆ お気に入り追加";
        btn.style.background = "#fff";       // 白背景に変更
        btn.style.color = "#4dabf7";
        btn.style.border = "2px solid #4dabf7";
    }
}

window.addEventListener("DOMContentLoaded", initFavorite);
</script>

</head>
<body>

<div class="container">

    <!-- 戻るボタン -->
    <a href="SpotList.action" class="back-btn" style="margin-bottom:15px; display:inline-block;">
        一覧へ戻る
    </a>

    <!-- スポット名 + お気に入り（右上設置） -->
    <h1 style="position: relative;">

        <%= spot.getSpotName() %>

        <!-- ★ 右上の水色お気に入りボタン ★ -->
        <button id="favoriteBtn"
            data-id="<%= spot.getSpotId() %>"
            style="
                position:absolute;
                top:-5px;
                right:0;
                padding:10px 16px;
                font-size:14px;
                background:#fff;
                color:#4dabf7;
                border:2px solid #4dabf7;
                border-radius:6px;
                cursor:pointer;
            ">
            ☆ お気に入り追加
        </button>

    </h1>

    <!-- スポット詳細 -->
    <div class="detail-box" style="text-align:center;">
        <img src="<%= request.getContextPath() + spot.getSpotPhoto() %>"
             class="spot-img"
             alt="spot image"
             style="display:block; margin:0 auto 15px auto; max-width:500px; border-radius:10px;">

        <p style="margin-top: 15px; font-size: 16px; line-height: 1.6; text-align:left;">
            <%= spot.getDescription() %>
        </p>

        <div class="tag-container" style="text-align:left;">
            <strong>タグ：</strong>
            <% for (Tag t : tagList) { %>
                <span class="tag"><%= t.getTagName() %></span>
            <% } %>
        </div>
    </div>

    <!-- 所在地 -->
    <h2 class="section-title">所在地</h2>
    <div class="detail-box">
        <p style="font-size: 16px;">
            <strong>住所：</strong>
            <%= spot.getAddress() %>
        </p>

        <iframe width="100%" height="350"
            style="border:0; border-radius: 10px; margin-top: 15px;"
            loading="lazy" allowfullscreen
            referrerpolicy="no-referrer-when-downgrade"
            src="https://www.google.com/maps?q=<%= spot.getLatitude() %>,<%= spot.getLongitude() %>&z=16&output=embed">
        </iframe>
    </div>

    <!-- 口コミ -->
    <h2 class="section-title">口コミ</h2>

    <%
        int limit = 3;
        int totalReviews = reviewList.size();
    %>

    <% if (totalReviews == 0) { %>

        <p>口コミはまだありません。</p>

    <% } else { %>

        <% for (int i = 0; i < Math.min(limit, totalReviews); i++) {
            Reviews r = reviewList.get(i);
        %>
            <div class="review-box">
                <div class="review-user">投稿者：匿名さん</div>
                <div class="review-content"><%= r.getReviewText() %></div>
                <div>投稿日：<%= r.getReviewDate() %></div>
            </div>
        <% } %>

        <% if (totalReviews > limit) { %>
            <a class="more-btn"
               href="ReviewsList.action?spot_id=<%= spot.getSpotId() %>">
                もっと見る（全 <%= totalReviews %> 件）
            </a>
        <% } %>

    <% } %>

    <!-- 口コミ投稿 -->
    <h2 class="section-title">口コミ投稿</h2>
    <div class="detail-box">

        <form action="ReviewsPost.action" method="post">
            <input type="hidden" name="spot_id" value="<%= spot.getSpotId() %>">
            <textarea name="review_text"
                      rows="4"
                      style="width:100%; padding:10px; font-size:16px;"
                      placeholder="ここに口コミを入力してください..."
                      required></textarea>
            <br>
            <button type="submit" class="more-btn" style="margin-top:10px;">
                投稿する
            </button>
        </form>

    </div>

    <a href="SpotList.action" class="back-btn">一覧へ戻る</a>

</div>

</body>
</html>

</c:param>
</c:import>
