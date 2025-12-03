<%-- 管理者削除JSP --%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<c:import url="/common/admin_base.jsp">
    <c:param name="title">
        管理者アカウント削除
    </c:param>

    <c:param name="content">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/admin_login_logout_password_delete.css" />
	<form action="AdminDeleteExecute.action" method="post" style="flex:1;">
	    <div id="wrap_box">
	    <h2>管理者アカウント削除</h2>
	        <c:if test="${not empty errorMessage}">
	            <div class="alert alert-danger">${errorMessage}</div>
	        </c:if>
	        <div class="alert alert-warning mt-3">
	            ※ この操作は取り消すことができません。<br>
	            あなたのアカウント "<c:out value='${admin_id}'/>" を削除します。本当に削除しますか？
	        </div>
	        <div class="button-group">
	            <input type="submit" value="削除する" class="btn-danger" />
				<a href="AdminMenu.action">戻る</a>
	        </div>
	    </div>
	</form>
    </c:param>
</c:import>
