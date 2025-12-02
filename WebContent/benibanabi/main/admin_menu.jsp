<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<c:import url="/common/admin_base.jsp">
<c:param name="title">
    管理者メニュー
</c:param>

  <c:param name="content">
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/admin_menu.css" />
<div class="menu-wrapper">
<div class="container">
<div>ログイン中のアカウント"<c:out value='${admin_id}'/>"</div>
<h1>管理者機能</h1>

      <a href="AdminSpotSetting.action" class="menu-item">観光スポットの登録・更新・削除</a>
<a href="AdminTopicsSetting.action" class="menu-item">トピックの追加、編集</a>
<a href="AdminSouvenirCreate.action" class="menu-item">特産品の追加、編集</a>
<a href="${pageContext.request.contextPath}/benibanabi/main/AdminReviewsSpotList.action" class="menu-item">コメント管理</a>
<a href="AdminPasswordUpdate.action" class="menu-item">パスワード編集</a>
<a href="AdminDelete.action" class="menu-item">アカウント削除</a>
<a href="AdminLogout.action" class="menu-item">ログアウト</a>

    </div>
</div>

    <script>
      const items = document.querySelectorAll(".menu-item");
      items.forEach(item => {
        item.addEventListener("click", () => {
          items.forEach(i => i.classList.remove("active"));
          item.classList.add("active");
        });
      });
</script>
</c:param>
</c:import>