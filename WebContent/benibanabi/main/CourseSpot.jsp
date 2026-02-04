<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="true"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<c:import url="/common/base.jsp">
  <c:param name="title">
  コース作成
  </c:param>

  <c:param name="content">
<!DOCTYPE html>
<html lang="ja">
<head>
<meta charset="UTF-8">
<title>旅のルート作成</title>

<!-- Leaflet -->
<link rel="stylesheet" href="https://unpkg.com/leaflet@1.9.4/dist/leaflet.css"/>
<link rel="stylesheet" href="https://unpkg.com/leaflet.markercluster/dist/MarkerCluster.css" />
<link rel="stylesheet" href="https://unpkg.com/leaflet.markercluster/dist/MarkerCluster.Default.css" />

<!-- Bootstrap -->
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
<style>

/* ================================
   全体レイアウト
================================ */
body {
  font-family: Arial, sans-serif;
  background: #f8f8f8;
  margin: 0;
  padding: 0;
  color: #333;
}

h3 {
  margin-bottom: 0;
}

/* ================================
   サイドバー
================================ */
.sidebar button {
  margin-bottom: 6px;
  padding: 6px 12px;
  border-radius: 8px;
  border: none;
  background: #ffb35e;
  color: #fff;
  font-weight: 600;
  cursor: pointer;
  transition: 0.3s;
}

.sidebar button:hover {
  background: #d92929;
}

/* Day出発時刻 */
.day-starttime-box {
  background: #fff7ef;
  border: 1px solid #ffd0a6;
  border-radius: 10px;
  padding: 10px;
  margin-bottom: 10px;
}
.day-starttime-box .label {
  font-weight: 700;
  margin-bottom: 6px;
}
.day-starttime-box input[type="time"]{
  width: 100%;
  padding: 8px 10px;
  border: 1px solid #ccc;
  border-radius: 8px;
}

/* ================================
   履歴表示エリア
================================ */
.route-history {
  max-height: 450px;
  overflow-y: auto;
  border-top: 1px solid #ccc;
  padding-top: 10px;
}

/* ================================
   カード（スポット / ルート）
================================ */
.route-card, .route-item {
  background: #fff;
  border-radius: 10px;
  padding: 10px 12px;
  margin-bottom: 12px;
  box-shadow: 0 2px 5px rgba(0,0,0,0.1);
  transition: 0.2s;
}

.route-card:hover, .route-item:hover {
  box-shadow: 0 4px 12px rgba(0,0,0,0.15);
}

/* カードヘッダー */
.route-card .card-header,
.route-item .card-header {
  font-weight: bold;
  font-size: 1rem;
  display: flex;
  justify-content: space-between;
  align-items: center;
}

/* 削除ボタン */
.removeBtn {
  background: #ff5a5a;
  border: none;
  color: #fff;
  padding: 2px 8px;
  border-radius: 5px;
  cursor: pointer;
  transition: 0.2s;
}

.removeBtn:hover {
  background: #ff2e2e;
}

/* 滞在時間・メモ */
.route-card .card-body {
  margin-top: 6px;
  font-size: 0.9rem;
  color: #444;
}

.stayTimeInput, .stayTime {
  width: 60px;
}

.memoInput {
  width: 100%;
  margin-top: 4px;
}

.small-muted {
  color: #666;
  font-size: 0.85rem;
  margin-bottom: 4px;
}

/* 到着/出発表示（追加） */
.time-row {
  margin-top: 6px;
  padding: 6px 8px;
  background: #f6fbff;
  border: 1px solid #d6ecff;
  border-radius: 8px;
  font-size: 0.85rem;
  color: #245b88;
}
.time-row b {
  color: #1a4b7a;
}

/* ================================
   矢印カード（移動情報）
================================ */
.arrow-card {
  display: inline-flex;
  align-items: center;
  gap: 6px;
  background: #f0f4ff;
  border-left: 4px solid #4f7cff;
  padding: 0 12px;
  margin: -4px 0 12px 0;
  border-radius: 8px;
  font-size: 0.9rem;
  box-shadow: 0 1px 3px rgba(0,0,0,0.08);
  white-space: nowrap;
  overflow: hidden;
}

.arrow-card::before {
  content: "↓";
  font-weight: bold;
  font-size: 1.2rem;
  color: #4f7cff;
  margin-right: 5px;
}

.arrow-card select,
.arrow-card input {
  font-size: 0.9rem;
  margin-left: 4px;
}

/* ================================
   モーダル内カード
================================ */
.modal-card {
  border: 1px solid #ddd;
  padding: 8px;
  margin: 6px;
  cursor: pointer;
  position: relative;
  border-radius: 8px;
  background: #fff;
  transition: box-shadow 0.2s;
}

.modal-card:hover {
  box-shadow: 0 3px 8px rgba(0,0,0,0.15);
}

.spot-title-row {
  display: flex;
  align-items: center;
  justify-content: space-between;
  gap: 8px;
}

.spot-title {
  margin: 0;
  font-size: 1rem;
  font-weight: 600;
}

.favorite {
	position:static;
    font-size: 30px;              /* 見た目を少し大きく */
    width: 40px;                  /* ★ タップ領域を確保 */
    height: 40px;
    line-height: 40px;
    text-align: center;

    cursor: pointer;
    color: #d0d0d0;
    user-select: none;

    border-radius: 50%;
    background: rgba(255,255,255,0.9); /* 白背景で独立感 */
    box-shadow: 0 2px 6px rgba(0,0,0,0.15);

    transition:
        transform 0.2s,
        box-shadow 0.2s,
        background 0.2s,
        color 0.2s;
}

.favorite:hover {
    transform: scale(1.1);
    box-shadow: 0 4px 12px rgba(0,0,0,0.25);
    background: #fff4ee;
}

/* お気に入りON */
.favorite.active {
    color: #D92929;
    background: linear-gradient(135deg, #FFEEE4, #FFD2C2);
    box-shadow: 0 0 10px rgba(217,41,41,0.45);
}

/* クリック時（押した感） */
.favorite:active {
    transform: scale(0.95);
}


/* ================================
   Day セクション
================================ */
#routesContainer .day-section {
  margin-bottom: 30px;
  background: #fff;
  padding: 14px;
  border-radius: 12px;
  box-shadow: 0 2px 6px rgba(0,0,0,0.08);
}

/* ================================
   マップ
================================ */
.map-container {
  flex: 1;
  height: 600px;
  min-height: 300px;
  border-radius: 10px;
  overflow: hidden;
}

/* ================================
   インラインフォーム
================================ */
.form-inline {
  display: flex;
  gap: 8px;
  align-items: center;
}

/* ================================
   汎用ボタン
================================ */
.btn {
  display: inline-block;
  padding: 10px 24px;
  font-size: 1rem;
  font-weight: 700;
  text-decoration: none;
  color: #fff;
  border-radius: 50px;
  background: linear-gradient(90deg, #FFB35E, #D92929);
  box-shadow: 0 10px 22px rgba(217,41,41,0.35);
  transition: 0.3s;
  cursor: pointer;
  text-align: center;
  border: none;
}

.btn:hover {
  transform: translateY(-3px);
  box-shadow: 0 14px 28px rgba(217,41,41,0.48);
}
/* コンテナ全体 */
.container.mb-3 {
  background-color: #f9f9f9;
  padding: 16px;
  border-radius: 8px;
  box-shadow: 0 2px 6px rgba(0,0,0,0.1);
  font-family: Arial, sans-serif;
}

/* 行全体 */
.container.mb-3 .row > .col-md-8 > div {
  margin-bottom: 8px;
  display: flex;
  align-items: center;
}

/* ラベル部分 */
.container.mb-3 strong {
  width: 80px; /* ラベル幅を揃える */
  display: inline-block;
  color: #333;
}

/* 値部分 */
.container.mb-3 span {
  color: #555;
}

/* 小さめ文字の補足 */
.container.mb-3 .small-muted {
  font-size: 0.85em;
  color: #888;
  margin-left: 4px;
}

/* 日数表示を目立たせる */
#tripDaysDisplay {
  font-weight: bold;
  color: #2a7ae2;
}

/* コースタイトルを強調 */
#courseTitle {
  font-size: 1.1em;
  font-weight: bold;
  color: #1a4b7a;
}

/* 候補選択モーダル内マップ */
#candidateMap {
  width: 100%;
  height: 360px;
  border-radius: 10px;
  overflow: hidden;
  border: 1px solid #ddd;
}
#candidateList {
  max-height: 220px;
  overflow-y: auto;
}
.candidate-item {
  padding: 8px 10px;
  border: 1px solid #eee;
  border-radius: 8px;
  margin-bottom: 6px;
  cursor: pointer;
  background: #fff;
}
.candidate-item.active {
  border-color: #ff7043;
  box-shadow: 0 0 0 2px rgba(255,112,67,0.18);
}

/* ================================
   📱 スマホ対応（600px以下）
================================ */
@media (max-width: 600px) {

  body {
    font-size: 16px;
    overflow-x: hidden;
  }

  h3 {
    font-size: 1.2rem;
    margin: 10px 0;
  }

  /* 上のコース情報 */
  .container.mb-3 {
    padding: 12px;
  }

  .container.mb-3 .row {
    flex-direction: column;
  }

  .container.mb-3 .col-md-8,
  .container.mb-3 .col-md-4 {
    width: 100%;
    text-align: left !important;
  }

  #confirmRouteBtn {
    width: 100%;
    margin-top: 10px;
  }

  /* Day全体 */
  #routesContainer .day-section {
    padding: 10px;
  }

  /* サイドバー＋マップを縦並びに */
  #routesContainer .day-section > div {
    flex-direction: column !important;
  }

  .sidebar {
    width: 100% !important;
    margin-bottom: 10px;
  }

  .map-container {
    width: 100% !important;
    height: 300px !important;
    min-height: 300px;
  }

  /* ルート履歴 */
  .route-history {
    max-height: 300px;
  }

  /* カード */
  .route-card, .route-item {
    font-size: 0.95rem;
  }

  .route-card .card-header {
    font-size: 0.95rem;
    flex-wrap: wrap;
  }

  /* 到着/出発時間表示 */
  .time-row {
    font-size: 0.85rem;
  }

  /* 矢印カード */
  .arrow-card {
    font-size: 0.8rem;
    padding: 6px 8px;
    white-space: normal;
  }

  .arrow-card select {
    font-size: 0.85rem;
  }

  /* 入力系は16px以上（iPhoneズーム防止） */
  input, select, textarea, button {
    font-size: 16px !important;
  }

  /* 滞在時間入力 */
  .stayTime {
    width: 80px;
  }

  /* モーダル内マップ */
  #candidateMap {
    height: 240px;
  }

  #candidateList {
    max-height: 180px;
  }

  /* モーダルの中も縦積み */
  .modal-body .row {
    flex-direction: column;
  }

  .modal-body .col-md-7,
  .modal-body .col-md-5 {
    width: 100%;
  }

  /* ボタンを押しやすく */
  .btn {
    padding: 12px 20px;
    font-size: 1rem;
  }

  .sidebar .btn {
    font-size: 1rem;
    padding: 14px;
  }

}
#spotCards {
  min-height: 200px;   /* ★ これが効く */
}

.modal-card img {
  width: 100%;
  height: 160px;        /* ← 固定 */
  object-fit: cover;   /* トリミング */
  border-radius: 12px;
}

</style>
</head>

<body>



<!-- コース情報表示（start.jspから渡された属性） -->
<div class="container mb-3">
<h3 class="text-center">日別ルート作成</h3>
  <div class="row">
    <div class="col-md-8">
      <div><strong>コース：</strong>
        <span id="courseTitle">
          <%= request.getAttribute("courseTitle") != null ? request.getAttribute("courseTitle") : "未設定" %>
        </span>
      </div>
      <div><strong>日数：</strong>
        <span id="tripDaysDisplay">
          <%= request.getAttribute("tripDays") != null ? request.getAttribute("tripDays") : 1 %>
        </span> 日
      </div>
      <div>
        <strong>開始地点：</strong>
        <span id="startPointDisplay">
          <%= request.getAttribute("startPoint") != null ? request.getAttribute("startPoint") : "山形駅" %>
        </span>
        <span id="startAddress" class="small-muted"></span>
      </div>
      <div><strong>開始時間：</strong>
        <span id="startTimeDisplay">
          <%= request.getAttribute("startTime") != null ? request.getAttribute("startTime") : "09:00" %>
        </span>
      </div>
    </div>
    <div class="col-md-4 text-end">
      <!-- PDF出力までつなげるボタン -->
      <button id="confirmRouteBtn" class="btn btn-danger">全ルート確定</button>
    </div>
  </div>
</div>

<!-- ルートセクション -->
<div id="routesContainer" class="container" style="margin-left:unset; margin-right:unset; padding-left:unset; padding-right:unset;"></div>

<!-- スポット選択モーダル -->
<div id="spotModal" class="modal fade" tabindex="-1" aria-hidden="true">
  <div class="modal-dialog modal-lg modal-dialog-scrollable">
    <div class="modal-content">
      <div class="modal-header">
        <h5 class="modal-title">スポット選択</h5>
        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="閉じる"></button>
      </div>

      <div class="modal-body">
        <!-- キーワード -->
        <div class="mb-2">
          <input type="text" id="keyword" placeholder="キーワード検索" class="form-control"/>
        </div>

        <!-- エリア & タグ：ドロップダウン複数選択（DB連動） -->
        <div class="mb-3 d-flex gap-2">
          <!-- エリア -->
          <div class="dropdown w-50">
            <button id="areaDropdownBtn" class="btn btn-outline-primary dropdown-toggle w-100" type="button" data-bs-toggle="dropdown">
              エリアを選択
            </button>
            <ul class="dropdown-menu p-2" id="areaDropdown" style="max-height:250px; overflow-y:auto;">
              <!-- JSで自動生成 -->
            </ul>
          </div>
          <!-- タグ -->
          <div class="dropdown w-50">
            <button id="tagDropdownBtn" class="btn btn-outline-success dropdown-toggle w-100" type="button" data-bs-toggle="dropdown">
              タグを選択
            </button>
            <ul class="dropdown-menu p-2" id="tagDropdown" style="max-height:250px; overflow-y:auto;">
              <!-- JSで自動生成 -->
            </ul>
          </div>
        </div>
		<div class="text-end mt-2">
 		 <button id="clearSpotFilterBtn"
        		  type="button"
        		  class="btn btn-outline-secondary btn-sm">
   							 検索条件クリア
  			</button>
		</div>

        <!-- お気に入り -->
        <div class="mb-2">
          <label><input type="checkbox" id="favOnlyCheck"/> お気に入りのみ</label>
        </div>

        <!-- カード一覧 -->
        <div class="row" id="spotCards"></div>
      </div>
		<div id="spotPagination" class="text-center my-3"></div>
      <div class="modal-footer">
        <button id="searchSpotBtn" class="btn btn-primary">検索</button>
        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">閉じる</button>
      </div>
    </div>
  </div>
</div>

<!-- ゴール住所入力モーダル -->
<div class="modal fade" id="goalModal" tabindex="-1">
  <div class="modal-dialog">
    <div class="modal-content">
      <div class="modal-header">
        <h5 class="modal-title">ゴール地点の住所を入力</h5>
        <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
      </div>
      <div class="modal-body">
        <input type="text" id="goalAddressInput" class="form-control"
               placeholder="例：山形県山形市香澄町1-1-1">
        <div class="small-muted mt-2">
          ※入力が曖昧な場合、候補が複数出るので地図上で選択できます。
        </div>
      </div>
      <div class="modal-footer">
        <button type="button" class="btn btn-secondary"
                data-bs-dismiss="modal">キャンセル</button>
        <button type="button" id="goalAddressSubmitBtn"
                class="btn btn-primary">検索</button>
      </div>
    </div>
  </div>
</div>

<!-- ★ 住所候補選択モーダル（地図にピン表示して選択） -->
<div class="modal fade" id="candidateModal" tabindex="-1" aria-hidden="true">
  <div class="modal-dialog modal-lg modal-dialog-scrollable">
    <div class="modal-content">
      <div class="modal-header">
        <h5 class="modal-title">住所候補を選択</h5>
        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="閉じる"></button>
      </div>
      <div class="modal-body">
        <div class="row g-3">
          <div class="col-md-7">
            <div id="candidateMap"></div>
            <div class="small-muted mt-2">
              ピン or 右の候補リストを選択して「この候補で決定」を押してください。
            </div>
          </div>
          <div class="col-md-5">
            <div id="candidateList"></div>
          </div>
        </div>
      </div>
      <div class="modal-footer">
        <div class="me-auto small-muted" id="candidateSelectedText">未選択</div>
        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">戻る</button>
        <button type="button" id="candidateConfirmBtn" class="btn btn-primary" disabled>この候補で決定</button>
      </div>
    </div>
  </div>
</div>

<!-- PDF 出力用 hidden form -->
<form id="pdfForm" method="post" action="<%= request.getContextPath() %>/PDFOutput" target="_blank">
  <input type="hidden" name="json" id="pdfJsonInput">
</form>

<!-- ライブラリ -->
<script src="https://code.jquery.com/jquery-3.7.0.min.js"></script>
<script src="https://unpkg.com/leaflet@1.9.4/dist/leaflet.js"></script>
<script src="https://unpkg.com/leaflet.markercluster/dist/leaflet.markercluster.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/jquery-cookie/1.4.1/jquery.cookie.min.js"></script>

<script>
/*
  統合版スクリプト
  - start.jsp からの値受け取り
  - Dayごとのマップ＋ルート履歴管理
  - お気に入り Cookie
  - CourseSpotSearch.action(listOnly / spots 検索)
  - ★ゴール住所検索：GSI（国土地理院）優先＋候補ピン選択
  - ★Dayごとの出発時刻入力
  - ★各スポットに到着/出発時間を表示
  - ★最終日のゴール確定後に上へスクロール
*/

/* ------------------------
   JSP -> JS への受け渡し
   ------------------------ */
let tripDays = <%= request.getAttribute("tripDays") != null ? request.getAttribute("tripDays") : 1 %>;
let courseTitle = '<%= request.getAttribute("courseTitle") != null ? request.getAttribute("courseTitle").toString().replace("'", "\\'") : "" %>';
let startPointRaw = '<%= request.getAttribute("startPoint") != null ? request.getAttribute("startPoint").toString().replace("'", "\\'") : "山形駅" %>';
let startAddressRaw = '<%= request.getAttribute("address") != null ? request.getAttribute("address").toString().replace("'", "\\'") : "" %>';
let startTime = '<%= request.getAttribute("startTime") != null ? request.getAttribute("startTime").toString().replace("'", "\\'") : "09:00" %>';
let allSpots = []; // モーダルで表示する全スポットを保持


applyHeaderToDom();

function applyHeaderToDom() {
  document.getElementById("courseTitle").textContent = courseTitle || "未設定";
  document.getElementById("tripDaysDisplay").textContent = tripDays || 1;
  document.getElementById("startPointDisplay").textContent = startPointRaw || "山形駅";
  document.getElementById("startTimeDisplay").textContent = startTime || "09:00";

  const addrEl = document.getElementById("startAddress");
  if (addrEl) {
    if (startAddressRaw && startPointRaw === "任意の地点") {
      addrEl.textContent = "（" + startAddressRaw + "）";
    } else {
      addrEl.textContent = "";
    }
  }
}

/* ------------------------
   固定の座標
   ------------------------ */
const FIXED_STARTS = {
  "山形駅":   { lat: 38.2485, lng: 140.3276 },
  "山形空港": { lat: 38.4116, lng: 140.3713 }
};

/* ------------------------
   グローバル状態
   ------------------------ */
let dayCount = 0;
let routesByDay = [];   // 日ごと: [{name,lat,lng,type,circle,stayTime,memo,transport,photoUrl,arriveTime,departTime}, ...]
let mapsByDay = [];     // 日ごと: { map, markers, routeLine }
let osrmLinesByDay = [];
let startTimesByDay = []; // ★追加：Dayごとの出発時刻（"HH:MM"）

/* 移動手段速度（km/h） */
const speedMap = { "徒歩":5, "車":40, "電車":70 };

/* ------------------------
   お気に入り（Cookie）
------------------------ */
function loadFavsFromCookie() {
  const match = document.cookie.match(/favoriteIds=([^;]+)/);
  if(!match) return [];
  return decodeURIComponent(match[1]).split(",").map(v => v.trim()).filter(v=>v);
}
function saveFavsToCookie(list) {
  const unique = Array.from(new Set(list.map(String)));
  document.cookie = "favoriteIds=" + encodeURIComponent(unique.join(",")) + "; path=/; max-age=" + (60*60*24*365);
}

/* ------------------------
   時刻ユーティリティ（★追加）
   ------------------------ */
function hhmmToMin(hhmm) {
  if (!hhmm || typeof hhmm !== "string") return 0;
  const m = hhmm.match(/^(\d{1,2}):(\d{2})$/);
  if (!m) return 0;
  const hh = Math.min(23, Math.max(0, parseInt(m[1], 10)));
  const mm = Math.min(59, Math.max(0, parseInt(m[2], 10)));
  return hh * 60 + mm;
}
function minToHhmm(min) {
  let m = Number(min);
  if (isNaN(m)) m = 0;
  // 1日超えは表示だけ 24h+ せずに丸め（必要ならここを拡張）
  m = ((m % (24*60)) + (24*60)) % (24*60);
  const hh = String(Math.floor(m / 60)).padStart(2, "0");
  const mm = String(Math.floor(m % 60)).padStart(2, "0");
  return hh + ":" + mm;
}

/* ------------------------
   Nominatim ジオコーディング（保険）
   ------------------------ */
function geocodeAddressNominatim(address) {
  return new Promise(function(resolve, reject) {
    if (!address || address.trim() === "") {
      reject("住所が空です");
      return;
    }
    const url = "https://nominatim.openstreetmap.org/search?format=json&q=" +
                encodeURIComponent(address);
    fetch(url, { method:"GET", headers:{ "Accept-Language":"ja" } })
      .then(res => res.json())
      .then(json => {
        if (Array.isArray(json) && json.length > 0) {
          const best = json[0];
          resolve({
            lat: parseFloat(best.lat),
            lng: parseFloat(best.lon),
            display_name: best.display_name
          });
        } else {
          reject("ジオコーディングで結果が見つかりませんでした");
        }
      })
      .catch(err => reject(err));
  });
}

/* ------------------------
   ★GSI（国土地理院）住所検索：日本向けで精度が高い
   - 複数候補を返す
   ------------------------ */
async function geocodeCandidatesGSI(address) {
  if (!address || !address.trim()) throw new Error("住所が空です");

  const url = "https://msearch.gsi.go.jp/address-search/AddressSearch?q=" + encodeURIComponent(address.trim());
  const res = await fetch(url);
  if (!res.ok) throw new Error("GSI住所検索に失敗しました");

  const data = await res.json();
  if (!Array.isArray(data) || data.length === 0) return [];

  const slice = data.slice(0, 10);
  return slice.map((d, idx) => {
    const lng = d?.geometry?.coordinates?.[0];
    const lat = d?.geometry?.coordinates?.[1];
    const title = d?.properties?.title || ("候補 " + (idx + 1));
    return {
      lat: Number(lat),
      lng: Number(lng),
      title: String(title),
      raw: d
    };
  }).filter(x => !isNaN(x.lat) && !isNaN(x.lng));
}

/* ------------------------
   Day セクション生成 & Leaflet 初期化
   ------------------------ */
function createDaySection(day, startLat, startLng, startName) {
  if (startLat === undefined) startLat = 38.2404;
  if (startLng === undefined) startLng = 140.3633;
  if (!startName) startName = "スタート";
  if (mapsByDay[day - 1]) {
	    return;
	  }
  dayCount = Math.max(dayCount, day);
  const sectionId = "daySection" + day;
  const mapId = "mapDay" + day;
  const sidebarId = "sidebarDay" + day;

  // ★Day出発時刻（day=1はstart.jspのstartTimeをデフォ、day>1は同じ値を仮置き→ユーザーが変更）
  const defaultStartTime = (startTimesByDay[day - 1] != null) ? startTimesByDay[day - 1]
                        : (day === 1 ? (startTime || "09:00") : (startTime || "09:00"));
  startTimesByDay[day - 1] = defaultStartTime;

  const html = `
    <div class="day-section" id="${sectionId}" style="width:100%">
      <h5>Day ${day}</h5>
      <div style="display:flex; width:100%;">
        <div id="${sidebarId}" class="sidebar card p-2" style="width:30%;">

          <!-- ★追加：Day出発時刻入力 -->
          <div class="day-starttime-box">
            <div class="label">Day${day} 出発時刻</div>
            <input type="time" class="dayStartTimeInput" data-day="${day}" value="${defaultStartTime}">
            <div class="small-muted mt-1">※この日のスタート地点を出発する時刻</div>
          </div>

          <div class="route-history mt-3" id="routeHistoryDay${day}"></div>

          <button class="btn btn-primary w-100 mb-2 nextSpotBtn">次の地点へ</button>
          <button class="btn btn-warning w-100 mb-2 addMealBtn">食事スポット追加</button>
          <button class="btn btn-success w-100 mb-2 setGoalBtn">ゴール設定</button>
        </div>
        <div id="${mapId}" class="map-container card"></div>
      </div>
    </div>
  `;
  $("#routesContainer").append(html);

  const map = L.map(mapId).setView([startLat, startLng], 13);
  L.tileLayer("https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png", {
    attribution:"&copy; OpenStreetMap contributors"
  }).addTo(map);

  const markers = L.markerClusterGroup();
  markers.addTo(map);

  mapsByDay[day - 1] = { map, markers, routeLine: null };
  routesByDay[day - 1] = [];
  osrmLinesByDay[day - 1] = null;

  setTimeout(() => {
    try { map.invalidateSize(); } catch(e) { console.error(e); }
  }, 200);

  // スタート地点を履歴に追加
  addRouteHistory(day - 1, startName, startLat, startLng, "start", null, null);
}

/* ------------------------
   マップ関連
   ------------------------ */
   function addMarker(dayIndex, name, lat, lng, type) {
	   if (type === undefined) type = "normal";

	   const mapObj = mapsByDay[dayIndex];
	   if (!mapObj || !mapObj.markers) return null;

	   let iconUrl;
	   if (type === "start") iconUrl = "https://cdn-icons-png.flaticon.com/512/25/25694.png";
	   else if (type === "goal") iconUrl = "https://cdn-icons-png.flaticon.com/128/2164/2164609.png";
	   else if (type === "meal") iconUrl = "https://cdn-icons-png.flaticon.com/512/3075/3075977.png";
	   else iconUrl = "https://cdn-icons-png.flaticon.com/512/252/252025.png";

	   const icon = L.icon({
	     iconUrl,
	     iconSize: [32, 32],
	     iconAnchor: [16, 32]
	   });

	   const marker = L.marker([lat, lng], {
	     icon,
	     _markerType: type
	   }).bindPopup("<strong>" + escapeHtml(name) + "</strong>");

	   mapObj.markers.addLayer(marker);
	   updateEstimatedTime(dayIndex);

	   return marker;
	 }

async function redrawRouteLine(dayIndex) {
  const mapObj = mapsByDay[dayIndex];
  if (!mapObj || !mapObj.map) return;

  const route = routesByDay[dayIndex];
  if (!Array.isArray(route) || route.length < 2) return;

  if (osrmLinesByDay[dayIndex]) {
    mapObj.map.removeLayer(osrmLinesByDay[dayIndex]);
    osrmLinesByDay[dayIndex] = null;
  }

  const coords = route.map(r => r.lng + "," + r.lat).join(";");

  const url =
    "https://router.project-osrm.org/route/v1/driving/" +
    coords +
    "?overview=full&geometries=geojson";

  const res = await fetch(url);
  const data = await res.json();
  if (!data.routes || !data.routes.length) return;

  osrmLinesByDay[dayIndex] = L.geoJSON(
    data.routes[0].geometry,
    { style: { weight: 4 } }
  ).addTo(mapObj.map);
}

function calcDistance(lat1, lng1, lat2, lng2) {
  const R = 6371;
  const dLat = (lat2 - lat1) * Math.PI / 180;
  const dLng = (lng2 - lng1) * Math.PI / 180;
  const a =
    Math.sin(dLat / 2) * Math.sin(dLat / 2) +
    Math.cos(lat1 * Math.PI / 180) *
    Math.cos(lat2 * Math.PI / 180) *
    Math.sin(dLng / 2) * Math.sin(dLng / 2);
  const c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1 - a));
  return R * c;
}

/* ------------------------
   ★到着/出発時刻の計算（追加）
   - transportは「その地点に来る移動手段」として既存仕様に合わせる
   ------------------------ */
 function computeTimeline(dayIndex) {
  const list = routesByDay[dayIndex] || [];
  if (list.length === 0) return;
  const startHHMM = startTimesByDay[dayIndex] || (startTime || "09:00");
  let t = hhmmToMin(startHHMM);

  for (let i = 0; i < list.length; i++) {
    const curr = list[i];
    const prev = i > 0 ? list[i - 1] : null;

    if (!prev) {
      // スタート地点
      const stay0 = (curr.stayTime != null) ? Number(curr.stayTime) : 0;
      curr.arriveTime = minToHhmm(t);
      t += (isNaN(stay0) ? 0 : stay0);
      curr.departTime = minToHhmm(t);
      continue;
    }

    // 移動時間計算
    let dist = calcDistance(prev.lat, prev.lng, curr.lat, curr.lng);
    const transport = curr.transport || "徒歩";

    // ★ 電車区間は距離を1.3倍補正（曲がりくねった線路を考慮）
    if (transport === "電車") {
      dist *= 1.3;  // ← これで直線より長い距離として計算
    }

    const speed = speedMap[transport] || 5;
    const travelMin = Math.round(dist / speed * 60);

    // ★ 電車区間には最低10分の乗り換え・駅間徒歩を追加
    let extraMin = 0;
    if (transport === "電車") {
      extraMin = 10 + Math.round(dist * 0.5);  // 距離に応じて追加（駅間移動）
    }

    t += travelMin + extraMin;
    curr.arriveTime = minToHhmm(t);

    if (curr.type === "goal") {
      curr.departTime = "";
      continue;
    }

    const stay = (curr.stayTime != null) ? Number(curr.stayTime) : 0;
    t += (isNaN(stay) ? 0 : stay);
    curr.departTime = minToHhmm(t);
  }
}


function updateEstimatedTime(dayIndex) {
  const route = routesByDay[dayIndex] || [];
  const sectionSelector = "#daySection" + (dayIndex + 1);

  if (route.length < 2) {
    $(sectionSelector + " .estimatedTime").text(0);
    return;
  }

  let totalMin = 0;
  for (let i = 1; i < route.length; i++) {
    const prev = route[i - 1];
    const curr = route[i];
    const dist = calcDistance(prev.lat, prev.lng, curr.lat, curr.lng);

    const arrowCard = $(sectionSelector).find(`.arrow-card[data-index="${i}"]`);
    let transport = "徒歩";
    if (arrowCard.length > 0) {
      transport = arrowCard.find(".transportSelect").val() || "徒歩";
    } else {
      transport = "徒歩";
    }

    const speed = speedMap[transport] || 5;
    totalMin += dist / speed * 60;
    const stayVal = parseInt(
      $(sectionSelector).find(`.route-item[data-index="${i}"] .stayTime`).val() ||
      $(sectionSelector).find(`.route-item[data-index="${i}"] .stayTimeInput`).val(),
      10
    );
    totalMin += isNaN(stayVal) ? 0 : stayVal;
  }

  $(sectionSelector).find(".totalEstimatedTimeDisplay").text(Math.round(totalMin));
}

/* ------------------------
   履歴（ルート）管理
   ------------------------ */
function addRouteHistory(dayIndex, name, lat, lng, type, existingCircle, photoUrl, stayTimeOpt, memoOpt, transportOpt) {
  if (type === undefined) type = "normal";
  routesByDay[dayIndex] = routesByDay[dayIndex] || [];

  let circle = existingCircle;
  if (type === "meal" && !circle) {
    circle = L.circle([lat, lng], {
      color:"orange",
      fillColor:"#ffa500",
      fillOpacity:0.2,
      radius:1000
    }).addTo(mapsByDay[dayIndex].map);
  }

  const defaultStay = (type === "start" || type === "goal") ? 0 : 30;

  routesByDay[dayIndex].push({
    name,
    lat,
    lng,
    type,
    circle,
    stayTime: (stayTimeOpt != null && stayTimeOpt !== "") ? Number(stayTimeOpt) : defaultStay,
    memo: (memoOpt != null) ? String(memoOpt) : "",
    transport: (transportOpt != null && transportOpt !== "") ? String(transportOpt) : "徒歩",
    photoUrl: photoUrl || null,
    arriveTime: "",
    departTime: ""
  });

  renderRouteHistory(dayIndex);
  addMarker(dayIndex, name, lat, lng, type);
  saveRoutesToLocal();
}

function renderRouteHistory(dayIndex) {
  const list = routesByDay[dayIndex] || [];
  const container = $(`#routeHistoryDay${dayIndex+1}`);
  container.empty();

  // ★到着/出発計算（レンダリング前）
  computeTimeline(dayIndex);

  for (let i = 0; i < list.length; i++) {
    const item = list[i];
    const prev = i > 0 ? list[i-1] : null;

    if (prev) {
    	  const dist = calcDistance(prev.lat, prev.lng, item.lat, item.lng).toFixed(1);
    	  const transport = item.transport || "徒歩";
    	  const speed = speedMap[transport] || 5;
    	  const timeMin = Math.round(dist / speed * 60);

    	  let note = "";
    	  if (transport === "電車") {
    	    note = '<span class="small-muted" style="color:#e74c3c; margin-left:10px;">※電車ルートは簡易表示・計算です</span>';
    	  }

    	  const arrowHtml = $(`
    	    <div class="arrow-card small-muted" data-index="${i}">
    	      移動手段:
    	      <select class="form-select form-select-sm transportSelect" data-index="${i}" style="width:100px; display:inline-block;">
    	        <option ${transport === "徒歩" ? "selected" : ""}>徒歩</option>
    	        <option ${transport === "車" ? "selected" : ""}>車</option>
    	        <option ${transport === "電車" ? "selected" : ""}>電車</option>
    	      </select>
    	      予測時間: <span class="estimatedTime">${timeMin}</span>分 / 概算距離: ${dist}km
    	      ${note}
    	    </div>
    	  `);
    	  container.append(arrowHtml);
    	}

    const stayTime = item.stayTime != null ? item.stayTime : 30;
    const memo = item.memo || "";
    const arrive = item.arriveTime || "";
    const depart = item.departTime || "";

    const timeRowHtml = `
      <div class="time-row">
        <b>到着</b>: <span class="arriveLabel">${arrive || "--:--"}</span>
        <span style="margin:0 8px;">/</span>
        <b>出発</b>: <span class="departLabel">${depart || (item.type === "goal" ? "--:--" : "--:--")}</span>
      </div>
    `;

    let title = escapeHtml(item.name);
	let typeLabel = "";

if (item.type === "start") {
  typeLabel = "(スタート地点)";
  if (item.needsReconfirm) {
    title = "⚠ " + title;
    typeLabel = "(再確認が必要)";
  }
} else if (item.type === "goal") {
  typeLabel = "(ゴール地点)";
}

    const cardHtml = $(`
      <div class="route-card route-item" data-index="${i}">
      <div class="card-header">
      [${title}] ${typeLabel}
      <button class="btn btn-sm btn-danger removeBtn">×</button>
    </div>

        <div class="card-body">
          ${timeRowHtml}
          <div class="mt-2">滞在時間:
            <input type="number" class="stayTime" value="${stayTime}" data-index="${i}" style="width:60px"/> 分
          </div>
          <div>メモ:
            <input type="text" class="memoInput form-control form-control-sm"
                   value="${escapeHtml(memo)}" data-index="${i}"  maxlength="200"/>
          </div>
        </div>
      </div>
    `);
    container.append(cardHtml);
  }

  container.find(".removeBtn").off("click").on("click", function () {
	  const $item = $(this).closest(".route-item");
	  const index = $item.data("index");
	  const target = routesByDay[dayIndex][index];

	  // 1日目スタート特例
	  if (dayIndex === 0 && target.type === "start") {
	    if (confirm("スタート地点を変更しますか？\n「OK」でスタート地点選択画面に戻ります。")) {
	      window.location.href = "start.jsp";
	    }
	    return;
	  }

	  // ★ start 削除時（既存仕様：前日のゴール＋以降の日を削除）
	  if (target.type === "start") {
	    if (confirm("この日のスタート地点を削除すると、前日のゴールとこの日以降のルートも削除されます。よろしいですか？")) {
	      const prevDayIndex = dayIndex - 1;
	      const prevRoutes = routesByDay[prevDayIndex] || [];
	      const goalIndex = prevRoutes.findIndex(r => r.type === "goal");
	      if (goalIndex >= 0) removeRoute(prevDayIndex, goalIndex);

	      for (let d = dayCount - 1; d >= dayIndex; d--) {
	        const sectionId = "#daySection" + (d + 1);
	        $(sectionId).remove();
	        routesByDay[d] = [];
	        mapsByDay[d] = null;
	        startTimesByDay[d] = null;
	      }
	      dayCount = dayIndex;
	    }
	    return;
	  }

	  // ★ goal 削除時（新仕様：翌日の start を再確認状態に）
	  if (target.type === "goal") {
	    removeRoute(dayIndex, index);
	    markNextDayStartNeedsReconfirm(dayIndex);
	    return;
	  }

	  // その他（通常スポット）
	  removeRoute(dayIndex, index);
	});


  container.find(".transportSelect").off("change").on("change", function () {
    const idx = $(this).data("index");
    const val = $(this).val();
    const list = routesByDay[dayIndex] || [];

    if (list[idx]) {
      list[idx].transport = val;
    }

    updateEstimatedTime(dayIndex);
    redrawRouteLine(dayIndex);
    saveRoutesToLocal();

    // ★時間再計算して反映
    computeTimeline(dayIndex);
    renderRouteHistory(dayIndex);
  });

  container.find(".stayTime").off("change").on("change", function(){
	  const idx = $(this).data("index");
	  const val = parseInt($(this).val(), 10);
	  const list = routesByDay[dayIndex] || [];
	  if (!isNaN(val) && list[idx]) {
	    list[idx].stayTime = val;

	    // ★時間再計算 & 再描画（スタート含め反映）
	    computeTimeline(dayIndex);
	    renderRouteHistory(dayIndex);

	    // 保存
	    saveRoutesToLocal();
	  }
	});


  container.find(".memoInput").off("input").on("input", function(){
    const idx = $(this).data("index");
    const list = routesByDay[dayIndex] || [];
    if (list[idx]) {
      list[idx].memo = $(this).val();
      saveRoutesToLocal();
    }
  });

  const arrowCards = container.find(".arrow-card");
  arrowCards.each(function(){
    const parentWidth = $(this).parent().width();
    const contentWidth = this.scrollWidth;
    let scale = 1;
    if (contentWidth > parentWidth) {
      scale = parentWidth / contentWidth;
    }
    $(this).css({
      transform:`scale(${scale})`,
      "transform-origin":"left center"
    });
  });
}

function removeRoute(dayIndex, index) {
  const mapObj = mapsByDay[dayIndex];
  if (!mapObj || !routesByDay[dayIndex]) return;

  const target = routesByDay[dayIndex][index];

  if (target && target.circle) {
    mapObj.map.removeLayer(target.circle);
  }

  routesByDay[dayIndex].splice(index, 1);

  if (osrmLinesByDay[dayIndex]) {
    mapObj.map.removeLayer(osrmLinesByDay[dayIndex]);
    osrmLinesByDay[dayIndex] = null;
  }

  mapObj.markers.clearLayers();

  const snapshot = [...routesByDay[dayIndex]];
  routesByDay[dayIndex] = [];

  snapshot.forEach(r => {
    addRouteHistory(
      dayIndex,
      r.name,
      r.lat,
      r.lng,
      r.type,
      r.circle || null,
      r.photoUrl || null,
      r.stayTime,
      r.memo,
      r.transport
    );
  });

  renderRouteHistory(dayIndex);

  if (routesByDay[dayIndex].length >= 2) {
    redrawRouteLine(dayIndex);
  }

  saveRoutesToLocal();
}

/* ------------------------
   エリア・タグ（DB連動）＋スポット検索
   ------------------------ */
 function populateAreaAndTagSelects(areaContainerId, tagContainerId) {
  $.ajax({
    url: "CourseSpotSearch.action",
    type: "POST",
    data: { listOnly: "true" },
    dataType: "json",
    success: function(data) {
      const areas = data.areas || [];
      const tags  = data.tags  || [];

      const $areaContainer = $("#" + areaContainerId);
      $areaContainer.empty();
      areas.forEach(function(a, index){
        const areaName = (typeof a === "string") ? a : (a.areaName || a.name);
        const safeName = (areaName || "").replace(/"/g, '\\"');
        const id = "areaChk_" + areaContainerId + "_" + index;
        $areaContainer.append(`
          <li>
            <label class="dropdown-item" for="${id}">
              <input type="checkbox" id="${id}" class="form-check-input me-2 area-check" value="${safeName}">
              ${safeName}
            </label>
          </li>
        `);
      });

      const $tagContainer = $("#" + tagContainerId);
      $tagContainer.empty();
      tags.forEach(function(t, index){
        const tagName = t.name || t.tagName || "";
        const safeName = tagName.replace(/"/g, '\\"');
        const id = "tagChk_" + tagContainerId + "_" + index;
        $tagContainer.append(`
          <li>
            <label class="dropdown-item" for="${id}">
              <input type="checkbox" id="${id}" class="form-check-input me-2 tag-check" value="${safeName}">
              ${safeName}
            </label>
          </li>
        `);
      });
    },
  });
}


 function searchSpots(keyword, areas, tags, favOnly) {
	  $.ajax({
	    url: "CourseSpotSearch.action",
	    type: "POST",
	    data: {
	      keyword: keyword,
	      areaIds: areas,
	      tagIds: tags
	    },
	    traditional: true,
	    dataType: "json",
	    success: function(data) {
	      allSpots = data.spots || [];

	      updateSpotCards({
	        favOnly: $("#favOnlyCheck").prop("checked"),
	        keepPage: false
	      });
	    }
	  });
	}


$(document).on("click", "#searchSpotBtn", function() {
  const keyword = $("#keyword").val() || "";
  const areas = $("#areaDropdown input:checked").map(function(){ return $(this).val(); }).get();
  const tags  = $("#tagDropdown input:checked").map(function(){ return $(this).val(); }).get();
  const favOnly = $("#favOnlyCheck").prop("checked");
  searchSpots(keyword, areas, tags, favOnly, "#spotCards");
});

/* =========================
ページネーション設定
========================= */
const SPOTS_PER_PAGE = 12;
let currentSpotPage = 1;
let filteredSpots = [];

/* =========================
renderSpotCards（差し替え版）
========================= */
function renderSpotCards(spots) {

	filteredSpots = spots;
const $spotCards = $("#spotCards");
const $pagination = $("#spotPagination");

$spotCards.empty();
$pagination.empty();

if (!spots || spots.length === 0) {
 $spotCards.append(`
   <div class="col-12 text-center text-muted py-4">
     該当するスポットがありません
   </div>
 `);
 return;
}

const favs = loadFavsFromCookie().map(String);
const contextPath = "<%= request.getContextPath() %>";

const totalPages = Math.ceil(spots.length / SPOTS_PER_PAGE);
if (currentSpotPage > totalPages) {
	  currentSpotPage = totalPages;
	}

const start = (currentSpotPage - 1) * SPOTS_PER_PAGE;
const end   = start + SPOTS_PER_PAGE;
const pageSpots = spots.slice(start, end);

/* ===== カード描画 ===== */
pageSpots.forEach(function (s) {

 const spotIdStr = String(s.spotId);
 const isFav = favs.includes(spotIdStr) || s.fav === true;
 const favClass = isFav ? "active" : "";

 const imgUrl = s.spotPhoto
   ? contextPath + s.spotPhoto
   : contextPath + "/images/placeholder.jpg";

 s.fullPhotoUrl = imgUrl;

 const card = $(`
   <div class="col-md-4">
     <div class="modal-card" data-id="${spotIdStr}">
       <img src="${imgUrl}" loading="lazy"
            class="img-fluid mb-2"
            alt="${escapeHtml(s.spotName)}"/>

       <div class="spot-title-row">
         <h6 class="mb-0 spot-title">${escapeHtml(s.spotName)}</h6>
         <span class="favorite ${favClass}" data-id="${spotIdStr}">★</span>
       </div>

       <div class="small-muted">${escapeHtml(s.area || "")}</div>
     </div>
   </div>
 `);

 /* ===== クリック処理（既存そのまま） ===== */
 card.find(".modal-card").on("click", function (e) {
   if ($(e.target).hasClass("favorite")) return;

   selectSpot(
     s.spotId,
     s.spotName,
     parseFloat(s.lat),
     parseFloat(s.lng),
     s.fullPhotoUrl || null
   );
 });

 card.find(".favorite").on("click", function (e) {
   e.stopPropagation();
   toggleFavCookie($(this).data("id"), this);
 });

 $spotCards.append(card);
});

/* ===== ページネーション ===== */
if (totalPages <= 1) return;

const ul = $('<ul class="pagination justify-content-center"></ul>');

// Prev
ul.append(`
 <li class="page-item ${currentSpotPage === 1 ? 'disabled' : ''}">
   <a class="page-link" href="#" data-page="${currentSpotPage - 1}">«</a>
 </li>
`);

const maxVisible = 5;
let startPage = Math.max(1, currentSpotPage - 2);
let endPage = Math.min(totalPages, startPage + maxVisible - 1);
startPage = Math.max(1, endPage - maxVisible + 1);

for (let i = startPage; i <= endPage; i++) {
  ul.append(`
    <li class="page-item ${i === currentSpotPage ? 'active' : ''}">
      <a class="page-link" href="#" data-page="${i}">${i}</a>
    </li>
  `);
}


// Next
ul.append(`
 <li class="page-item ${currentSpotPage === totalPages ? 'disabled' : ''}">
   <a class="page-link" href="#" data-page="${currentSpotPage + 1}">»</a>
 </li>
`);

$pagination.append(ul);
}

/* =========================
ページ番号クリック
========================= */
$(document).on("click", "#spotPagination .page-link", function (e) {
	  e.preventDefault();

	  const page = Number($(this).data("page"));
	  const totalPages = Math.ceil(filteredSpots.length / SPOTS_PER_PAGE);

	  if (
	    !Number.isInteger(page) ||
	    page < 1 ||
	    page > totalPages ||
	    page === currentSpotPage
	  ) {
	    return;
	  }

	  currentSpotPage = page;
	  renderSpotCards(filteredSpots);
	});

/* スポット選択 */
function selectSpot(id, name, lat, lng, photoUrl) {
  const dayIndex = dayCount - 1;
  addRouteHistory(dayIndex, name, lat, lng, "normal", null, photoUrl);
  redrawRouteLine(dayIndex);
  const modalEl = document.getElementById("spotModal");
  const modal = bootstrap.Modal.getInstance(modalEl) || new bootstrap.Modal(modalEl);
  modal.hide();
}

/* お気に入り切替 */
function toggleFavCookie(spotId, elem) {
  let favs = loadFavsFromCookie().map(String);
  const idStr = String(spotId);

  if (favs.includes(idStr)) {
    favs = favs.filter(x => x !== idStr);
    elem.classList.remove("active");
  } else {
    favs.push(idStr);
    elem.classList.add("active");
  }

  saveFavsToCookie(favs);

  if ($("#favOnlyCheck").prop("checked")) {
	  updateSpotCards({
		  favOnly: true,
		  keepPage: true
		});

  }
}

function updateSpotCards(options = {}) {
	  const favOnly = options.favOnly ?? false;
	  const keepPage = options.keepPage ?? false;

	  let list = allSpots;

	  if (favOnly) {
	    const favs = loadFavsFromCookie().map(String);
	    list = list.filter(s =>
	      favs.includes(String(s.spotId)) || s.fav === true
	    );
	  }

	  filteredSpots = list;

	  if (!keepPage) {
	    currentSpotPage = 1;
	  }

	  renderSpotCards(filteredSpots);
	}

function updateAreaTagButtonText() {

	  // エリア
	  const areaCount = $("#areaDropdown input[type=checkbox]:checked").length;
	  $("#areaDropdownBtn").text(
	    areaCount > 0 ? `エリア（${areaCount}件選択中）` : "エリアを選択"
	  );

	  // タグ
	  const tagCount = $("#tagDropdown input[type=checkbox]:checked").length;
	  $("#tagDropdownBtn").text(
	    tagCount > 0 ? `タグ（${tagCount}件選択中）` : "タグを選択"
	  );
	}

$(document).on("change",
		  "#areaDropdown input[type=checkbox], #tagDropdown input[type=checkbox]",
		  function () {
		    updateAreaTagButtonText();
		  }
		);


/* ------------------------
   イベントハンドラ（その他）
   ------------------------ */
$(document).on("click", ".nextSpotBtn", function(){
  const modalEl = document.getElementById("spotModal");
  const modal = new bootstrap.Modal(modalEl);
  modal.show();
});

// ★Day出発時刻変更
$(document).on("change", ".dayStartTimeInput", function(){
  const day = parseInt($(this).data("day"), 10); // 1-based
  const val = $(this).val() || "09:00";
  if (!isNaN(day) && day >= 1) {
    startTimesByDay[day - 1] = val;
    saveRoutesToLocal();

    // その日の表示更新
    const dayIndex = day - 1;
    computeTimeline(dayIndex);
    renderRouteHistory(dayIndex);
  }
});

$(document).on("click", ".addMealBtn", function(){
  const daySection = $(this).closest(".day-section");
  const dayIndex = $(".day-section").index(daySection);
  if (!mapsByDay[dayIndex]) return;

  alert("マップ上をクリックして食事スポットを追加してください");

  const map = mapsByDay[dayIndex].map;

  function onMapClick(e) {
    const lat = e.latlng.lat;
    const lng = e.latlng.lng;

    const circle = L.circle([lat, lng], {
      color:"orange",
      fillColor:"#ffa500",
      fillOpacity:0.2,
      radius:1000
    }).addTo(map);

    addRouteHistory(dayIndex, "食事スポット", lat, lng, "meal", circle, null);
    if (routesByDay[dayIndex].length >= 2) {
      redrawRouteLine(dayIndex);
    }

    map.off("click", onMapClick);
  }

  map.on("click", onMapClick);
});

/* ゴール設定ボタン */
$(document).on("click", ".setGoalBtn", function(){
  const daySection = $(this).closest(".day-section");
  const dayIndex = $(".day-section").index(daySection);
  window.currentGoalDayIndex = dayIndex;

  const modalEl = document.getElementById("goalModal");
  const modal = new bootstrap.Modal(modalEl);
  modal.show();
});

$(document).on("click", "#clearSpotFilterBtn", function () {

	  // ① 入力をクリア
	  $("#keyword").val("");

	  // ② チェックを全解除
	  $("#areaDropdown input[type=checkbox]").prop("checked", false);
	  $("#tagDropdown input[type=checkbox]").prop("checked", false);
	  $("#favOnlyCheck").prop("checked", false);


	  updateAreaTagButtonText();
	  // ③ 状態を初期化
	  filteredSpots = allSpots;
	  currentSpotPage = 1;

	  // ④ 再描画
	  searchSpots("", [], [], false);
	});

/* 日本住所 → 検索向けに整形（簡易） */
function normalizeAddress(addr) {
  if (!addr) return addr;
  let a = addr.trim();

  a = a.replace(/[０-９]/g, function(s){
    return String.fromCharCode(s.charCodeAt(0) - 65248);
  });
  a = a.replace(/[ー－―]/g, "-");
  a = a.replace(/(\d+)丁目/g, "$1 Chome ");
  a = a.replace(/([^\d])(\d+-\d+-?\d*)/, "$1 $2");

  return a;
}

/* ------------------------
   ★ 住所候補選択：地図にピンを立てて選ぶ
   ------------------------ */
let candidateMap = null;
let candidateLayer = null;
let candidateMarkers = [];
let candidateSelected = null;
let candidateData = [];

function initCandidateMapIfNeeded() {
  const mapDiv = document.getElementById("candidateMap");
  if (!mapDiv) return;

  if (!candidateMap) {
    candidateMap = L.map("candidateMap", {
      zoomAnimation: false,
      fadeAnimation: false,
      markerZoomAnimation: false,
      inertia: false,
      preferCanvas: true
    }).setView([38.2485, 140.3276], 12);

    L.tileLayer("https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png", {
      attribution:"&copy; OpenStreetMap contributors"
    }).addTo(candidateMap);

    candidateLayer = L.layerGroup().addTo(candidateMap);
  }
}

function clearCandidateUI() {
  candidateSelected = null;
  candidateData = [];
  candidateMarkers = [];
  $("#candidateList").empty();
  $("#candidateSelectedText").text("未選択");
  $("#candidateConfirmBtn").prop("disabled", true);
  if (candidateLayer) candidateLayer.clearLayers();
}

function setCandidateSelected(idx) {
  candidateSelected = candidateData[idx] || null;
  $("#candidateList .candidate-item").removeClass("active");
  $("#candidateList .candidate-item[data-idx='" + idx + "']").addClass("active");

  if (candidateSelected) {
    $("#candidateSelectedText").text(candidateSelected.title);
    $("#candidateConfirmBtn").prop("disabled", false);
  } else {
    $("#candidateSelectedText").text("未選択");
    $("#candidateConfirmBtn").prop("disabled", true);
  }
}

function showCandidatesOnMap(list) {
  initCandidateMapIfNeeded();
  clearCandidateUI();

  candidateData = (list || []).slice(0);

  if (!candidateMap || !candidateLayer || candidateData.length === 0) return;

  const bounds = [];

  candidateData.forEach((c, idx) => {
    const lat = c.lat;
    const lng = c.lng;
    bounds.push([lat, lng]);

    const m = L.marker([lat, lng]).addTo(candidateLayer);
    m.bindPopup("<strong>候補 " + (idx + 1) + "</strong><br>" + escapeHtml(c.title));
    m.on("click", function(){
      setCandidateSelected(idx);
      try { m.openPopup(); } catch(e) {}
    });
    candidateMarkers.push(m);

    const item = $(`
      <div class="candidate-item" data-idx="${idx}">
        <div><strong>候補 ${idx + 1}</strong></div>
        <div class="small-muted">${escapeHtml(c.title)}</div>
        <div class="small-muted">緯度:${lat.toFixed(5)} / 経度:${lng.toFixed(5)}</div>
      </div>
    `);
    item.on("click", function(){
      setCandidateSelected(idx);
      candidateMap.setView([lat, lng], 16);
      try { candidateMarkers[idx].openPopup(); } catch(e) {}
    });
    $("#candidateList").append(item);
  });

  setTimeout(function(){
    try { candidateMap.invalidateSize(true); } catch(e) {}
    try {
      candidateMap.fitBounds(bounds, { padding: [20, 20] });
    } catch(e) {
      candidateMap.setView(bounds[0], 15);
    }
  }, 200);
}

// ゴール確定（選ばれた lat/lng/title をここに集約）
function applyGoalSelection(dayIndex, lat, lng, titleLabel) {
  const list = routesByDay[dayIndex] || [];

  // 既存ゴールがあれば確認
  const hasGoal = list.some(r => r.type === "goal");
  if (hasGoal) {
    const ok = confirm(`Day${dayIndex + 1} のゴールを上書きしますか？`);
    if (!ok) return;

 // 既存ゴール削除
    removeExistingGoal(dayIndex);

    // ★ 翌日の start マーカーを全削除
    removeAllStartMarkers(dayIndex);

    // ★ 翌日の start 再設定
    updateNextDayStart(dayIndex, lat, lng, titleLabel);

  }

  const formattedAddress = titleLabel || "ゴール地点";

  // ゴール追加
  addRouteHistory(dayIndex, formattedAddress, lat, lng, "goal", null, null);

  if (routesByDay[dayIndex].length >= 2) {
    redrawRouteLine(dayIndex);
  }

  if (mapsByDay[dayIndex]?.map) {
    mapsByDay[dayIndex].map.setView([lat, lng], 14);
  }

  // 翌日のスタートを更新
  updateNextDayStart(dayIndex, lat, lng, formattedAddress);

  // 次の日生成（従来通り）
  if (dayCount < tripDays) {
    createDaySection(dayCount + 1, lat, lng, formattedAddress);

    const nextDaySection = document.getElementById(
      "daySection" + dayCount
    );
    if (nextDaySection) {
      nextDaySection.scrollIntoView({ behavior: "smooth", block: "start" });
    }
  } else {
    window.scrollTo({ top: 0, behavior: "smooth" });
  }

  saveRoutesToLocal();
}



/* ------------------------
   ゴール住所決定：GSIで候補取得→複数なら地図選択
   ------------------------ */
$("#goalAddressSubmitBtn").on("click", async function(){
  const address = $("#goalAddressInput").val().trim();

  if (!address) {
    alert("住所を入力してください");
    return;
  }

  const dayIndex = window.currentGoalDayIndex;
  if (dayIndex == null) return;

  const goalModalEl = document.getElementById("goalModal");
  const goalModal = bootstrap.Modal.getInstance(goalModalEl);
  if (goalModal) goalModal.hide();

  try {
    const normalized = normalizeAddress(address);

    let candidates = await geocodeCandidatesGSI(normalized);

    if (!candidates || candidates.length === 0) {
      const nomi = await geocodeAddressNominatim(normalized);
      if (!nomi || nomi.lat == null || nomi.lng == null) {
        alert("住所が見つかりませんでした。入力を確認してください。");
        return;
      }
      applyGoalSelection(dayIndex, parseFloat(nomi.lat), parseFloat(nomi.lng), nomi.display_name || address);
      return;
    }

    if (candidates.length === 1) {
      const c = candidates[0];
      applyGoalSelection(dayIndex, c.lat, c.lng, c.title || address);
      return;
    }

    showCandidatesOnMap(candidates);

    const candModalEl = document.getElementById("candidateModal");
    const candModal = new bootstrap.Modal(candModalEl);
    candModal.show();

    setTimeout(function(){
      setCandidateSelected(0);
      try {
        candidateMap.setView([candidates[0].lat, candidates[0].lng], 16);
        candidateMarkers[0].openPopup();
      } catch(e) {}
    }, 300);

    $("#candidateConfirmBtn").off("click").on("click", function(){
      if (!candidateSelected) {
        alert("候補を選択してください。");
        return;
      }
      const lat = parseFloat(candidateSelected.lat);
      const lng = parseFloat(candidateSelected.lng);
      const label = candidateSelected.title || address;

      const inst = bootstrap.Modal.getInstance(candModalEl);
      if (inst) inst.hide();

      applyGoalSelection(dayIndex, lat, lng, label);
    });

    candModalEl.addEventListener("hidden.bs.modal", function handler(){
      if (!candidateSelected) {
        try {
          const gm = new bootstrap.Modal(goalModalEl);
          gm.show();
        } catch(e) {}
      }
      candModalEl.removeEventListener("hidden.bs.modal", handler);
    });

  } catch(err) {
    console.error("ゴール検索エラー:", err);
    alert("住所の検索中にエラーが発生しました。");
    try {
      const gm = new bootstrap.Modal(document.getElementById("goalModal"));
      gm.show();
    } catch(e) {}
  }
});

/* ------------------------
   PDF 出力：routesByDay → JSON
   ------------------------ */
function syncRoutesFromDOM() {
  $(".day-section").each(function(dayIdx){
    const $section = $(this);
    const list = routesByDay[dayIdx] || [];

    // Day出発時刻も同期
    const t = $section.find(".dayStartTimeInput").val();
    if (t) startTimesByDay[dayIdx] = t;

    $section.find(".route-item").each(function(){
      const idx = $(this).data("index");
      if (list[idx]) {
        const stayVal = parseInt($(this).find(".stayTime").val() ||
                                 $(this).find(".stayTimeInput").val(), 10);
        const memoVal = $(this).find(".memoInput").val() || "";

        const arrowCard = $section.find(`.arrow-card[data-index="${idx}"]`);
        let transportVal = list[idx].transport || "徒歩";
        if (arrowCard.length > 0) {
          transportVal = arrowCard.find(".transportSelect").val() || transportVal;
        }

        list[idx].stayTime = isNaN(stayVal) ? 0 : stayVal;
        list[idx].memo = memoVal;
        list[idx].transport = transportVal;
      }
    });
  });

  // 時刻計算
  for (let d = 0; d < dayCount; d++) {
    computeTimeline(d);
  }
}

function buildPdfPayload() {
  const payload = {
    courseTitle: courseTitle || "未設定",
    tripDays: tripDays,
    startPoint: startPointRaw,
    startAddress: startAddressRaw,
    startTime: startTime,
    // ★追加：Dayごとの出発時刻
    startTimesByDay: startTimesByDay || [],
    routes: []
  };

  for (let d = 0; d < dayCount; d++) {
    const dayRoute = routesByDay[d] || [];
    const simpleDay = dayRoute.map(function(r){
    	  const simple = {
    	    name: r.name,
    	    lat: r.lat,
    	    lng: r.lng,
    	    type: r.type,
    	    stayTime: r.stayTime || 0,
    	    memo: r.memo || "",
    	    transport: r.transport || "徒歩",
    	    photoUrl: r.photoUrl || "",
    	    arriveTime: r.arriveTime || "",
    	    departTime: r.departTime || ""
    	  };

    	  // ★ 電車区間には注記をメモに追加（既存メモがあれば改行して追記）
    	  if (simple.transport === "電車") {
  			simple.memo = (simple.memo ? simple.memo + "\n\n" : "") +
                 "【重要】現在、β版として電車の移動手段を実装していますがPDFを生成することができません。";
}

    	  return simple;
    	});
    payload.routes.push(simpleDay);
  }
  return payload;
}

//全ルート確定ボタン（ゴールチェック付き・安全版）
$("#confirmRouteBtn").on("click", function(){
  // ルートが空の場合
	if (!routesByDay || routesByDay.length === 0 || !routesByDay[0] || routesByDay[0].length === 0) {
	    alert("ルートが未設定です。スポットやゴールを追加してください。");
	    return;
	  }

	  console.log("routesByDay:", routesByDay);  // ← ここで構造を確認

	  // 全日のゴールチェック
	  let missingGoalDays = [];
	  try {
	    for (let dayIndex = 0; dayIndex < routesByDay.length; dayIndex++) {
	      let dayRoute = routesByDay[dayIndex] || [];
	      console.log(`Day ${dayIndex + 1}:`, dayRoute);  // ← 各日の内容を確認

	      let hasGoal = false;
	      for (let j = 0; j < dayRoute.length; j++) {
	        let r = dayRoute[j];
	        if (r && r.type === "goal") {
	          hasGoal = true;
	          console.log(`Day ${dayIndex + 1} にゴール発見:`, r.name);
	          break;
	        }
	      }

	      if (!hasGoal) {
	        missingGoalDays.push(dayIndex + 1);
	        console.log(`Day ${dayIndex + 1} にゴールなし`);
	      }
	    }

	    if (missingGoalDays.length > 0) {
	      let daysStr = missingGoalDays.join("日目、") + "日目";
	      alert("以下の日のゴール地点が設定されていません：\n" +
	            "Day " + daysStr + "\n\n" +
	            "各日のゴール地点を設定してから「全ルート確定」を押してください。\n" +
	            "（各日の「ゴール設定」ボタンで住所を入力できます）");

	      // 最初の未設定日にスクロール
	      let firstMissingDay = missingGoalDays[0];
	      let section = $("#daySection" + firstMissingDay);
	      if (section && section.length > 0) {
	        section[0].scrollIntoView({ behavior: "smooth", block: "center" });
	      }
	      return;
	    } else {
	      console.log("全日ゴール設定済み");
	    }
	  } catch (err) {
	    console.error("ゴールチェックエラー:", err);
	  }

	  // 確定処理
	  syncRoutesFromDOM();
	  const payload = buildPdfPayload();
	  const jsonStr = JSON.stringify(payload);
	  const form = document.createElement("form");
	  form.method = "POST";
	  form.action = "pdf_output.jsp";
	  form.style.display = "none";
	  const input = document.createElement("input");
	  input.type = "hidden";
	  input.name = "routeData";
	  input.value = jsonStr;
	  form.appendChild(input);
	  document.body.appendChild(form);
	  form.submit();
});

/* ------------------------
   ユーティリティ
   ------------------------ */
function escapeHtml(str) {
  if (!str && str !== 0) return "";
  return String(str)
    .replace(/&/g, "&amp;")
    .replace(/</g, "&lt;")
    .replace(/>/g, "&gt;")
    .replace(/"/g, "&quot;")
    .replace(/'/g, "&#039;");
}

function removeExistingGoal(dayIndex) {
	  const list = routesByDay[dayIndex];
	  if (!list) return;

	  for (let i = list.length - 1; i >= 0; i--) {
	    const r = list[i];
	    if (r.type === "goal") {

	      // ★ marker を地図から削除
	      if (r.marker && mapsByDay[dayIndex]?.markers) {
	        mapsByDay[dayIndex].markers.removeLayer(r.marker);
	      }

	      // ★ データから削除
	      list.splice(i, 1);
	    }
	  }

	  // ★ 表示更新
	  renderRouteHistory(dayIndex);

	  if (list.length >= 2) {
	    redrawRouteLine(dayIndex);
	  }
	}

function markNextDayStartNeedsReconfirm(dayIndex) {
	  const nextDay = dayIndex + 1;
	  const list = routesByDay[nextDay];
	  if (!list || !list[0]) return;

	  list[0].needsReconfirm = true;

	  renderRouteHistory(nextDay);
	}

function updateNextDayStart(dayIndex, lat, lng, name) {
	  const nextDay = dayIndex + 1;
	  const list = routesByDay[nextDay];
	  if (!list || !list[0]) return;

	  // ★ 地図上を一度リセット
	  clearNextDayMarkers(dayIndex);

	  const start = list[0];
	  start.name = name;
	  start.lat = lat;
	  start.lng = lng;
	  start.type = "start";
	  start.needsReconfirm = false;

	  const marker = addMarker(nextDay, name, lat, lng, "start");
	  if (marker) start.marker = marker;

	  if (mapsByDay[nextDay]?.map) {
	    mapsByDay[nextDay].map.setView([lat, lng], 13);
	  }

	  renderRouteHistory(nextDay);
	  if (list.length >= 2) redrawRouteLine(nextDay);
	}



function clearNextDayMarkers(dayIndex) {
	  const nextDay = dayIndex + 1;
	  const mapObj = mapsByDay[nextDay];
	  if (!mapObj?.markers) return;

	  mapObj.markers.clearLayers(); // ★ 全削除
	}



//------------------------
//LocalStorage 保存・復元
//------------------------
function saveRoutesToLocal() {
  const payload = buildPdfPayload();
  localStorage.setItem("routesData", JSON.stringify(payload));
}

function loadRoutesFromLocal() {
  const dataStr = localStorage.getItem("routesData");
  if (!dataStr) return null;
  try {
    return JSON.parse(dataStr);
  } catch(e) {
    console.error("LocalStorage 読み込みエラー", e);
    return null;
  }
}

$(document).ready(function(){
  populateAreaAndTagSelects("areaDropdown", "tagDropdown");

  function initStartSection(lat, lng, name, day=1) {
    createDaySection(day, lat, lng, name);
    mapsByDay.forEach(m => { try { m.map.invalidateSize(); } catch(e){} });
  }

  const savedData = loadRoutesFromLocal();
  if (savedData && savedData.routes) {
    if (savedData.courseTitle !== undefined) courseTitle = savedData.courseTitle;
    if (savedData.tripDays !== undefined) tripDays = savedData.tripDays;
    if (savedData.startPoint !== undefined) startPointRaw = savedData.startPoint;
    if (savedData.startAddress !== undefined) startAddressRaw = savedData.startAddress;
    if (savedData.startTime !== undefined) startTime = savedData.startTime;

    // ★Day出発時刻復元
    if (Array.isArray(savedData.startTimesByDay)) {
      startTimesByDay = savedData.startTimesByDay.slice(0);
    }

    applyHeaderToDom();
    routesByDay = savedData.routes.map(day => day.map(r => ({ ...r })));
    dayCount = routesByDay.length;

    routesByDay.forEach((dayRoute, d) => {
      dayRoute.forEach((r, i) => {
        if (i === 0) {
          initStartSection(r.lat, r.lng, r.name, d+1);
          // Day出発時刻 input に反映（createDaySection時に startTimesByDay を参照）
        } else {
          addRouteHistory(
            d,
            r.name,
            r.lat,
            r.lng,
            r.type || "normal",
            null,
            r.photoUrl || null,
            r.stayTime,
            r.memo,
            r.transport
          );
        }
      });
      // ★時間再計算
      computeTimeline(d);
      renderRouteHistory(d);
    });

    routesByDay.forEach((dayRoute, d) => {
      if (dayRoute.length >= 2) {
        redrawRouteLine(d);
      }
    });

  } else {
    // 初期：Day1開始時刻
    startTimesByDay[0] = startTime || "09:00";

    if (startPointRaw === "任意の地点") {
      if (startAddressRaw && startAddressRaw.trim().length > 0) {
        geocodeAddressNominatim(startAddressRaw)
          .then(res => {
            $("#startAddress").text("（" + res.display_name + "）");
            initStartSection(res.lat, res.lng, startAddressRaw);
          })
          .catch(err => {
            console.warn("ジオコーディング失敗:", err);
            initStartSection(FIXED_STARTS["山形駅"].lat, FIXED_STARTS["山形駅"].lng, "山形駅（ジオコ失敗）");
          });
      } else {
        initStartSection(FIXED_STARTS["山形駅"].lat, FIXED_STARTS["山形駅"].lng, "山形駅");
      }
    } else if (FIXED_STARTS[startPointRaw]) {
      const s = FIXED_STARTS[startPointRaw];
      initStartSection(s.lat, s.lng, startPointRaw);
    } else {
      initStartSection(FIXED_STARTS["山形駅"].lat, FIXED_STARTS["山形駅"].lng, startPointRaw || "山形駅");
    }
  }

  // 初期スポットロード
const spotModalEl = document.getElementById("spotModal");

spotModalEl.addEventListener("show.bs.modal", function () {
  if (allSpots && allSpots.length > 0) {
    currentSpotPage = 1;
    updateSpotCards({
      favOnly: $("#favOnlyCheck").prop("checked"),
      keepPage: false
    });
  } else {
    $.ajax({
      url: "CourseSpotSearch.action",
      type: "POST",
      dataType: "json",
      success: function(data){
        allSpots = data.spots || [];
        currentSpotPage = 1;
        updateSpotCards({
          favOnly: $("#favOnlyCheck").prop("checked"),
          keepPage: false
        });
        updateAreaTagButtonText();
      }
    });
  }
});

$(document).on("change", "#favOnlyCheck", function(){
	  updateSpotCards({
	    favOnly: this.checked,
	    keepPage: false
	  });
	});

  $(".day-section").on("change", ".stayTime, .transportSelect", function(){
    syncRoutesFromDOM();
    saveRoutesToLocal();
  });
  $(".day-section").on("input", ".memoInput", function(){
    syncRoutesFromDOM();
    saveRoutesToLocal();
  });
});
document.addEventListener("DOMContentLoaded", function () {

	  document.querySelectorAll(".modal").forEach(modal => {

	    modal.addEventListener("show.bs.modal", () => {
	      setHeaderHide(true);
	    });

	    modal.addEventListener("hidden.bs.modal", () => {
	      setHeaderHide(false);
	    });

	  });

	});
</script>

<!-- Bootstrap JS（Bundle：Popper 同梱） -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>

</body>
</html>
  </c:param>
</c:import>
