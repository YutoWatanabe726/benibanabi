<%-- 管理者タグ削除完了JSP --%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<c:import url="/common/admin_base.jsp">
    <c:param name="title">
        タグ削除完了
    </c:param>

    <c:param name="content">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/admin_login_logout_password_delete.css" />

        <div id="wrap_box">
            <h2>タグ削除完了</h2>
            <p>タグの削除が完了しました。</p>

            <div class="button-group">
                <a href="AdminTagList.action">タグ一覧へ</a>
                <a href="AdminMenu.action">管理者メニューへ</a>
            </div>
        </div>

    </c:param>
</c:import>
