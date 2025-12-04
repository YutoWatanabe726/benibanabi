<%-- 管理者名産品JSP --%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<c:import url="/common/admin_base.jsp">
	<c:param name="title">
		管理者名産品
	</c:param>

	<c:param name="content">
	<link rel="stylesheet" href="${pageContext.request.contextPath}/css/admin_spot_topics_souvenir_setting.css">
    <div class="container mt-4">
			<h2>管理者名産品</h2>
			<div>
				<a href="AdminSouvenirCreate.action">名産品新規作成</a>
				<a href="AdminSouvenirList.action">名産品編集</a>
				<a href="AdminMenu.action" class="btn btn-secondary">戻る</a>
			</div>
		</div>
	</c:param>
</c:import>
