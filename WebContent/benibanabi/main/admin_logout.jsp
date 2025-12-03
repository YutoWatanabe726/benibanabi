<%-- 管理者ログアウトJSP --%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<c:import url="/common/admin_base.jsp">
	<c:param name="title">
		管理者ログアウト
	</c:param>

	<c:param name="content">
    	<link rel="stylesheet" href="${pageContext.request.contextPath}/css/admin_login_logout_password_delete.css" />

		<div id="wrap_box">
			<h2>管理者ログアウト</h2>
				<p>ログアウトしました</p>
				<a href="AdminLogin.action">ログイン</a>
			</div>
	</c:param>
</c:import>