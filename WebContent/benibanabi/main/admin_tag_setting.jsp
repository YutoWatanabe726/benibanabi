<%-- 管理者タグ機能一覧JSP --%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<c:import url="/common/admin_base.jsp">
	<c:param name="title">
		管理者タグ
	</c:param>

	<c:param name="content">
	<link rel="stylesheet" href="${pageContext.request.contextPath}/css/admin_spot_topics_souvenir_setting.css">
    <div class="container mt-4">
			<h2>管理者タグ</h2>
			<div>
				<a href="AdminTagCreate.action">タグ新規作成</a>
				<a href="AdminTagList.action">タグ削除</a>
				<a href="AdminMenu.action" class="btn btn-secondary">戻る</a>
			</div>
		</div>
	</c:param>
</c:import>
