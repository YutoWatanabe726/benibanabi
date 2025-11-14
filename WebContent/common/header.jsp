<%-- ヘッダー --%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<style>
/* ===== ヘッダー全体 ===== */
.header {
  width: 100%;
  background: #ffffff;
  padding: 12px 25px;
  display: flex;
  align-items: center;
  justify-content: space-between;
  box-shadow: 0 3px 10px rgba(0,0,0,0.1);
  position: sticky;
  top: 0;
  z-index: 100;
}

/* ===== ロゴ画像 ===== */
.header .logo img {
  height: 55px;      /* ← 大きさ調整ここ！ */
  width: auto;
  display: block;
}

/* ===== ナビゲーション ===== */
.header nav {
  display: flex;
  gap: 25px;
}

.header nav a {
  text-decoration: none;
  font-size: 1rem;
  font-weight: 600;
  color: #333;
  padding-bottom: 4px;
  position: relative;
  transition: color 0.25s;
}

.header nav a:hover {
  color: #e02828;
}

/* 下線アニメーション */
.header nav a::after {
  content: "";
  position: absolute;
  left: 0;
  bottom: -2px;
  width: 0%;
  height: 2px;
  background: #e02828;
  transition: width 0.35s;
}
.header nav a:hover::after {
  width: 100%;
}

/* ===== スマホ対応 ===== */
@media (max-width: 750px) {
  .header {
    flex-direction: column;
    align-items: flex-start;
  }
  .header nav {
    flex-wrap: wrap;
    gap: 15px;
    margin-top: 10px;
  }
}
</style>

<header class="header">

  <!-- ★ここにロゴ画像を差し込む ★ -->
  <div class="logo">
    <img src="<c:url value='/images/logo_beninavi.png'/>" alt="べにばナビ ロゴ">
  </div>

  <nav>
    <a href="index.jsp">トップ</a>
    <a href="start.jsp">コース</a>
    <a href="#">スポット</a>
    <a href="#">イベント</a>
    <a href="main/souvenir.jsp">お土産紹介</a>
    <a href="main/yamagata.jsp">アクセス情報</a>
    <a href="main/reservation.jsp">宿泊・レンタカー</a>
  </nav>
</header>
