<%-- 管理者タグ新規作成JSP --%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<c:import url="/common/admin_base.jsp">
    <c:param name="title">タグ新規作成</c:param>

    <c:param name="content">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/admin_spot_topics_souvenir_all.css">

        <div class="container mt-4">
            <h2 class="mb-4">タグ新規作成</h2>

            <form action="AdminTagCreateExecute.action" method="post">
                <div class="mb-3">
                    <label for="tagName" class="form-label">タグ名</label>
                    <input
                        type="text"
                        name="tagName"
                        id="tagName"
                        class="form-control"
                        required
                        maxlength="50"
                    >
                </div>

                <div class="button-group">
                    <button type="submit" class="btn btn-primary">登録</button>
                    <a href="AdminTagSetting.action" class="btn btn-secondary">戻る</a>
                </div>
            </form>
        </div>
    </c:param>
</c:import>
