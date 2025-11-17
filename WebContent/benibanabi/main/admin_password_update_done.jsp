<%-- 管理者削除完了JSP --%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<c:import url="/common/admin_base.jsp">
	<c:param name="title">
        管理者パスワード変更
	</c:param>

	<c:param name="content">
    <div class="container mt-4">
			<h2>管理者パスワード変更完了</h2>
			<div>
				<p>パスワードの変更が完了しました</p>
				<a href="">管理者機能一覧へ</a>
				<a href="">管理者ログインへ</a>
			</div>
		</div>
	</c:param>
</c:import>
