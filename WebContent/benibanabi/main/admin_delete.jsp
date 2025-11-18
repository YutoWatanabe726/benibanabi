<%-- 管理者削除JSP --%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<c:import url="/common/admin_base.jsp">
    <c:param name="title">
        管理者アカウント削除
    </c:param>

    <c:param name="content">

    <div class="container mt-4">
        <h2 class="mb-4">管理者アカウント削除</h2>

        <c:if test="${not empty errorMessage}">
            <div class="alert alert-danger">${errorMessage}</div>
        </c:if>

        <form action="AdminDeleteExecute.action" method="post" class="border p-4 rounded">

            <div class="alert alert-warning mt-3">
                ※ この操作は取り消すことができません。<br>
                あなたのアカウント "<c:out value='${admin_id}'/>" を削除します。本当に削除しますか？
            </div>

            <div class="d-flex gap-3 mt-4">
                <button type="submit" class="btn btn-danger">削除する</button>
                <a href="admin_menu.jsp" class="btn btn-secondary">戻る</a>
            </div>
        </form>
    </div>
    </c:param>
</c:import>
