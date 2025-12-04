<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<c:import url="/common/admin_base.jsp">
    <c:param name="title">観光スポット一覧</c:param>

    <c:param name="content">

        <!-- CSS 共通 -->
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/admin_spot_topics_souvenir_list.css">

        <div class="container mt-4">
            <h2>観光スポット一覧</h2>

            <!-- 右上戻るボタン -->
            <a href="AdminMenu.action">戻る</a>

            <!-- 左寄せ検索バー -->
            <div class="search-box">
                <form action="${pageContext.request.contextPath}/benibanabi/main/AdminReviewsSpotList.action" method="get">
                    <input type="text" name="keyword" placeholder="スポット名で検索" value="${param.keyword}">
                    <button type="submit">検索</button>
                </form>
            </div>

            <!-- スポット一覧テーブル -->
            <c:choose>
                <c:when test="${empty spotList}">
                    <p>現在、登録されているスポットはありません。</p>
                </c:when>

                <c:otherwise>
                    <table class="table table-bordered mt-3">
                        <thead>
                            <tr>
                                <th>スポット名</th>
                                <th>エリア</th>
                                <th>操作</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="sp" items="${spotList}">
                                <tr>
                                    <td>${sp.spotName}</td>
                                    <td>${sp.area}</td>
                                    <td>
                                        <a href="${pageContext.request.contextPath}/benibanabi/main/AdminReviews.action?spotId=${sp.spotId}" class="btn btn-sm btn-primary">
                                            口コミを見る
                                        </a>
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </c:otherwise>
            </c:choose>

        </div>
    </c:param>
</c:import>
