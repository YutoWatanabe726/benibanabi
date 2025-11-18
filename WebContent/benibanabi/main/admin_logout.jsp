<%-- 管理者ログアウトJSP --%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<c:import url="/common/admin_base.jsp">
	<c:param name="title">
		管理者ログアウト
	</c:param>

	<c:param name="content">
		<div id="wrap_box">
			<h2>管理者ログアウト</h2>
			<div id="wrap_box">
				<p>ログアウトしました</p>
				<a href="AdminLogin.action">ログイン</a>
			</div>
		</div>
	</c:param>
</c:import>