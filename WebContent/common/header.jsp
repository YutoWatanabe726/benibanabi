<%-- ヘッダー --%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<style>

/* ===============================
      HEADER（ガラス風デザイン）
================================= */
.header {
  width: 100%;
  padding: 18px 48px;
  display: flex;
  align-items: center;
  justify-content: flex-start;
  gap: 40px;
  background: rgba(255,255,255,0.55);
  backdrop-filter: blur(14px);
  -webkit-backdrop-filter: blur(14px);

  position: fixed;          /* ★ sticky → fixed */
  top: 0;
  left: 0;

  z-index: 1500;
  transition: 0.35s ease;
  border-bottom: 1px solid rgba(255,255,255,0.4);
  box-shadow: 0 4px 14px rgba(0,0,0,0.05);
  box-sizing: border-box;
}

/* ヘッダー分の余白（必須） */
body {
  padding-top: 72px;        /* ヘッダー高さ */
}

/* ===============================
      NAVIGATION（PC）
================================= */
.header nav {
  display: flex;
  gap: 36px;
}

.header nav a {
  text-decoration: none;
  font-size: 1.06rem;
  font-weight: 600;
  color: #333;
  letter-spacing: 0.04em;
  padding-bottom: 6px;
  position: relative;
}

.header nav a:hover {
  color: #d61e1e;
}

.header nav a::after {
  content: "";
  position: absolute;
  left: 0;
  bottom: -4px;
  width: 0%;
  height: 3px;
  background: linear-gradient(90deg, #e02828, #ff5a5a);
  transition: width 0.35s ease;
}
.header nav a:hover::after {
  width: 100%;
}

/* ===============================
      ハンバーガー
================================= */
.menu-btn {
  display: none;
  flex-direction: column;
  cursor: pointer;
  gap: 5px;
}

.menu-btn div {
  width: 28px;
  height: 3px;
  background: #333;
}

/* ===============================
   秘密モーダル
================================ */
.secret-modal {
  background: radial-gradient(circle at top, #2b0000, #000);
  color: #fff;
  border-radius: 18px;
  box-shadow: 0 0 40px rgba(255,0,0,0.45);
  position: relative;
}
/* ===== モーダル内UI（Bootstrap代替） ===== */
.secret-input {
  width: 100%;
  padding: 10px 12px;
  border-radius: 8px;
  border: none;
  margin-top: 12px;
}

.secret-close {
  position: absolute;
  top: 10px;
  right: 14px;
  background: transparent;
  border: none;
  font-size: 22px;
  color: #ff6b6b;
  cursor: pointer;
}

.secret-title {
  color: #ff4d4d;
  text-align: center;
  margin-bottom: 12px;
}

.secret-text {
  color: #ffb3b3;
  text-align: center;
  margin-top: 10px;
}

.secret-modal .btn {
  width: 100%;
  background: linear-gradient(90deg, #c40000, #ff3b3b);
  border: none;
  color: #fff;
  padding: 10px;
  border-radius: 10px;
  font-weight: bold;
  cursor: pointer;
}


/* ===============================
   レスポンシブ（スマホ）
================================= */
@media screen and (max-width: 768px) {

  html, body {
    max-width: 100%;
    overflow-x: hidden;
  }

  .header {
    padding: 14px 20px;
  }

  /* スマホ用余白調整 */
  body {
    padding-top: 64px;
  }

  /* ナビ（スマホ・固定） */
  .header nav {
    position: fixed;
    top: 64px;               /* ヘッダー直下 */
    left: 0;
    right: 0;
    width: 100%;

    max-height: calc(100vh - 64px);
    overflow-y: auto;

    display: flex;
    flex-direction: column;
    gap: 18px;

    background: rgba(255,255,255,0.95);
    backdrop-filter: blur(14px);
    -webkit-backdrop-filter: blur(14px);

    padding: 20px 0;
    box-sizing: border-box;

    transform: translateY(-20px);
    opacity: 0;
    pointer-events: none;

    transition: all 0.35s ease;
    box-shadow: 0 8px 20px rgba(0,0,0,0.08);
    z-index: 1400;
  }

  .header nav.show {
    transform: translateY(0);
    opacity: 1;
    pointer-events: auto;
  }

  .header nav a {
    font-size: 1rem;
    padding: 8px 24px;
  }

  /* ハンバーガー最前面 */
  .menu-btn {
    display: flex;
    margin-left: auto;
    position: relative;
    z-index: 2000;
  }

  .secret-modal {
    width: 90%;
    max-width: 360px;
    padding: 20px;
  }
}

/* ===============================
   超小型スマホ
================================= */
@media screen and (max-width: 400px) {

  .header {
    padding: 12px 16px;
  }

  body {
    padding-top: 56px;
  }

  .header nav a {
    font-size: 0.95rem;
  }
}

/* ===============================
   秘密モーダル表示制御
================================= */
#secretCodeModal {
  position: fixed;
  inset: 0;                       /* top/right/bottom/left = 0 */
  display: none !important;

  align-items: center;            /* 中央寄せ */
  justify-content: center;

  background: rgba(0,0,0,0.55);   /* 背景暗転 */
  z-index: 3000;                  /* headerより前 */
}

#secretCodeModal.show {
  display: flex !important;
}


*, *::before, *::after {
  box-sizing: border-box;
}

html, body {
  overflow-x: hidden;
}

/* ===============================
   モーダル表示中：ヘッダー退避
================================= */
.header {
  transition: transform 0.35s ease, opacity 0.25s ease;
  will-change: transform;
}

/* モーダルON */
body.header-hide .header {
  transform: translateY(-100%);
  opacity: 0;
}

/* header が消えている間は余白も消す */
body.header-hide {
  padding-top: 0 !important;
}

</style>




<header class="header">
  <div class="logo">
    <a href="#" id="secretLogo">
      <img src="<c:url value='/images/logo_beninavi.png'/>">
    </a>
  </div>

  <nav id="navMenu">
    <a href="<c:url value='/benibanabi/index.jsp'/>">トップ</a>
    <a href="#" class="courseLink">コース</a>
    <a href="<c:url value='/benibanabi/main/SpotSearch.action'/>">スポット</a>
    <a href="<c:url value='/benibanabi/main/Souvenir.action'/>">お土産紹介</a>
    <a href="<c:url value='/benibanabi/main/yamagata.jsp'/>">アクセス情報</a>
    <a href="<c:url value='/benibanabi/main/reservation.jsp'/>">宿泊・レンタカー</a>
  </nav>

  <div class="menu-btn" onclick="toggleMenu()">
    <div></div><div></div><div></div>
  </div>
</header>

<div id="secretCodeModal">
  <div class="secret-modal p-4">
    <button id="secretCloseBtn" class="secret-close">×</button>

    <h5 class="secret-title">⚠ 認証プロトコル起動 ⚠</h5>

    <input type="password" id="secretCodeInput"
      class="form-control secret-input"
      placeholder="認証コードを入力">

    <p id="secretMessage" class="secret-text"></p>
    <p id="countdownMessage" class="secret-text"></p>

    <button id="secretConfirmBtn" class="btn btn-danger mt-3">
      認証を実行
    </button>
  </div>
</div>

<script>
function toggleMenu() {
  document.getElementById("navMenu").classList.toggle("show");
}

const logo = document.getElementById("secretLogo");
const modal = document.getElementById("secretCodeModal");
const closeBtn = document.getElementById("secretCloseBtn");

let clickCount = 0;
let lastClickTime = 0;

const CLICK_LIMIT = 10;
const CLICK_TIMEOUT = 2000;
const SECRET_CODE = "open-sasaki";

const secretCodeInput = document.getElementById("secretCodeInput");
const secretMessage = document.getElementById("secretMessage");
const countdownMessage = document.getElementById("countdownMessage");

const remainingTime = document.getElementById("remainingTime");
if (remainingTime && typeof remainingTimeValue !== "undefined") {
  remainingTime.textContent = remainingTimeValue;
}

const failCount = document.getElementById("failCount");
if (failCount && typeof failCountValue !== "undefined") {
  failCount.innerText = failCountValue;
}


let isExploding = false;

/* モーダル表示 */
function showSecretModal() {
  modal.classList.add("show");
  isExploding = false;
  secretMessage.textContent = "認証コードを入力してください";
  countdownMessage.textContent = "";
  secretCodeInput.disabled = false;
  secretCodeInput.value = "";
  setTimeout(() => secretCodeInput.focus(), 100);
}

/* モーダル非表示 */
function hideSecretModal() {
  modal.classList.remove("show");
  modal.querySelector(".secret-modal").classList.remove("exploding");
  isExploding = false;
}

/* 即時爆発 */
function explodeImmediately() {
  isExploding = true;
  secretMessage.textContent = "✖ 認証失敗";
  countdownMessage.textContent = "💥 BOOM";
  secretCodeInput.disabled = true;

  const body = modal.querySelector(".secret-modal");
  body.classList.add("exploding");

  setTimeout(hideSecretModal, 700);
}

/* 認証ボタン */
document.getElementById("secretConfirmBtn").addEventListener("click", () => {
  if (isExploding) return;

  if (secretCodeInput.value === SECRET_CODE) {
    window.location.href =
      "<c:url value='/benibanabi/main/AdminMenu.action'/>";
    return;
  }

  // 1回失敗で即爆発
  explodeImmediately();
});

/* ロゴ連打 */
logo.addEventListener("click", e => {
  e.preventDefault();
  const now = Date.now();
  if (now - lastClickTime > CLICK_TIMEOUT) clickCount = 0;
  clickCount++;
  lastClickTime = now;

  if (clickCount >= CLICK_LIMIT) {
    clickCount = 0;
    showSecretModal();
  }
});

/* ×ボタン */
closeBtn.addEventListener("click", hideSecretModal);

/* ESCキー */
document.addEventListener("keydown", e => {
  if (e.key === "Escape") hideSecretModal();
});

document.addEventListener("DOMContentLoaded", function(){
	  document.querySelectorAll(".courseLink").forEach(link => {

	    link.addEventListener("click", function(e){
	      e.preventDefault();

	      const dataStr = localStorage.getItem("routesData");

	      // データなし → 通常スタート
	      if (!dataStr) {
	        window.location.href = "<c:url value='/benibanabi/main/start.jsp'/>";
	        return;
	      }

	      let data;
	      try {
	        data = JSON.parse(dataStr);
	      } catch(e) {
	        localStorage.removeItem("routesData");
	        window.location.href = "<c:url value='/benibanabi/main/start.jsp'/>";
	        return;
	      }

	      const ok = confirm(
	        "コース作成途中のものがあります。\n続きから作成しますか？"
	      );

	      if (ok) {
	        window.location.href =
	          "<c:url value='/benibanabi/main/CourseSpot.jsp'/>";
	      } else {
	        localStorage.removeItem("routesData");
	        window.location.href =
	          "<c:url value='/benibanabi/main/start.jsp'/>";
	      }
	    });

	  });
	});
function setHeaderHide(enable) {
	  document.body.classList.toggle("header-hide", enable);
	}

</script>
