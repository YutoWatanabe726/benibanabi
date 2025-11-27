<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<c:import url="/common/admin_base.jsp">
	<c:param name="title">管理者観光スポット削除</c:param>

	<c:param name="content">
    <div class="container mt-4">
			<h2>管理者観光スポット削除</h2>
			<div>
				<p>削除が完了しました</p>
				<a href="AdminSpotSetting.action">管理者観光スポット一覧へ</a>
				<a href="AdminMenu.action">管理者メニューへ</a>
			</div>
		</div>
	</c:param>
</c:import>
