<%-- 管理者アカウント新規作成JSP--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<c:import url="/common/admin_base.jsp">
    <c:param name="title">新規作成</c:param>

    <c:param name="content">
    	<link rel="stylesheet" href="${pageContext.request.contextPath}/css/admin_login_logout_password_delete.css" />
    <div class="container mt-4">
        <h2 class="mb-4">新規作成</h2>

        <form action="AdminCreateExecute.action" method="post" class="form">

            <!-- ▼ エラー表示（List<String>対応） -->
            <c:if test="${not empty errors}">
                <div class="alert alert-danger">
                    <ul class="mb-0">
                        <c:forEach var="error" items="${errors}">
                            <li>${error}</li>
                        </c:forEach>
                    </ul>
                </div>
            </c:if>

            <div class="mb-3">
                <label for="id" class="form-label">管理者ID</label>
                <input type="text" id="id" name="id" class="form-control"
                       value="<c:out value='${admin.id}'/>" required>
            </div>

            <div class="mb-3">
                <label for="password" class="form-label">パスワード</label>
                <input type="password" id="password" name="password" class="form-control"
                       value="<c:out value='${admin.password}'/>" required>
            </div>

            <div class="d-flex mt-4">
                <button type="submit" class="btn btn-primary me-3">登録</button>
                <a href="AdminLogin.action" class="btn btn-secondary">戻る</a>
            </div>

        </form>
    </div>
    </c:param>
</c:import>
