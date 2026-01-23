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
  position: sticky;
  top: 0;
  z-index: 1000;
  transition: 0.35s ease;
  border-bottom: 1px solid rgba(255,255,255,0.4);
  box-shadow: 0 4px 14px rgba(0,0,0,0.05);
}

/* ===============================
      NAVIGATION
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

.secret-title {
  font-size: 1.3rem;
  font-weight: 700;
  letter-spacing: 0.12em;
  color: #ff4d4d;
}

.secret-text {
  font-size: 0.95rem;
  letter-spacing: 0.08em;
  opacity: 0.9;
}

.secret-input {
  margin-top: 18px;
  background: rgba(0,0,0,0.6);
  border: 1px solid #ff4d4d;
  color: #fff;
  text-align: center;
  letter-spacing: 0.25em;
}

.secret-input:focus {
  background: #000;
  box-shadow: 0 0 12px rgba(255,77,77,0.9);
}

#secretCodeModal {
  display: none;
  position: fixed;
  inset: 0;
  z-index: 2000;
  background: rgba(0,0,0,0.85);
}
#secretCodeModal.show {
  display: flex;
  align-items: center;
  justify-content: center;
}

.secret-close {
  position: absolute;
  top: 12px;
  right: 14px;
  background: none;
  border: none;
  color: #ff4d4d;
  font-size: 1.6rem;
  font-weight: bold;
  cursor: pointer;
}

/* 数字表示対策 */
#secretMessage,
#countdownMessage {
  font-family: inherit, system-ui, -apple-system, BlinkMacSystemFont, "Segoe UI", Arial, sans-serif;
}

.secret-number {
  letter-spacing: normal !important;
  font-family: monospace !important;
}

@keyframes explode {
  0% { transform: scale(1); opacity: 1; }
  100% { transform: scale(0); opacity: 0; filter: blur(12px); }
}

.secret-modal.exploding {
  animation: explode 0.6s ease-out forwards;
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
    <a href="<c:url value='/benibanabi/main/SpotList.action'/>">スポット</a>
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

</script>
