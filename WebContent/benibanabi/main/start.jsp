<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<c:import url="/common/base.jsp">
  <c:param name="title">コース作成</c:param>

  <c:param name="content">
<!-- <!DOCTYPE html> -->
<!-- <html lang="ja"> -->
<!-- <head> -->
<meta charset="UTF-8">
<title>スタート地点設定</title>

<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
<link rel="stylesheet" href="https://unpkg.com/leaflet@1.9.4/dist/leaflet.css"/>

<style>
body{font-family:Arial,sans-serif;background:#f5f7fa;margin:0;padding:0;}
h1{background:linear-gradient(90deg,#FFAA47,#E6483E);color:#fff;text-align:center;padding:16px;font-size:1.4rem;}
main{max-width:500px;margin:2rem auto;background:#fff;padding:20px;border-radius:12px;box-shadow:0 2px 8px rgba(0,0,0,0.1);}
label{display:block;margin-top:1rem;font-weight:bold;}
.input-like{width:100%;padding:10px;border:1px solid #ccc;border-radius:8px;background:#fff;}
.clickable{cursor:pointer;}
#daySelectArea{margin-top:8px;display:none;padding:10px;background:#FFF5F3;border:1px solid #FFB0A0;border-radius:8px;}
.day-grid{display:grid;grid-template-columns:repeat(3,1fr);gap:10px;}
.day-option{padding:10px 0;text-align:center;background:#FFE4DD;border:1px solid #FFB0A0;border-radius:8px;cursor:pointer;font-weight:bold;color:#D44A3A;transition:0.2s;}
.day-option:hover{background:#FFD3CC;}
.day-option.active{background:linear-gradient(90deg,#FFAA47,#E6483E);border-color:#E6483E;color:#fff;}
#otherDayInput{margin-top:12px;display:none;}
#address-field{display:none;}
button.primary-btn{margin-top:20px;width:100%;padding:10px;font-size:1.1rem;font-weight:bold;background:linear-gradient(90deg,#FFAA47,#E6483E);color:#fff;border:none;border-radius:8px;cursor:pointer;transition:0.2s;}
button.primary-btn:hover{opacity:0.85;}
#candidateMap{width:100%;height:360px;border-radius:10px;overflow:hidden;border:1px solid #ddd;}
#candidateList{max-height:260px;overflow-y:auto;}
.candidate-item{padding:8px 10px;border:1px solid #eee;border-radius:8px;margin-bottom:6px;cursor:pointer;background:#fff;}
.candidate-item.active{border-color:#ff7043;box-shadow:0 0 0 2px rgba(255,112,67,0.18);}
.small-muted{font-size:0.85rem;color:#666;}
.address-actions{display:flex;gap:8px;align-items:center;}
.address-actions .btn{white-space:nowrap;}
</style>
<!-- </head> -->
<!-- <body> -->



<main>
<h1>スタート地点設定</h1>
<form id="startForm" action="Course.action" method="post">

  <label for="courseTitle">コースタイトル</label>
  <input type="text" id="courseTitle" name="courseTitle"
         class="input-like" placeholder="例：山形名所巡りコース" required maxlength="20" />

  <label>旅行期間（日数）</label>
  <div id="daySelectBox" class="input-like clickable">日数を選択してください</div>

  <div id="daySelectArea">
    <div class="day-grid">
      <% for(int i=1; i<=9; i++){ %>
        <div class="day-option" data-value="<%=i%>"><%=i%>日</div>
      <% } %>
      <div class="day-option" data-value="other">その他</div>
    </div>
    <div id="otherDayInput">
      <input type="number" id="otherDayValue" min="10" max="30"
             class="input-like" placeholder="10〜30 を入力">
    </div>
  </div>

  <input type="hidden" id="tripDays" name="tripDays" value="">

  <label>スタート地点</label>
  <div class="radio-group">
    <label><input type="radio" name="startPoint" value="山形駅" checked> 山形駅</label>
    <label><input type="radio" name="startPoint" value="山形空港"> 山形空港</label>
    <label><input type="radio" name="startPoint" value="任意の地点"> 任意の地点</label>
  </div>

  <div id="address-field">
    <label>任意の地点を検索して決定</label>

    <div class="address-actions mt-1">
      <input type="text" id="startAddressQuery" class="input-like"
             placeholder="例：山形県山形市香澄町1-1-1">
      <button type="button" id="startAddressSearchBtn" class="btn btn-primary">検索</button>
    </div>

    <div class="small-muted mt-2">
      ※入力が曖昧な場合、候補が複数出るので地図上で選択できます。
    </div>

    <input type="hidden" id="address" name="address" value="">
    <input type="hidden" id="startLat" name="startLat" value="">
    <input type="hidden" id="startLng" name="startLng" value="">

    <div class="mt-2">
      <div class="small-muted">決定した地点：</div>
      <div id="startAddressSelectedText" style="font-weight:700;color:#1f2937;">未決定</div>
    </div>
  </div>

  <label for="startTime">観光開始時間</label>
  <input type="time" id="startTime" name="startTime"
         value="09:00" class="input-like" required />

  <button type="submit" class="primary-btn">スタート地点を設定</button>

  <script>
  // 修正版バリデーションコード（これを丸ごと置き換え）
  const badWords = [
    "死ね", "殺す", "自殺", "クソ野郎", "バカ野郎", "詐欺", "違法", "闇", "売春", "援交", "パパ活"
  ];

  const safePhrases = [
    "死ぬほど", "クソ", "バカ", "アホ", "草津", "クソ美味い", "クソ楽しい", "バカうまい"
  ];

  function checkTitle(title) {
    const trimmed = title.trim();
    const lower = trimmed.toLowerCase();

    // タグ記号（< > / " ' = など）をブロック
    if (/[<>/"'=]/.test(trimmed)) {
      return "タグ記号（< > / \" ' = など）は使用できません";
    }

    // URL/リンク検知
    if (/https?:\/\/|www\.|\.(com|net|jp|co\.jp)/i.test(lower)) {
      return "URLやリンクは使用できません";
    }

    // ホワイトリストに含まれるならOK
    if (safePhrases.some(p => lower.includes(p.toLowerCase()))) {
      return "";
    }

    // 不適切ワード検知
    if (badWords.some(w => lower.includes(w.toLowerCase()))) {
      return "不適切な言葉が含まれています";
    }

    // 文字数チェック
    if (trimmed.length > 20) {
      return "20文字以内で入力してください";
    }

    return "";
  }

  // リアルタイム警告
  document.getElementById("courseTitle").addEventListener("input", function() {
    const msg = checkTitle(this.value);
    this.style.borderColor = msg ? "red" : "";
    this.title = msg || "";
  });

  // 送信時チェック
  document.getElementById("startForm").addEventListener("submit", function(e) {
    const msg = checkTitle(document.getElementById("courseTitle").value);
    if (msg) {
      alert(msg);
      document.getElementById("courseTitle").focus();
      e.preventDefault();
    }
  });
</script>

</form>
</main>

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
            <div class="small-muted mt-2">ピンをクリックして候補を選択してください。</div>
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

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
<script src="https://unpkg.com/leaflet@1.9.4/dist/leaflet.js"></script>

<script>
/* ===== 日数選択 ===== */
const box = document.getElementById("daySelectBox");
const area = document.getElementById("daySelectArea");
const days = document.querySelectorAll(".day-option");
const tripInput = document.getElementById("tripDays");
const otherBox = document.getElementById("otherDayInput");
const otherValue = document.getElementById("otherDayValue");

area.style.display = "none";
box.addEventListener("click", () => { area.style.display = (area.style.display === "none") ? "block" : "none"; });

days.forEach(d => {
  d.addEventListener("click", () => {
    days.forEach(x => x.classList.remove("active"));
    d.classList.add("active");
    const val = d.dataset.value;
    if (val === "other") {
      otherBox.style.display = "block";
      tripInput.value = "";
      box.textContent = "日数：その他";
    } else {
      otherBox.style.display = "none";
      tripInput.value = val;
      box.textContent = "日数：" + val + "日";
    }
  });
});
otherValue.addEventListener("input", () => {
  tripInput.value = otherValue.value;
  box.textContent = "日数：" + otherValue.value + "日";
});

/* ===== 任意地点の開閉（任意以外ならクリア） ===== */
function clearCustomStartSelection(){
  document.getElementById("address").value = "";
  document.getElementById("startLat").value = "";
  document.getElementById("startLng").value = "";
  document.getElementById("startAddressSelectedText").textContent = "未決定";
  document.getElementById("startAddressQuery").value = "";
}
function updateAddressFieldVisibility() {
  const checked = document.querySelector('input[name="startPoint"]:checked');
  const isCustom = checked && checked.value === "任意の地点";
  document.getElementById('address-field').style.display = isCustom ? 'block' : 'none';
  if (!isCustom) clearCustomStartSelection();
}
document.querySelectorAll('input[name="startPoint"]').forEach(radio => radio.addEventListener('change', updateAddressFieldVisibility));
updateAddressFieldVisibility();

/* ===== ユーティリティ ===== */
function escapeHtml(str){
  if (str === null || str === undefined) return "";
  return String(str).replace(/&/g,"&amp;").replace(/</g,"&lt;").replace(/>/g,"&gt;").replace(/"/g,"&quot;").replace(/'/g,"&#039;");
}
function normalizeAddress(addr){
  if(!addr) return addr;
  let a = addr.trim();
  a = a.replace(/[０-９]/g, s => String.fromCharCode(s.charCodeAt(0)-65248));
  a = a.replace(/[ー－―]/g, "-");
  a = a.replace(/(\d+)丁目/g, "$1 Chome ");
  a = a.replace(/([^\d])(\d+-\d+-?\d*)/, "$1 $2");
  return a;
}

/* ===== GSI / Nominatim ===== */
async function geocodeCandidatesGSI(address){
  if(!address || !address.trim()) throw new Error("住所が空です");
  const url = "https://msearch.gsi.go.jp/address-search/AddressSearch?q=" + encodeURIComponent(address.trim());
  const res = await fetch(url);
  if(!res.ok) throw new Error("GSI住所検索に失敗しました");
  const data = await res.json();
  if(!Array.isArray(data) || data.length === 0) return [];
  return data.slice(0,10).map((d,idx)=>{
    const lng = d?.geometry?.coordinates?.[0];
    const lat = d?.geometry?.coordinates?.[1];
    const title = d?.properties?.title || ("候補 " + (idx+1));
    return { lat:Number(lat), lng:Number(lng), title:String(title) };
  }).filter(x => !isNaN(x.lat) && !isNaN(x.lng));
}
function geocodeAddressNominatim(address){
  return new Promise((resolve,reject)=>{
    if(!address || !address.trim()) return reject("住所が空です");
    const url="https://nominatim.openstreetmap.org/search?format=json&q=" + encodeURIComponent(address);
    fetch(url,{headers:{"Accept-Language":"ja"}})
      .then(r=>r.json())
      .then(json=>{
        if(Array.isArray(json) && json.length>0){
          resolve({lat:parseFloat(json[0].lat), lng:parseFloat(json[0].lon), display_name:json[0].display_name});
        } else reject("見つかりませんでした");
      })
      .catch(reject);
  });
}

/* ===== 候補モーダル（重要：初期化は shown 後） ===== */
let candidateMap = null;
let candidateLayer = null;
let candidateMarkers = [];
let candidateSelected = null;
let candidateData = [];
let pendingBounds = null;

function setCandidateSelected(idx){
  candidateSelected = candidateData[idx] || null;
  document.querySelectorAll("#candidateList .candidate-item").forEach(el=>el.classList.remove("active"));
  const active = document.querySelector("#candidateList .candidate-item[data-idx='"+idx+"']");
  if(active) active.classList.add("active");

  document.getElementById("candidateSelectedText").textContent = candidateSelected ? candidateSelected.title : "未選択";
  document.getElementById("candidateConfirmBtn").disabled = !candidateSelected;
}

function prepareCandidateUI(list){
  candidateSelected = null;
  candidateData = (list || []).slice(0);
  candidateMarkers = [];
  pendingBounds = [];

  document.getElementById("candidateList").innerHTML = "";
  document.getElementById("candidateSelectedText").textContent = "未選択";
  document.getElementById("candidateConfirmBtn").disabled = true;

  candidateData.forEach((c, idx) => {
    pendingBounds.push([c.lat, c.lng]);

    const item = document.createElement("div");
    item.className = "candidate-item";
    item.dataset.idx = idx;
    item.innerHTML =
      "<div><strong>候補 " + (idx+1) + "</strong></div>" +
      "<div class='small-muted'>" + escapeHtml(c.title) + "</div>" +
      "<div class='small-muted'>緯度:" + c.lat.toFixed(5) + " / 経度:" + c.lng.toFixed(5) + "</div>";

    item.addEventListener("click", function(){
      setCandidateSelected(idx);
      if(candidateMap){
        candidateMap.setView([c.lat, c.lng], 16);
        try { candidateMarkers[idx].openPopup(); } catch(e){}
      }
    });

    document.getElementById("candidateList").appendChild(item);
  });
}

/* モーダル表示後に地図を初期化＆ピン描画 */
document.getElementById("candidateModal").addEventListener("shown.bs.modal", function(){
  const mapDiv = document.getElementById("candidateMap");
  if(!mapDiv) return;

  if(!candidateMap){
    candidateMap = L.map("candidateMap", {
      zoomAnimation:false, fadeAnimation:false, markerZoomAnimation:false, inertia:false, preferCanvas:true
    }).setView([38.2485, 140.3276], 12);

    L.tileLayer("https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png", {
      attribution:"&copy; OpenStreetMap contributors"
    }).addTo(candidateMap);

    candidateLayer = L.layerGroup().addTo(candidateMap);
  }

  try { candidateMap.invalidateSize(true); } catch(e){}

  if(candidateLayer) candidateLayer.clearLayers();
  candidateMarkers = [];

  // pendingBounds / candidateData を元にピン生成
  candidateData.forEach((c, idx) => {
    const m = L.marker([c.lat, c.lng]).addTo(candidateLayer);
    m.bindPopup("<strong>候補 " + (idx+1) + "</strong><br>" + escapeHtml(c.title));
    m.on("click", function(){
      setCandidateSelected(idx);
      try { m.openPopup(); } catch(e){}
    });
    candidateMarkers.push(m);
  });

  // 初期表示
  if(pendingBounds && pendingBounds.length>0){
    setTimeout(function(){
      try{
        candidateMap.fitBounds(pendingBounds, {padding:[20,20]});
      }catch(e){
        candidateMap.setView(pendingBounds[0], 15);
      }
      // 1件目を選択状態に
      setCandidateSelected(0);
      try { candidateMarkers[0].openPopup(); } catch(e){}
    }, 80);
  }
});

/* ===== 決定反映 ===== */
function applyStartSelection(lat,lng,label,raw){
  const name = label || raw || "任意の地点";
  document.getElementById("address").value = name;
  document.getElementById("startLat").value = (lat!=null ? String(lat) : "");
  document.getElementById("startLng").value = (lng!=null ? String(lng) : "");
  document.getElementById("startAddressSelectedText").textContent =
    name + (lat!=null && lng!=null ? ("（" + lat.toFixed(5) + ", " + lng.toFixed(5) + "）") : "");
}

/* ===== 検索ボタン ===== */
document.getElementById("startAddressSearchBtn").addEventListener("click", async function(){
  const btn = this;
  const raw = (document.getElementById("startAddressQuery").value || "").trim();
  if(!raw){ alert("住所を入力してください"); return; }

  btn.disabled = true;

  try{
    const normalized = normalizeAddress(raw);
    let candidates = await geocodeCandidatesGSI(normalized);

    if(!candidates || candidates.length===0){
      const nomi = await geocodeAddressNominatim(normalized);
      applyStartSelection(Number(nomi.lat), Number(nomi.lng), nomi.display_name || raw, raw);
      alert("任意の地点を決定しました。");
      return;
    }

    if(candidates.length===1){
      applyStartSelection(candidates[0].lat, candidates[0].lng, candidates[0].title || raw, raw);
      alert("任意の地点を決定しました。");
      return;
    }

    // 複数 → UIだけ先に作って、地図は shown 後に描画
    prepareCandidateUI(candidates);

    const candModalEl = document.getElementById("candidateModal");
    const candModal = new bootstrap.Modal(candModalEl);
    candModal.show();

    document.getElementById("candidateConfirmBtn").onclick = function(){
      if(!candidateSelected){ alert("候補を選択してください。"); return; }
      applyStartSelection(Number(candidateSelected.lat), Number(candidateSelected.lng), candidateSelected.title || raw, raw);
      const inst = bootstrap.Modal.getInstance(candModalEl);
      if(inst) inst.hide();
    };

  }catch(err){
    console.error("任意地点検索エラー:", err);
    alert("住所の検索中にエラーが発生しました。");
  }finally{
    btn.disabled = false;
  }
});

/* ===== 送信時バリデーション ===== */
document.getElementById("startForm").addEventListener("submit", function(event){
  if(!tripInput.value){
    alert("旅行期間（日数）を選択してください。");
    event.preventDefault();
    return false;
  }
  const checked = document.querySelector('input[name="startPoint"]:checked');
  const isCustom = checked && checked.value === "任意の地点";
  if(isCustom){
    const addr = (document.getElementById("address").value || "").trim();
    if(!addr){
      alert("任意の地点が未決定です。「検索」から地点を決定してください。");
      event.preventDefault();
      return false;
    }
  }
});
</script>

<!-- </body> -->
<!-- </html> -->
  </c:param>
</c:import>
