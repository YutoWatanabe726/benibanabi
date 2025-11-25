<%-- 管理者観光スポットJSP --%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<c:import url="/common/admin_base.jsp">
	<c:param name="title">
		管理者観光スポット
	</c:param>

	<c:param name="content">
    <div class="container mt-4">
			<h2>管理者観光スポット</h2>
			<div>
				<a href="AdminSpotCreate.action">観光スポット新規作成</a>
				<a href="AdminSpotList.action">観光スポット編集・削除</a>
			</div>
		</div>
	</c:param>
</c:import>
