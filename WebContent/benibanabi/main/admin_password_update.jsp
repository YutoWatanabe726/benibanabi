<%-- 管理者パスワード更新JSP --%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<c:import url="/common/admin_base.jsp">
    <c:param name="title">管理者パスワード変更</c:param>

    <c:param name="content">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/admin_login_logout_password_delete.css" />
    <div class="container mt-4">
        <h2 class="mb-4">管理者パスワード変更</h2>

        <!-- エラーメッセージ -->
        <c:if test="${not empty error}">
            <div class="alert alert-danger">${error}</div>
        </c:if>

        <form action="AdminPasswordUpdateExecute.action" method="post" class="w-50">

			<div class="alert alert-warning mb-3">
				ログイン中のアカウント"<c:out value='${admin_id}'/>"
            </div>


            <!-- 現在のパスワード -->
            <div class="mb-3">
                <label for="currentPass" class="form-label">現在のパスワード</label>
                <input type="password" id="currentPass" name="currentPass" class="form-control" required>
            </div>

            <!-- 新しいパスワード -->
            <div class="mb-3">
                <label for="newPass" class="form-label">新しいパスワード</label>
                <input type="password" id="newPass" name="newPass" class="form-control" required>
            </div>

            <!-- 新しいパスワード（確認） -->
            <div class="mb-3">
                <label for="newPass2" class="form-label">新しいパスワード（確認）</label>
                <input type="password" id="newPass2" name="newPass2" class="form-control" required>
            </div>
 			<div class="button-group">
	            <button type="submit" class="btn btn-primary">変更する</button>
	            <a href="AdminMenu.action" class="btn btn-secondary">戻る</a>
			</div>
        </form>

    </div>

    </c:param>
</c:import>
