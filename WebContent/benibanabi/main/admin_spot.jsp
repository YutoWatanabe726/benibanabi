<%-- admin_spot.jsp（JSTL版・CSS外部化） --%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<c:import url="/common/admin_base.jsp">
  <c:param name="title">
    観光スポット管理
  </c:param>

  <c:param name="content">
    <link rel="stylesheet" href="${pageContext.request.contextPath}" />

    <header> 観光スポット管理（管理者用）</header>

    <main>
      <!-- 管理メニュー -->
      <section id="menu" class="menu visible">
        <h2>観光スポット管理メニュー</h2>
        <p>以下の操作を選択してください。</p>
        <button id="newSpotBtn">新規登録</button>
        <button id="listSpotBtn">一覧・編集</button>
      </section>
    </main>


  </c:param>
</c:import>
