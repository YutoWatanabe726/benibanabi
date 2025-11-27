<%-- 管理者トピックスJSP --%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<c:import url="/common/admin_base.jsp">
	<c:param name="title">
		管理者トピックス
	</c:param>

	<c:param name="content">
    <div class="container mt-4">
			<h2>管理者トピックス</h2>
			<div>
				<a href="AdminTopicsCreate.action">トピックス新規作成</a>
				<a href="AdminTopicsList.action">トピックス編集</a>
				<a href="AdminMenu.action" class="btn btn-secondary">戻る</a>
			</div>
		</div>
	</c:param>
</c:import>
