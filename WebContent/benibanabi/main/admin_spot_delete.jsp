<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<c:import url="/common/admin_base.jsp">
    <c:param name="title">管理者観光スポット削除</c:param>

    <c:param name="content">
    <div class="container mt-4">
        <h2 class="mb-4">管理者観光スポット削除</h2>

        <p>以下のスポットを削除します。よろしいですか？</p>

        <div class="border p-3 mb-4 bg-light">
            <p><b>スポット名：</b> ${spot.spotName}</p>
            <p><b>エリア：</b> ${spot.area}</p>
        </div>

        <form action="AdminSpotDeleteExecute.action" method="post" class="border p-4 rounded">
            <input type="hidden" name="spotId" value="${spot.spotId}">
            <div class="d-flex gap-3 mt-4">
                <button type="submit" class="btn btn-danger">削除する</button>
                <a href="AdminSpotSetting.action" class="btn btn-secondary">戻る</a>
            </div>
        </form>
    </div>
    </c:param>
</c:import>
