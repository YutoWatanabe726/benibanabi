<%-- 管理者観光スポット一覧(編集・削除)JSP --%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:import url="/common/admin_base.jsp">
    <c:param name="title">管理者観光スポット一覧</c:param>

    <c:param name="content">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/admin_spot_topics_souvenir_list.css">
        <div class="container mt-4">
            <h2>管理者観光スポット一覧</h2>
			<a href="AdminSpotSetting.action">戻る</a>

			<div class="search-box">
			  <form action="${pageContext.request.contextPath}/benibanabi/main/AdminSpotList.action" method="get">
			      <input type="text" name="keyword" placeholder="スポット名で検索" value="${param.keyword}">
			      <button type="submit">検索</button>
			  </form>
			</div>

            <table class="table table-bordered mt-3">
                <thead>
                    <tr>
                        <th>スポット名</th>
                        <th>エリア</th>
                        <th>操作</th>
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
