<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<!DOCTYPE html>
<html lang="ja">
<head>
<meta charset="UTF-8">
<title>観光スポット一覧</title>

<style>
  body { font-family: "Noto Sans JP", sans-serif; background-color: #f9f9f9; color: #333; margin: 0; padding: 20px; }
  .spot-container { display: flex; flex-wrap: wrap; gap: 20px; }
  .spot-card { background: #fff; border-radius: 8px; box-shadow: 0 2px 6px rgba(0,0,0,0.1); width: 250px; text-align: center; padding: 10px; }
  .spot-card h3 { margin: 10px 0 5px; font-size: 1.2em; }
  .spot-card p { margin: 5px 0; font-size: 0.9em; color: #666; }
  .spot-card a { display: inline-block; margin: 10px 0; padding: 6px 12px; background-color: #0066cc; color: #fff; text-decoration: none; border-radius: 4px; }
  .spot-card a:hover { background-color: #004999; }
</style>
</head>

<body>
<h1>観光スポット一覧</h1>
<a href="${pageContext.request.contextPath}/benibanabi/main/admin_menu.jsp">← 管理メニューに戻る</a>

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
