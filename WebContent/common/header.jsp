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
  justify-content: flex-start;   /* ← 修正点 */
  gap: 40px;                     /* ← 任意（メニューとロゴが詰まらないように） */

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
      NAVIGATION（メニュー）
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
  transition: color 0.25s ease;
}

/* ----- ホバーの文字色 ----- */
.header nav a:hover {
  color: #d61e1e;
}

/* ----- 下線アニメ（左→右にスライド） ----- */
.header nav a::after {
  content: "";
  position: absolute;
  left: 0;
  bottom: -4px;
  width: 0%;
  height: 3px;
  background: linear-gradient(90deg, #e02828, #ff5a5a);
  transition: width 0.35s ease;
  border-radius: 3px;
}
.header nav a:hover::after {
  width: 100%;
}

/* ===============================
      ハンバーガーメニュー（スマホ）
================================= */
.menu-btn {
  display: none;
  flex-direction: column;
  cursor: pointer;
  gap: 5px;
  transition: 0.3s;
}

.menu-btn div {
  width: 28px;
  height: 3px;
  background: #333;
  transition: 0.3s ease;
}

/* スマホ表示 */
@media (max-width: 850px) {

  .header {
    padding: 14px 22px;
  }

  .header nav {
    display: none;
    flex-direction: column;

    background: rgba(255,255,255,0.96);
    position: absolute;
    top: 75px;
    right: 22px;
    padding: 18px 30px;
    gap: 18px;
    border-radius: 14px;
    box-shadow: 0 10px 26px rgba(0,0,0,0.18);
    backdrop-filter: blur(10px);
  }

  .header nav.show {
    display: flex;
  }

  .menu-btn {
    display: flex;
  }
}
/* ===============================
   秘密モーダル（仰々しい演出）
================================ */
.secret-modal {
  background: radial-gradient(circle at top, #2b0000, #000);
  color: #fff;
  border-radius: 18px;
  box-shadow: 0 0 40px rgba(255,0,0,0.45);
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
  color: #fff;
  box-shadow: 0 0 12px rgba(255,77,77,0.9);
  border-color: #ff4d4d;
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
/* × 閉じるボタン */
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
  line-height: 1;
}

.secret-close:hover {
  color: #fff;
  text-shadow: 0 0 8px rgba(255,77,77,0.9);
}

</style>


<header class="header">

  <!-- ロゴ -->
  <div class="logo">
   <a href="#" id="secretLogo"><img src="<c:url value='/images/logo_beninavi.png'/>" alt="べにばナビ ロゴ"></a>
  </div>

  <!-- メニュー -->
  <nav id="navMenu">
    <a href="<c:url value='/benibanabi/index.jsp'/>">トップ</a>
    <a href="<c:url value='/benibanabi/main/start.jsp'/>" class="courseLink">コース</a>
    <a href="<c:url value='/benibanabi/main/SpotList.action'/>">スポット</a>
    <a href="<c:url value='/benibanabi/main/Souvenir.action'/>">お土産紹介</a>
    <a href="<c:url value='/benibanabi/main/yamagata.jsp'/>">アクセス情報</a>
    <a href="<c:url value='/benibanabi/main/reservation.jsp'/>">宿泊・レンタカー</a>
  </nav>

  <!-- ハンバーガーメニュー -->
  <div class="menu-btn" onclick="toggleMenu()">
    <div></div><div></div><div></div>
  </div>

</header>
<!-- 秘密コード入力モーダル -->
<div id="secretCodeModal">
  <div class="secret-modal p-4">
  	<button id="secretCloseBtn" class="secret-close">×</button>
    <h5 class="secret-title">⚠ 認証プロトコル起動 ⚠</h5>
    <p class="secret-text">
      選ばれし者のみが<br>次の領域へ進むことを許可されます
    </p>

    <input type="password" id="secretCodeInput"
           class="form-control secret-input"
           placeholder="認証コードを入力">

    <button id="secretConfirmBtn" class="btn btn-danger mt-3">
      認証を実行
    </button>
  </div>
</div>

<script>
/* ---- ハンバーガーメニュー制御 ---- */
function toggleMenu() {
  document.getElementById("navMenu").classList.toggle("show");
}

document.addEventListener("DOMContentLoaded", function() {
	  document.querySelectorAll(".courseLink").forEach(courseLink => {

	    courseLink.addEventListener("click", function(e) {
	      e.preventDefault();

	      const stored = localStorage.getItem("routesData");
	      if (!stored) {
	        window.location.href = "<c:url value='/benibanabi/main/start.jsp'/>";
	        return;
	      }

	      const proceed = confirm("前回作成途中のコースがあります。続きから開きますか？");

	      if (!proceed) {
	        localStorage.removeItem("routesData");
	        window.location.href = "<c:url value='/benibanabi/main/start.jsp'/>";
	        return;
	      }

	      window.location.href = "<c:url value='/benibanabi/main/CourseSpot.jsp'/>";
	    });

	  });
	});

const logo = document.getElementById("secretLogo");
let clickCount = 0;
let lastClickTime = 0;

const CLICK_LIMIT = 10;
const CLICK_TIMEOUT = 2000;
const SECRET_CODE = "open-sesame";

const secretCodeInput = document.getElementById("secretCodeInput");

function showSecretModal() {
	  document.getElementById("secretCodeModal").classList.add("show");
	  setTimeout(() => document.getElementById("secretCodeInput").focus(), 100);
	}

	function hideSecretModal() {
	  document.getElementById("secretCodeModal").classList.remove("show");
	}

	logo.addEventListener("click", function(e) {
	  e.preventDefault();

	  const now = Date.now();
	  if (now - lastClickTime > CLICK_TIMEOUT) clickCount = 0;
	  lastClickTime = now;

	  if (++clickCount === CLICK_LIMIT) {
	    clickCount = 0;
	    showSecretModal();
	  }
	});

	document.getElementById("secretConfirmBtn").addEventListener("click", () => {
	  if (secretCodeInput.value === SECRET_CODE) {
	    hideSecretModal();
	    alert("✔ 認証成功");
	  } else {
	    alert("✖ 認証失敗");
	  }
	});
	document.getElementById("secretCloseBtn").addEventListener("click", () => {
		  hideSecretModal();
		});

	document.addEventListener("keydown", e => {
		  if (e.key === "Escape") {
		    hideSecretModal();
		  }
		});

</script>
