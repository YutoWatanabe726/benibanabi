<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page import="java.util.*" %>
<%@ page import="bean.Spot" %>
<%@ page import="bean.Tag" %>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>


<c:import url="/common/base.jsp">
    <c:param name="title">
        観光スポット一覧
    </c:param>

    <c:param name="content">
    <%
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

        Integer currentPage = (Integer) request.getAttribute("currentPage");
        if (currentPage == null) currentPage = 1;
        Integer totalPages = (Integer) request.getAttribute("totalPages");
        if (totalPages == null) totalPages = 1;

        Integer totalCount = (Integer) request.getAttribute("totalCount");
        if (totalCount == null) totalCount = spotList.size();

    %>

<!DOCTYPE html>
<html lang="ja">
<head>
<meta charset="UTF-8">

<title>観光スポット一覧</title>

<!-- CSS読み込み -->

<link rel="stylesheet" href="<%= request.getContextPath() %>/css/spotList.css">

<script>
// ===============================
// Cookie操作・お気に入り管理
// ===============================
function getFavoriteList() {
    const match = document.cookie.match(/favoriteIds=([^;]+)/);
    if (!match) return [];
    return decodeURIComponent(match[1]).split(",").map(v => v.trim()).filter(v => v);
}
function saveFavoriteList(list) {
    const unique = Array.from(new Set(list.map(String)));
    document.cookie = "favoriteIds=" + encodeURIComponent(unique.join(",")) + "; path=/; max-age=" + (60*60*24*365);
}

// お気に入り星初期化
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
            if(updatedFavs.includes(id)) updatedFavs = updatedFavs.filter(x=>x!==id);
            else updatedFavs.push(id);
            saveFavoriteList(updatedFavs);
            const nowActive = updatedFavs.includes(id);
            star.textContent = nowActive ? "★" : "☆";
            star.classList.toggle("active", nowActive);
        };
        card.onclick = function() {
            location.href =
                "SpotDetail.action?spot_id=" + id + "&page=<%= currentPage %>";
        };

    });
}

// エリア・タグ選択数を更新
function updateSelectedCounts() {
    const areaCount = document.querySelectorAll('input[name="area"]:checked').length;
    const tagCount  = document.querySelectorAll('input[name="tag"]:checked').length;

    document.getElementById("areaCount").textContent = areaCount;
    document.getElementById("tagCount").textContent  = tagCount;
}


// 検索条件クリア
function clearConditions() {
    // チェックボックス全解除
    document.querySelectorAll('input[type="checkbox"]').forEach(cb => cb.checked = false);

    // キーワードクリア
    const keywordInput = document.querySelector('input[name="keyword"]');
    if (keywordInput) keywordInput.value = "";

    // ページ番号を削除（重要）
    const pageInput = document.querySelector('input[name="page"]');
    if (pageInput) pageInput.remove();

    // フォーム送信（検索実行）
    document.getElementById("searchForm").submit();
}


// モーダル表示
function openModal(id) { document.getElementById(id).style.display="flex"; }
function closeModal(id) { document.getElementById(id).style.display="none"; }

// ページネーションジャンプ
function goPage(page) {
    const form = document.getElementById("searchForm");

    // 既存の page を削除（重要）
    const old = form.querySelector('input[name="page"]');
    if (old) old.remove();

    const input = document.createElement("input");
    input.type = "hidden";
    input.name = "page";
    input.value = page;
    form.appendChild(input);

    form.submit();
}

// DOM初期化（1回だけ）
window.addEventListener("DOMContentLoaded", () => {
    initFavorites();
    updateSelectedCounts();
});

// モーダル外クリックで閉じる
window.addEventListener("click", function(e) {
    document.querySelectorAll(".modal").forEach(modal => {
        if (e.target === modal) modal.style.display = "none";
    });
});
</script>
</head>

<body>

<div class="page-title">
    <h1>観光スポット一覧</h1>
</div>

<form id="searchForm" action="SpotSearch.action" method="post">
<div id="searchMenu">

    <!-- 上段：キーワード -->
    <div class="search-row keyword-row">
        <input type="text" name="keyword" value="<%= keyword %>" placeholder="スポット名・説明で検索">
    </div>

    <!-- 中段：条件ボタン -->
    <div class="search-row condition-row">
        <button type="button" id="areaBtn" onclick="openModal('areaModal')">
            エリア (<span id="areaCount">0</span>)
        </button>

        <button type="button" id="tagBtn" onclick="openModal('tagModal')">
            タグ (<span id="tagCount">0</span>)
        </button>

        <label class="favorite-toggle">
            <input type="checkbox" name="favoriteOnly" value="on" <%= favoriteFlag ? "checked" : "" %>>
            <span>★ お気に入りのみ</span>
        </label>
    </div>

    <!-- 下段：実行 -->
    <div class="search-row action-row">
        <button type="submit" class="search-btn">🔍 検索</button>
        <button type="button" class="clear-btn" onclick="clearConditions()">条件クリア</button>
    </div>

</div>


<div class="result-count">
    <%= totalCount %> 件表示
</div>


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

<div class="pagination">

    <!-- 先頭ページ -->
    <button class="nav-btn"
        onclick="goPage(1)"
        <%= currentPage == 1 ? "disabled" : "" %>>
        ⏮
    </button>

    <!-- 前のページ -->
    <button class="nav-btn"
        onclick="goPage(<%= currentPage - 1 %>)"
        <%= currentPage == 1 ? "disabled" : "" %>>
        ◀
    </button>

    <!-- 現在のページ -->
    <span class="current-page">
        <%= currentPage %>
    </span>

    <!-- 次のページ -->
    <button class="nav-btn"
        onclick="goPage(<%= currentPage + 1 %>)"
        <%= currentPage == totalPages ? "disabled" : "" %>>
        ▶
    </button>

    <!-- 最終ページ -->
    <button class="nav-btn"
        onclick="goPage(<%= totalPages %>)"
        <%= currentPage == totalPages ? "disabled" : "" %>>
        ⏭
    </button>

</div>


<!-- モーダル: エリア選択 -->
<div id="areaModal" class="modal">
    <div class="modal-content">
        <span class="modal-close" onclick="closeModal('areaModal')">×</span>
        <h2>エリア選択</h2>
        <ul>
            <!-- 庄内 -->
            <li class="area-group-title">庄内</li>
            <li><label><input type="checkbox" name="area" value="鶴岡市" onchange="updateSelectedCounts()"<%= selectedAreas.contains("鶴岡市")?"checked":"" %>>鶴岡市</label></li>
            <li><label><input type="checkbox" name="area" value="酒田市" onchange="updateSelectedCounts()"<%= selectedAreas.contains("酒田市")?"checked":"" %>>酒田市</label></li>
            <li><label><input type="checkbox" name="area" value="三川町" onchange="updateSelectedCounts()"<%= selectedAreas.contains("三川町")?"checked":"" %>>三川町</label></li>
            <li><label><input type="checkbox" name="area" value="庄内町" onchange="updateSelectedCounts()"<%= selectedAreas.contains("庄内町")?"checked":"" %>>庄内町</label></li>
            <li><label><input type="checkbox" name="area" value="遊佐町" onchange="updateSelectedCounts()"<%= selectedAreas.contains("遊佐町")?"checked":"" %>>遊佐町</label></li>
            <!-- 最上 -->
            <li class="area-group-title">最上</li>
            <li><label><input type="checkbox" name="area" value="新庄市" onchange="updateSelectedCounts()"<%= selectedAreas.contains("新庄市")?"checked":"" %>>新庄市</label></li>
            <li><label><input type="checkbox" name="area" value="金山町" onchange="updateSelectedCounts()"<%= selectedAreas.contains("金山町")?"checked":"" %>>金山町</label></li>
            <li><label><input type="checkbox" name="area" value="最上町" onchange="updateSelectedCounts()"<%= selectedAreas.contains("最上町")?"checked":"" %>>最上町</label></li>
            <li><label><input type="checkbox" name="area" value="舟形町" onchange="updateSelectedCounts()"<%= selectedAreas.contains("舟形町")?"checked":"" %>>舟形町</label></li>
            <li><label><input type="checkbox" name="area" value="真室川町" onchange="updateSelectedCounts()"<%= selectedAreas.contains("真室川町")?"checked":"" %>>真室川町</label></li>
            <li><label><input type="checkbox" name="area" value="大蔵村" onchange="updateSelectedCounts()"<%= selectedAreas.contains("大蔵村")?"checked":"" %>>大蔵村</label></li>
            <li><label><input type="checkbox" name="area" value="鮭川村" onchange="updateSelectedCounts()"<%= selectedAreas.contains("鮭川村")?"checked":"" %>>鮭川村</label></li>
            <li><label><input type="checkbox" name="area" value="戸沢村" onchange="updateSelectedCounts()"<%= selectedAreas.contains("戸沢村")?"checked":"" %>>戸沢村</label></li>
            <!-- 置賜 -->
            <li class="area-group-title">置賜</li>
            <li><label><input type="checkbox" name="area" value="米沢市" onchange="updateSelectedCounts()"<%= selectedAreas.contains("米沢市")?"checked":"" %>>米沢市</label></li>
            <li><label><input type="checkbox" name="area" value="長井市" onchange="updateSelectedCounts()"<%= selectedAreas.contains("長井市")?"checked":"" %>>長井市</label></li>
            <li><label><input type="checkbox" name="area" value="南陽市" onchange="updateSelectedCounts()"<%= selectedAreas.contains("南陽市")?"checked":"" %>>南陽市</label></li>
            <li><label><input type="checkbox" name="area" value="高畠町" onchange="updateSelectedCounts()"<%= selectedAreas.contains("高畠町")?"checked":"" %>>高畠町</label></li>
            <li><label><input type="checkbox" name="area" value="川西町" onchange="updateSelectedCounts()"<%= selectedAreas.contains("川西町")?"checked":"" %>>川西町</label></li>
            <li><label><input type="checkbox" name="area" value="飯豊町" onchange="updateSelectedCounts()"<%= selectedAreas.contains("飯豊町")?"checked":"" %>>飯豊町</label></li>
            <li><label><input type="checkbox" name="area" value="白鷹町" onchange="updateSelectedCounts()"<%= selectedAreas.contains("白鷹町")?"checked":"" %>>白鷹町</label></li>
            <!-- 村山 -->
            <li class="area-group-title">村山</li>
            <li><label><input type="checkbox" name="area" value="山形市" onchange="updateSelectedCounts()"<%= selectedAreas.contains("山形市")?"checked":"" %>>山形市</label></li>
            <li><label><input type="checkbox" name="area" value="寒河江市" onchange="updateSelectedCounts()"<%= selectedAreas.contains("寒河江市")?"checked":"" %>>寒河江市</label></li>
            <li><label><input type="checkbox" name="area" value="上山市" onchange="updateSelectedCounts()"<%= selectedAreas.contains("上山市")?"checked":"" %>>上山市</label></li>
            <li><label><input type="checkbox" name="area" value="村山市" onchange="updateSelectedCounts()"<%= selectedAreas.contains("村山市")?"checked":"" %>>村山市</label></li>
            <li><label><input type="checkbox" name="area" value="天童市" onchange="updateSelectedCounts()"<%= selectedAreas.contains("天童市")?"checked":"" %>>天童市</label></li>
            <li><label><input type="checkbox" name="area" value="東根市" onchange="updateSelectedCounts()"<%= selectedAreas.contains("東根市")?"checked":"" %>>東根市</label></li>
            <li><label><input type="checkbox" name="area" value="尾花沢市" onchange="updateSelectedCounts()"<%= selectedAreas.contains("尾花沢市")?"checked":"" %>>尾花沢市</label></li>
            <li><label><input type="checkbox" name="area" value="山辺町" onchange="updateSelectedCounts()"<%= selectedAreas.contains("山辺町")?"checked":"" %>>山辺町</label></li>
            <li><label><input type="checkbox" name="area" value="中山町" onchange="updateSelectedCounts()"<%= selectedAreas.contains("中山町")?"checked":"" %>>中山町</label></li>
            <li><label><input type="checkbox" name="area" value="河北町" onchange="updateSelectedCounts()"<%= selectedAreas.contains("河北町")?"checked":"" %>>河北町</label></li>
            <li><label><input type="checkbox" name="area" value="西川町" onchange="updateSelectedCounts()"<%= selectedAreas.contains("西川町")?"checked":"" %>>西川町</label></li>
            <li><label><input type="checkbox" name="area" value="朝日町" onchange="updateSelectedCounts()"<%= selectedAreas.contains("朝日町")?"checked":"" %>>朝日町</label></li>
            <li><label><input type="checkbox" name="area" value="大江町" onchange="updateSelectedCounts()"<%= selectedAreas.contains("大江町")?"checked":"" %>>大江町</label></li>
            <li><label><input type="checkbox" name="area" value="大石田町" onchange="updateSelectedCounts()"<%= selectedAreas.contains("大石田町")?"checked":"" %>>大石田町</label></li>
        </ul>
    </div>
</div>

<!-- モーダル: タグ選択 -->
<div id="tagModal" class="modal">
    <div class="modal-content">
        <span class="modal-close" onclick="closeModal('tagModal')">×</span>
        <h2>タグ選択</h2>
        <ul>
            <% for(Tag t : tagAllList) { %>
                <li><label>
                    <input type="checkbox" name="tag" value="<%= t.getTagName() %>"
                    onchange="updateSelectedCounts()"
                           <%= selectedTags.contains(t.getTagName()) ? "checked" : "" %> >
                    <%= t.getTagName() %>
                </label></li>
            <% } %>
        </ul>
    </div>
</div>

</form>
</body>
</html>
    </c:param>
</c:import>
