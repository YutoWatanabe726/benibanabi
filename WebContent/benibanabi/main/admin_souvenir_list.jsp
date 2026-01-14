<%-- 管理者名産品一覧JSP --%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<c:import url="/common/admin_base.jsp">
    <c:param name="title">管理者名産品一覧</c:param>

    <c:param name="content">

        <!-- ✅ 一覧専用CSS 読み込み（戻るボタン右配置対応） -->
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/admin_spot_topics_souvenir_list.css">

        <div class="container mt-4">
            <h2>管理者名産品一覧</h2>

            <!-- ✅ 右上配置される戻るボタン -->
            <a href="AdminSouvenirSetting.action">戻る</a>

            <!-- ▼ 四季プルダウン（自動送信） -->
            <form method="get" action="AdminSouvenirList.action" class="mt-3">
                <label for="seasonSelect">四季指定：</label>
                <select name="season" id="seasonSelect" onchange="this.form.submit()">
                    <option value="">すべて</option>
                    <option value="春" <c:if test="${param.season=='春'}">selected</c:if>>春</option>
                    <option value="夏" <c:if test="${param.season=='夏'}">selected</c:if>>夏</option>
                    <option value="秋" <c:if test="${param.season=='秋'}">selected</c:if>>秋</option>
                    <option value="冬" <c:if test="${param.season=='冬'}">selected</c:if>>冬</option>
                </select>
            </form>

            <!-- ▼ 名産品一覧 -->
            <c:if test="${not empty souvenirList}">
                <table class="table table-bordered mt-4">
                    <thead>
                        <tr>
                            <th>四季</th>
                            <th>名産品名</th>
                            <th>操作</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="souvenir" items="${souvenirList}">
                            <tr>
                                <td>${souvenir.souvenirSeasons}</td>
                                <td>${souvenir.souvenirName}</td>
                                <td>
                                    <a href="AdminSouvenirUpdate.action?souvenirId=${souvenir.souvenirId}"
                                       class="btn btn-sm btn-primary">
                                        編集
                                    </a>
                                </td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </c:if>

            <c:if test="${empty souvenirList}">
                <p class="mt-4">表示する名産品がありません。</p>
            </c:if>

        </div>
    </c:param>
</c:import>
