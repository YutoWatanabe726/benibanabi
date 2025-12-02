<%-- 管理者名産品編集完了JSP --%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<c:import url="/common/admin_base.jsp">
	<c:param name="title">
		名産品編集
	</c:param>

	<c:param name="content">
    <div class="container mt-4">
			<h2>名産品編集完了</h2>
			<div>
				<p>編集が完了しました</p>
				<a href="AdminSouvenirSetting.action">管理者名産品へ</a>
				<a href="AdminMenu.action">管理者機能一覧へ</a>
			</div>
		</div>
	</c:param>
</c:import>
