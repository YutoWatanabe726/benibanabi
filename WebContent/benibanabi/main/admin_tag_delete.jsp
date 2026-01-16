<%-- 管理者タグ削除JSP --%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<c:import url="/common/admin_base.jsp">
    <c:param name="title">タグ削除</c:param>

    <c:param name="content">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/admin_spot_topics_souvenir_all.css">
        <form action="AdminSpotDeleteExecute.action" method="post" class="border p-4 rounded">
            <input type="hidden" name="spotId" value="${spot.spotId}">
    <div class="container mt-4">
        <h2 class="mb-4">タグ削除</h2>

        <p>以下のスポットを削除します。よろしいですか？</p>

            <p><b>スポット名：</b> ${spot.spotName}</p>

            <div class="button-group">
                <button type="submit" class="btn btn-danger">削除</button>
                <a href="AdminSpotList.action">戻る</a>
            </div>

    </div>
            </form>
    </c:param>
</c:import>
