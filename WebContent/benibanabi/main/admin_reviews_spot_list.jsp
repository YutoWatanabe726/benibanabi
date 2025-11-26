<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<!DOCTYPE html>
<html lang="ja">
<head>
<meta charset="UTF-8">
<title>観光スポット一覧</title>

<link rel="stylesheet" href="${pageContext.request.contextPath}/css/admin_reviews_spot_list.css">

</head>

<body>

<h1>観光スポット一覧</h1>

<a href="AdminMenu.action" class="btn btn-secondary">戻る</a>

<div class="search-box">
  <form action="${pageContext.request.contextPath}/benibanabi/main/AdminReviewsSpotList.action" method="get">
      <input type="text" name="keyword" placeholder="スポット名で検索" value="${param.keyword}">
      <button type="submit">検索</button>
  </form>
</div>

<c:choose>
    <c:when test="${empty spotList}">
        <p>現在、登録されているスポットはありません。</p>
    </c:when>

    <c:otherwise>
        <div class="spot-container">
            <c:forEach var="sp" items="${spotList}">
                <div class="spot-card">
                    <h3>${sp.spotName}</h3>
                    <p>エリア: ${sp.area}</p>

                    <a href="${pageContext.request.contextPath}/benibanabi/main/AdminReviews.action?spotId=${sp.spotId}">
                        口コミを見る
                    </a>
                </div>
            </c:forEach>
        </div>
    </c:otherwise>
</c:choose>

</body>
</html>
