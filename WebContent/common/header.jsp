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

</style>


<header class="header">

  <!-- ロゴ -->
  <div class="logo">
    <img src="<c:url value='/images/logo_beninavi.png'/>" alt="べにばナビ ロゴ">
  </div>

  <!-- メニュー -->
  <nav id="navMenu">
    <a href="<c:url value='/benibanabi/index.jsp'/>">トップ</a>
    <a href="<c:url value='/benibanabi/main/start.jsp'/>" id="courseLink">コース</a>
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


<script>
/* ---- ハンバーガーメニュー制御 ---- */
function toggleMenu() {
  document.getElementById("navMenu").classList.toggle("show");
}

/* ---- スクロールでヘッダー縮小 ---- */
window.addEventListener("scroll", function () {
  const header = document.querySelector(".header");
  if (window.scrollY > 25) {
    header.classList.add("shrink");
  } else {
    header.classList.remove("shrink");
  }
});

/* ---- コースリンククリック時の LocalStorage 復元確認 ---- */
document.addEventListener("DOMContentLoaded", function() {
  const courseLink = document.getElementById("courseLink");
  if (!courseLink) return;

  courseLink.addEventListener("click", function(e) {
    e.preventDefault();

    const stored = localStorage.getItem("routesData");
    if (!stored) {
      // 保存データなし → 新規作成ページへ
      window.location.href = "<c:url value='/benibanabi/main/start.jsp'/>";
      return;
    }

    // 保存データあり → 確認
    const proceed = confirm("前回作成途中のコースがあります。続きから開きますか？");

    if (!proceed) {
      // 復元せず削除 → 新規作成ページ
      localStorage.removeItem("routesData");
      window.location.href = "<c:url value='/benibanabi/main/start.jsp'/>";
      return;
    }

    // 「はい」 → course.jsp に遷移（復元処理は course.jsp 側で実施）
    window.location.href = "<c:url value='/benibanabi/main/CourseSpot.jsp'/>";
  });
});
</script>
