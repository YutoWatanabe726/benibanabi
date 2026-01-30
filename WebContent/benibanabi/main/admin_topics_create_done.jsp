<%-- 管理者トピックス新規作成完了JSP --%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<c:import url="/common/admin_base.jsp">
    <c:param name="title">
        トピックス新規作成完了
    </c:param>

    <c:param name="content">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/admin_login_logout_password_delete.css" />

        <div id="wrap_box">
            <h2>トピックス新規作成完了</h2>
            <p>トピックスの作成が完了しました。</p>

            <div class="button-group">
                <a href="AdminTopicsList.action">トピックス一覧へ</a>
                <a href="AdminMenu.action">管理者機能一覧へ</a>
            </div>
        </div>

    </c:param>
</c:import>
