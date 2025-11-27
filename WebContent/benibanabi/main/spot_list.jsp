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

        // ページネーション用
        Integer currentPage = (Integer) request.getAttribute("currentPage");
        if (currentPage == null) currentPage = 1;
        Integer totalPages = (Integer) request.getAttribute("totalPages");
        if (totalPages == null) totalPages = 1;
    %>

<!DOCTYPE html>
<html lang="ja">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>観光スポット一覧</title>

<style>
body { font-family:"Noto Sans JP",sans-serif; margin:0; padding:0; background:#fafafa; }

/* 検索メニュー */
#searchMenu { background:#fff; padding:15px; display:flex; justify-content:center; flex-wrap:wrap; box-shadow:0 2px 4px #0002; gap:8px; }
#searchMenu button, #searchMenu input[type="text"] { padding:8px; font-size:14px; }

/* モーダル共通 */
.modal { display:none; position:fixed; top:0; left:0; width:100%; height:100%; background:rgba(0,0,0,0.5); justify-content:center; align-items:center; z-index:1000; }
.modal-content { background:#fff; width:80%; max-width:800px; max-height:80%; overflow-y:auto; padding:20px; border-radius:8px; position:relative; }
.modal-close { position:absolute; top:10px; right:15px; font-size:20px; cursor:pointer; }

/* グループタイトル */
.area-group-title { font-weight:bold; margin-top:12px; margin-bottom:4px; border-bottom:1px solid #ccc; padding-bottom:3px; }

/* カード一覧 */
.card-container { display:grid; grid-template-columns:repeat(auto-fill,minmax(260px,1fr)); gap:16px; padding:20px; }
.card { position:relative; background:#fff; border-radius:8px; box-shadow:0 2px 6px #0002; overflow:hidden; transition:transform 0.2s; cursor:pointer; }
.card:hover { transform:scale(1.02); }
.card img { width:100%; height:160px; object-fit:cover; }
.card-content { padding:12px; }
.card-content h3 { font-size:18px; margin:6px 0; }
.card-content p { font-size:14px; color:#444; }

/* 星マーク */
.title-row { display:flex; justify-content:space-between; align-items:center; }
.favorite-star { font-size:22px; cursor:pointer; color:#cfcfcf; user-select:none; transition:0.15s; }
.favorite-star.active { color:#3399ff; text-shadow:0 0 6px #66b3ff; }

.result-count { width:100%; text-align:center; font-size:15px; color:#333; padding:10px 0; background:#fff; border-bottom:1px solid #ddd; }

/* ページネーション */
.pagination { text-align:center; margin:15px 0; }
.pagination button { padding:5px 10px; margin:0 2px; font-size:14px; }
.pagination button.active { background:#3399ff; color:#fff; border-radius:4px; }
</style>

<script>
// Cookie操作
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
            location.href = "SpotDetail.action?spot_id=" + id;
        };
    });
}

// 検索条件クリア
function clearConditions() {
    document.querySelectorAll('input[type="checkbox"]').forEach(cb=>cb.checked=false);
    const keywordInput = document.querySelector('input[name="keyword"]');
    if(keywordInput) keywordInput.value="";
    const fav = document.querySelector('input[name="favoriteOnly"]');
    if(fav) fav.checked=false;
    document.querySelector('#searchMenu form').submit();
}

// モーダル表示
function openModal(id) { document.getElementById(id).style.display="flex"; }
function closeModal(id) { document.getElementById(id).style.display="none"; }

// ページネーションジャンプ
function goPage(page) {
    const form = document.querySelector('#searchMenu form');
    const input = document.createElement("input");
    input.type = "hidden";
    input.name = "page";
    input.value = page;
    form.appendChild(input);
    form.submit();
}

// DOM初期化
window.addEventListener("DOMContentLoaded",()=>{ initFavorites(); });
</script>
</head>

<body>

<div style="text-align:center; margin:20px 0;">
    <h1>観光スポット一覧</h1>
</div>

<div id="searchMenu">
    <form action="SpotSearch.action" method="post">
        <button type="button" onclick="openModal('areaModal')">
            <%= selectedAreas.isEmpty() ? "エリア選択 ▼" : "エリア (" + selectedAreas.size() + ") ▼" %>
        </button>

        <button type="button" onclick="openModal('tagModal')">
            <%= selectedTags.isEmpty() ? "タグ選択 ▼" : "タグ (" + selectedTags.size() + ") ▼" %>
        </button>

        <input type="text" name="keyword" value="<%= keyword %>" placeholder="キーワードを入力">

        <label style="display:flex; align-items:center; gap:4px;">
            <input type="checkbox" name="favoriteOnly" value="on" <%= favoriteFlag ? "checked" : "" %>>
            お気に入り
        </label>

        <button type="submit" onclick="setTimeout(initFavorites,50)">検索</button>
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

<!-- ページネーション -->
<div class="pagination">
<% for(int i=1; i<=totalPages; i++){ %>
    <button class="<%= (i==currentPage)?"active":"" %>" onclick="goPage(<%=i%>)"><%=i%></button>
<% } %>
</div>

<!-- モーダル: エリア選択 -->
<div id="areaModal" class="modal">
    <div class="modal-content">
        <span class="modal-close" onclick="closeModal('areaModal')">×</span>
        <h2>エリア選択</h2>
        <ul>
            <!-- 庄内 -->
            <li class="area-group-title">庄内</li>
            <li><label><input type="checkbox" name="area" value="鶴岡市" <%= selectedAreas.contains("鶴岡市")?"checked":"" %>>鶴岡市</label></li>
            <li><label><input type="checkbox" name="area" value="酒田市" <%= selectedAreas.contains("酒田市")?"checked":"" %>>酒田市</label></li>
            <li><label><input type="checkbox" name="area" value="三川町" <%= selectedAreas.contains("三川町")?"checked":"" %>>三川町</label></li>
            <li><label><input type="checkbox" name="area" value="庄内町" <%= selectedAreas.contains("庄内町")?"checked":"" %>>庄内町</label></li>
            <li><label><input type="checkbox" name="area" value="遊佐町" <%= selectedAreas.contains("遊佐町")?"checked":"" %>>遊佐町</label></li>
            <!-- 最上 -->
            <li class="area-group-title">最上</li>
            <li><label><input type="checkbox" name="area" value="新庄市" <%= selectedAreas.contains("新庄市")?"checked":"" %>>新庄市</label></li>
            <li><label><input type="checkbox" name="area" value="金山町" <%= selectedAreas.contains("金山町")?"checked":"" %>>金山町</label></li>
            <li><label><input type="checkbox" name="area" value="最上町" <%= selectedAreas.contains("最上町")?"checked":"" %>>最上町</label></li>
            <li><label><input type="checkbox" name="area" value="舟形町" <%= selectedAreas.contains("舟形町")?"checked":"" %>>舟形町</label></li>
            <li><label><input type="checkbox" name="area" value="真室川町" <%= selectedAreas.contains("真室川町")?"checked":"" %>>真室川町</label></li>
            <li><label><input type="checkbox" name="area" value="大蔵村" <%= selectedAreas.contains("大蔵村")?"checked":"" %>>大蔵村</label></li>
            <li><label><input type="checkbox" name="area" value="鮭川村" <%= selectedAreas.contains("鮭川村")?"checked":"" %>>鮭川村</label></li>
            <li><label><input type="checkbox" name="area" value="戸沢村" <%= selectedAreas.contains("戸沢村")?"checked":"" %>>戸沢村</label></li>
            <!-- 置賜 -->
            <li class="area-group-title">置賜</li>
            <li><label><input type="checkbox" name="area" value="米沢市" <%= selectedAreas.contains("米沢市")?"checked":"" %>>米沢市</label></li>
            <li><label><input type="checkbox" name="area" value="長井市" <%= selectedAreas.contains("長井市")?"checked":"" %>>長井市</label></li>
            <li><label><input type="checkbox" name="area" value="南陽市" <%= selectedAreas.contains("南陽市")?"checked":"" %>>南陽市</label></li>
            <li><label><input type="checkbox" name="area" value="高畠町" <%= selectedAreas.contains("高畠町")?"checked":"" %>>高畠町</label></li>
            <li><label><input type="checkbox" name="area" value="川西町" <%= selectedAreas.contains("川西町")?"checked":"" %>>川西町</label></li>
            <li><label><input type="checkbox" name="area" value="飯豊町" <%= selectedAreas.contains("飯豊町")?"checked":"" %>>飯豊町</label></li>
            <li><label><input type="checkbox" name="area" value="白鷹町" <%= selectedAreas.contains("白鷹町")?"checked":"" %>>白鷹町</label></li>
            <!-- 村山 -->
            <li class="area-group-title">村山</li>
            <li><label><input type="checkbox" name="area" value="山形市" <%= selectedAreas.contains("山形市")?"checked":"" %>>山形市</label></li>
            <li><label><input type="checkbox" name="area" value="寒河江市" <%= selectedAreas.contains("寒河江市")?"checked":"" %>>寒河江市</label></li>
            <li><label><input type="checkbox" name="area" value="上山市" <%= selectedAreas.contains("上山市")?"checked":"" %>>上山市</label></li>
            <li><label><input type="checkbox" name="area" value="村山市" <%= selectedAreas.contains("村山市")?"checked":"" %>>村山市</label></li>
            <li><label><input type="checkbox" name="area" value="天童市" <%= selectedAreas.contains("天童市")?"checked":"" %>>天童市</label></li>
            <li><label><input type="checkbox" name="area" value="東根市" <%= selectedAreas.contains("東根市")?"checked":"" %>>東根市</label></li>
            <li><label><input type="checkbox" name="area" value="尾花沢市" <%= selectedAreas.contains("尾花沢市")?"checked":"" %>>尾花沢市</label></li>
            <li><label><input type="checkbox" name="area" value="山辺町" <%= selectedAreas.contains("山辺町")?"checked":"" %>>山辺町</label></li>
            <li><label><input type="checkbox" name="area" value="中山町" <%= selectedAreas.contains("中山町")?"checked":"" %>>中山町</label></li>
            <li><label><input type="checkbox" name="area" value="河北町" <%= selectedAreas.contains("河北町")?"checked":"" %>>河北町</label></li>
            <li><label><input type="checkbox" name="area" value="西川町" <%= selectedAreas.contains("西川町")?"checked":"" %>>西川町</label></li>
            <li><label><input type="checkbox" name="area" value="朝日町" <%= selectedAreas.contains("朝日町")?"checked":"" %>>朝日町</label></li>
            <li><label><input type="checkbox" name="area" value="大江町" <%= selectedAreas.contains("大江町")?"checked":"" %>>大江町</label></li>
            <li><label><input type="checkbox" name="area" value="大石田町" <%= selectedAreas.contains("大石田町")?"checked":"" %>>大石田町</label></li>
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
                           <%= selectedTags.contains(t.getTagName()) ? "checked" : "" %>>
                    <%= t.getTagName() %>
                </label></li>
            <% } %>
        </ul>
    </div>
</div>

</body>
</html>
    </c:param>
</c:import>
