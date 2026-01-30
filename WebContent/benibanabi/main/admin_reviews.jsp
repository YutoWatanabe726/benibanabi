<%-- 管理者観光スポット口コミ一覧JSP --%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="bean.Reviews" %>
<%@ page import="bean.Spot" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<c:import url="/common/admin_base.jsp">
    <c:param name="title">管理者用口コミ一覧</c:param>

    <c:param name="content">

        <!-- 共通CSS -->
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/admin_spot_topics_souvenir_list.css">

        <div class="container mt-4">
            <%
                String error = (String) request.getAttribute("error");
                Spot spot = (Spot) request.getAttribute("spot");
                List<Reviews> reviews = (List<Reviews>) request.getAttribute("reviews");

                if (error != null) {
            %>
                <p><%= error %></p>
            <%
                    return;
                }

                if (spot == null) {
            %>
                <p>スポットが見つかりません。</p>
            <%
                    return;
                }
            %>

            <h2>「<%= spot.getSpotName() %>」の口コミ一覧</h2>

            <!-- 右上戻るボタン -->
          	<a href="${pageContext.request.contextPath}/benibanabi/main/AdminReviewsSpotList.action" class="btn-back-only">戻る</a>
            <c:choose>
                <c:when test="${reviews == null || reviews.isEmpty()}">
                    <p class="mt-3">このスポットにはまだ口コミがありません。</p>
                </c:when>

                <c:otherwise>
                    <table class="table table-bordered mt-3">
                        <thead>
                            <tr>
                                <th>内容</th>
                                <th>投稿日</th>
                                <th>操作</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="rv" items="${reviews}">
                                <tr>
                                    <td>${rv.reviewText}</td>
                                    <td>${rv.reviewDate}</td>
                                    <td>
                                        <form method="post" action="${pageContext.request.contextPath}/benibanabi/main/AdminDeleteReview.action"
                                              onsubmit="return confirm('本当に削除しますか？');">
                                            <input type="hidden" name="reviewId" value="${rv.reviewId}">
                                            <input type="hidden" name="spotId" value="${spot.spotId}">
                                            <button type="submit" class="btn btn-sm btn-danger">削除</button>
                                        </form>
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
