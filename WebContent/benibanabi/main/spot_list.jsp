<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page import="java.util.*" %>
<%@ page import="bean.Spot" %>
<%@ page import="bean.Tag" %>

<%
    // ================================
    // request 属性を安全に受け取る
    // ================================
    List<Spot> spotList = (List<Spot>) request.getAttribute("spotList");
    if (spotList == null) spotList = new ArrayList<>();

    List<Tag> tagAllList = (List<Tag>) request.getAttribute("tagAllList");
    if (tagAllList == null) tagAllList = new ArrayList<>();

    String keyword = (String) request.getAttribute("keyword");
    if (keyword == null) keyword = "";

    List<String> selectedAreas = (List<String>) request.getAttribute("selectedAreas");
    if (selectedAreas == null) selectedAreas = new ArrayList<>();

    List<String> selectedTags = (List<String>) request.getAttribute("selectedTags");
    if (selectedTags == null) selectedTags = new ArrayList<>();

    String favoriteOnly = (String) request.getAttribute("favoriteOnly");
    boolean favoriteFlag = "on".equals(favoriteOnly);
%>

<!DOCTYPE html>
<html lang="ja">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>観光スポット一覧</title>

<style>
body { font-family:"Noto Sans JP",sans-serif; margin:0; padding:0; background:#fafafa; }

/* =======================
   検索メニュー
======================= */
#searchMenu { background:#fff; padding:15px; display:flex; justify-content:center; box-shadow:0 2px 4px #0002; }
#searchMenu form { display:flex; flex-wrap:wrap; gap:10px; }
#searchMenu button, #searchMenu input[type="text"] { padding:8px; font-size:14px; }

/* 詳細選択BOX */
.searchDetailBox { display:none; position:absolute; background:#fff; border:1px solid #ddd; box-shadow:0 2px 4px #0003; padding:10px; width:160px; z-index:10; }
.searchDetailBox ul { list-style:none; padding:0; margin:0; }
.searchDetailBox li { margin-bottom:6px; }
.searchDetailClose { cursor:pointer; float:right; padding:2px; }

/* =======================
   カード一覧
======================= */
.card-container { display:grid; grid-template-columns:repeat(auto-fill,minmax(260px,1fr)); gap:16px; padding:20px; }
.card { position:relative; background:#fff; border-radius:8px; box-shadow:0 2px 6px #0002; overflow:hidden; transition:transform 0.2s; cursor:pointer; }
.card:hover { transform:scale(1.02); }
.card img { width:100%; height:160px; object-fit:cover; }
.card-content { padding:12px; }
.card-content h3 { font-size:18px; margin:6px 0; }
.card-content p { font-size:14px; color:#444; }

/* ===== 星マークをタイトル横に配置 ===== */
.title-row {
    display: flex;
    justify-content: space-between;
    align-items: center;
}

.favorite-star {
    font-size: 22px;
    cursor: pointer;
    color: #cfcfcf;
    user-select: none;
    transition: 0.15s;
    margin-left: 8px;
}

/* 星（お気に入りON） */
.favorite-star.active {
    color: #3399ff;      /* 青色 */
    text-shadow: 0 0 6px #66b3ff; /* 青系の光に変更（任意） */
}

/* 以前の absolute 指定を無効化 */
.favorite-star {
    position: static !important;
}

.result-count { width:100%; text-align:center; font-size:15px; color:#333; padding:10px 0; background:#fff; border-bottom:1px solid #ddd; }
</style>

<script>
// ================================
// Cookie 操作
// ================================
function getFavoriteList() {
    const match = document.cookie.match(/favoriteIds=([^;]+)/);
    if (!match) return [];
    return decodeURIComponent(match[1]).split(",").map(v => v.trim()).filter(v => v);
}

function saveFavoriteList(list) {
    const unique = Array.from(new Set(list.map(String)));
    document.cookie = "favoriteIds=" + encodeURIComponent(unique.join(",")) + "; path=/; max-age=" + (60*60*24*365);
}

// ================================
// 星の初期化とクリック処理
// ================================
function initFavorites() {
    const favs = getFavoriteList();

    document.querySelectorAll(".card").forEach(card => {
        const id = card.dataset.id.toString();
        const star = card.querySelector(".favorite-star");

        const active = favs.includes(id);
        star.textContent = active ? "★" : "☆";
        star.classList.toggle("active", active);

        star.onclick = function(e) {
            e.stopPropagation();
            let updatedFavs = getFavoriteList();
            if (updatedFavs.includes(id)) {
                updatedFavs = updatedFavs.filter(x => x !== id);
            } else {
                updatedFavs.push(id);
            }
            saveFavoriteList(updatedFavs);

            const nowActive = updatedFavs.includes(id);
            star.textContent = nowActive ? "★" : "☆";
            star.classList.toggle("active", nowActive);
        };

        card.onclick = function() {
            location.href = "SpotDetail.action?id=" + id;
        };
    });
}

// ================================
// 検索条件クリア
// ================================
function clearConditions() {
    document.querySelectorAll('input[type="checkbox"]').forEach(cb => cb.checked = false);
    const keywordInput = document.querySelector('input[name="keyword"]');
    if (keywordInput) keywordInput.value = "";
    const fav = document.querySelector('input[name="favoriteOnly"]');
    if (fav) fav.checked = false;

    document.querySelector('#searchMenu form').submit();
}

// ================================
// ドロップダウン
// ================================
function initDropdown() {
    const areaBtn = document.getElementById("areaBtn");
    const tagBtn = document.getElementById("tagBtn");
    const boxes = document.querySelectorAll(".searchDetailBox");

    const toggleBox = (btn, box) => {
        btn.addEventListener("click", () => {
            boxes.forEach(b => b.style.display = "none");
            box.style.display = "block";
        });
        box.querySelector(".searchDetailClose").addEventListener("click", () => {
            box.style.display = "none";
        });
    };

    toggleBox(areaBtn, areaBtn.nextElementSibling);
    toggleBox(tagBtn, tagBtn.nextElementSibling);
}

// ================================
// 初期処理
// ================================
window.addEventListener("DOMContentLoaded", () => {
    initFavorites();
    initDropdown();
});
</script>
</head>

<body>

<div id="searchMenu">
    <form action="SpotSearch.action" method="post">

        <!-- エリア -->
        <div style="position:relative;">
            <button type="button" id="areaBtn">
                <%= selectedAreas.isEmpty() ? "エリア ▼" : "エリア (" + selectedAreas.size() + ") ▼" %>
            </button>
            <div class="searchDetailBox">
                <span class="searchDetailClose">×</span>
                <ul>
                    <li><label><input type="checkbox" name="area" value="庄内" <%= selectedAreas.contains("庄内") ? "checked" : "" %>>庄内</label></li>
                    <li><label><input type="checkbox" name="area" value="最上" <%= selectedAreas.contains("最上") ? "checked" : "" %>>最上</label></li>
                    <li><label><input type="checkbox" name="area" value="置賜" <%= selectedAreas.contains("置賜") ? "checked" : "" %>>置賜</label></li>
                    <li><label><input type="checkbox" name="area" value="村山" <%= selectedAreas.contains("村山") ? "checked" : "" %>>村山</label></li>
                </ul>
            </div>
        </div>

        <!-- タグ -->
        <div style="position:relative;">
            <button type="button" id="tagBtn">
                <%= selectedTags.isEmpty() ? "タグ ▼" : "タグ (" + selectedTags.size() + ") ▼" %>
            </button>
            <div class="searchDetailBox">
                <span class="searchDetailClose">×</span>
                <ul>
                <% for(Tag t : tagAllList){ %>
                    <li>
                        <label>
                            <input type="checkbox" name="tag" value="<%= t.getTagName() %>" <%= selectedTags.contains(t.getTagName()) ? "checked" : "" %>>
                            <%= t.getTagName() %>
                        </label>
                    </li>
                <% } %>
                </ul>
            </div>
        </div>

        <!-- キーワード -->
        <input type="text" name="keyword" value="<%= keyword %>" placeholder="キーワードを入力">

        <!-- お気に入り -->
        <label style="display:flex; align-items:center; gap:4px;">
            <input type="checkbox" name="favoriteOnly" value="on" <%= favoriteFlag ? "checked" : "" %>>
            お気に入り
        </label>

        <button type="submit" onclick="setTimeout(initFavorites, 50)">検索</button>
        <button type="button" onclick="clearConditions()">検索条件クリア</button>
    </form>
</div>

<!-- 件数表示 -->
<div class="result-count">
    <%= spotList.size() %> 件表示
</div>

<!-- カード一覧 -->
<div class="card-container">
<% for (Spot s : spotList) { %>
    <div class="card" data-id="<%= s.getSpotId() %>">
        <img src="<%= request.getContextPath() + s.getSpotPhoto() %>" alt="<%= s.getSpotName() %>">

        <div class="card-content">
            <div class="title-row">
                <h3><%= s.getSpotName() %></h3>
                <span class="favorite-star">☆</span>
            </div>
            <p><%= s.getDescription() %></p>
        </div>
    </div>
<% } %>
</div>

</body>
</html>
