<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page import="java.util.*" %>
<%@ page import="bean.Spot" %>
<%@ page import="bean.Tag" %>

<%
    List<Spot> spotList = (List<Spot>) request.getAttribute("spotList");
    if (spotList == null) spotList = new ArrayList<>();

    ArrayList<Tag> tagAllList = (ArrayList<Tag>) request.getAttribute("tagAllList");
    if (tagAllList == null) tagAllList = new ArrayList<>();

    String keyword = (String) request.getAttribute("keyword");
    if (keyword == null) keyword = "";

    List<String> selectedAreas = (List<String>) request.getAttribute("selectedAreas");
    if (selectedAreas == null) selectedAreas = new ArrayList<>();

    List<String> selectedTags = (List<String>) request.getAttribute("selectedTags");
    if (selectedTags == null) selectedTags = new ArrayList<>();
%>

<!DOCTYPE html>
<html lang="ja">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>観光スポット一覧｜やまがたへの旅</title>

<style>
body { font-family:"Noto Sans JP", sans-serif; margin:0; padding:0; background:#f2f2f2; }
header { background:#2563eb; color:#fff; padding:15px 20px; font-size:22px; text-align:center; }

#searchMenu { background:#fff; padding:15px; border-bottom:1px solid #ddd; display:flex; justify-content:center; }
#searchMenu form { display:flex; gap:10px; flex-wrap:wrap; align-items:center; }

#searchMenu button, #searchMenu input[type=text] {
    padding:6px 12px;
    border-radius:6px;
    border:1px solid #ccc;
    font-size:14px;
    cursor:pointer;
}

#searchMenu input[type=text] { width:200px; }

.searchDetailBox {
    display: none;
    position: absolute;
    top:100%;
    left:0;
    background:#fff;
    border:1px solid #ccc;
    border-radius:6px;
    padding:10px;
    z-index:100;
    max-height:300px;
    overflow-y:auto;
    box-shadow:0 4px 10px rgba(0,0,0,0.15);
    min-width:200px;
}

.searchDetailBox.show { display:block; }

.searchDetailBox ul {
    display:flex;
    flex-wrap:wrap;
    padding:0;
    margin:0;
    list-style:none;
    gap:5px;
}

.searchDetailBox label {
    flex:1 0 45%;
    display:flex;
    align-items:center;
    gap:5px;
    margin-bottom:5px;
}

.searchDetailClose {
    cursor:pointer;
    font-size:18px;
    float:right;
}

.card-container { display:grid; grid-template-columns:repeat(auto-fill, minmax(280px, 1fr)); gap:15px; padding:15px; }
.card { background:#fff; border-radius:8px; overflow:hidden; cursor:pointer; box-shadow:0 2px 4px rgba(0,0,0,0.1); }
.card img { width:100%; height:180px; object-fit:cover; }
.card-content { padding:12px; }

footer { text-align:center; padding:10px; color:#666; }
</style>

<script>
document.addEventListener("DOMContentLoaded", () => {

    // プルダウンボタン切替
    document.querySelectorAll('#searchMenu button[id$="Btn"]').forEach(btn=>{
        btn.addEventListener('click', e=>{
            e.stopPropagation();
            const box = btn.nextElementSibling;
            if(!box) return;
            document.querySelectorAll('.searchDetailBox').forEach(b=>{
                if(b!==box) b.classList.remove('show');
            });
            box.classList.toggle('show');
        });
    });

    // ×ボタンで閉じる
    document.querySelectorAll('.searchDetailClose').forEach(span=>{
        span.addEventListener('click', e=>{
            e.stopPropagation();
            span.closest('.searchDetailBox').classList.remove('show');
        });
    });

    // プルダウン内クリックは閉じない
    document.querySelectorAll('.searchDetailBox').forEach(box=>{
        box.addEventListener('click', e => e.stopPropagation());
    });

    // 画面クリックで閉じる
    document.addEventListener('click', ()=>{
        document.querySelectorAll('.searchDetailBox').forEach(b=>b.classList.remove('show'));
    });

    // ボタン文字更新
    function updateButton(btnId, inputs, defaultText){
        const selected = Array.from(inputs).filter(cb=>cb.checked).map(cb=>cb.value);
        document.getElementById(btnId).textContent = selected.length===0 ? defaultText + " ▼" : `${defaultText} (${selected.length}) ▼`;
    }

    const areaCheckboxes = document.querySelectorAll('input[name="area"]');
    areaCheckboxes.forEach(cb=>cb.addEventListener('change', ()=>updateButton('areaBtn', areaCheckboxes, 'エリア')));
    updateButton('areaBtn', areaCheckboxes, 'エリア');

    const tagCheckboxes = document.querySelectorAll('input[name="tag"]');
    tagCheckboxes.forEach(cb=>cb.addEventListener('change', ()=>updateButton('tagBtn', tagCheckboxes, 'タグ')));
    updateButton('tagBtn', tagCheckboxes, 'タグ');
});

// スポット詳細へ遷移
function goToDetail(url) { location.href = url; }
</script>
</head>
<body>

<header>観光スポット一覧｜やまがたへの旅</header>

<div id="searchMenu">
    <form action="SpotSearch.action" method="post">
        <!-- エリア -->
        <div style="position:relative;">
            <button type="button" id="areaBtn"><%= selectedAreas.isEmpty() ? "エリア ▼" : "エリア (" + selectedAreas.size() + ") ▼" %></button>
            <div class="searchDetailBox">
                <span class="searchDetailClose">×</span>
                <ul>
                    <li><label><input type="checkbox" name="area" value="庄内" <%= selectedAreas.contains("庄内") ? "checked" : "" %> />庄内</label></li>
                    <li><label><input type="checkbox" name="area" value="最上" <%= selectedAreas.contains("最上") ? "checked" : "" %> />最上</label></li>
                    <li><label><input type="checkbox" name="area" value="置賜" <%= selectedAreas.contains("置賜") ? "checked" : "" %> />置賜</label></li>
                    <li><label><input type="checkbox" name="area" value="村山" <%= selectedAreas.contains("村山") ? "checked" : "" %> />村山</label></li>
                </ul>
            </div>
        </div>

        <!-- タグ -->
        <div style="position:relative;">
            <button type="button" id="tagBtn"><%= selectedTags.isEmpty() ? "タグ ▼" : "タグ (" + selectedTags.size() + ") ▼" %></button>
            <div class="searchDetailBox">
                <span class="searchDetailClose">×</span>
                <ul>
                <% for(Tag t : tagAllList){
                       boolean checked = selectedTags.contains(t.getTagName());
                %>
                    <li><label>
                        <input type="checkbox" name="tag" value="<%= t.getTagName() %>" <%= checked ? "checked" : "" %> />
                        <%= t.getTagName() %>
                    </label></li>
                <% } %>
                </ul>
            </div>
        </div>

        <!-- テキスト検索 -->
        <input type="text" name="keyword" value="<%= keyword %>" placeholder="キーワードを入力">

        <!-- 検索ボタン -->
        <button type="submit" class="doSearch">検索</button>
    </form>
</div>

<!-- スポット一覧 -->
<div class="card-container">
<% for (Spot s : spotList) { %>
    <div class="card" onclick="goToDetail('SpotDetail.action?id=<%= s.getSpotId() %>')">
        <img src="<%= request.getContextPath() + s.getSpotPhoto() %>" alt="<%= s.getSpotName() %>" />
        <div class="card-content">
            <h3><%= s.getSpotName() %></h3>
            <p><%= s.getDescription() %></p>
        </div>
    </div>
<% } %>
</div>

<footer>© 2025 山形観光サイト</footer>

</body>
</html>
