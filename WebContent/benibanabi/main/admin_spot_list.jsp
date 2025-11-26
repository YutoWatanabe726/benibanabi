<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:import url="/common/admin_base.jsp">
    <c:param name="title">管理者観光スポット一覧</c:param>

    <c:param name="content">
        <div class="container mt-4">
            <h2>管理者観光スポット一覧</h2>

            <table class="table table-bordered mt-3">
                <thead>
                    <tr>
                        <th>スポット名</th>
                        <th>エリア</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="s" items="${spotList}">
                        <tr>
                            <td>${s.spotName}</td>
                            <td>${s.area}</td>
                            <td>
                                <a href="AdminSpotUpdate.action?id=${s.spotId}" class="btn btn-sm btn-primary">編集</a>
                                <a href="AdminSpotDelete.action?spotId=${s.spotId}&spotName=${s.spotName}&area=${s.area}" class="btn btn-sm btn-danger">削除</a>

                            </td>
                        </tr>
                    </c:forEach>
                </tbody>
            </table>
        </div>
    </c:param>
</c:import>
