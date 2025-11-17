<%-- 管理者削除完了JSP --%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<c:import url="/common/admin_base.jsp">
	<c:param name="title">
		管理者アカウント削除
	</c:param>

	<c:param name="content">
    <div class="container mt-4">
			<h2>管理者アカウント削除</h2>
			<div>
				<p>削除が完了しました</p>
				<a href="">管理者新規作成へ</a>
			</div>
		</div>
	</c:param>
</c:import>
