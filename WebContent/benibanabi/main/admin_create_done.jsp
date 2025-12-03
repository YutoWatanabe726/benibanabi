<%-- 管理者削除完了JSP --%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<c:import url="/common/admin_base.jsp">
	<c:param name="title">
		新規作成完了
	</c:param>

	<c:param name="content">
	<link rel="stylesheet" href="${pageContext.request.contextPath}/css/admin_login_logout_password_delete.css" />
    <div id="wrap_box">
        <h2>新規作成登録完了</h2>
        <p>登録が完了しました</p>
        <a href="AdminLogin.action">管理者ログインへ</a>
    </div>
	</c:param>
</c:import>
