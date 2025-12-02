<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<c:import url="/common/admin_base.jsp">
    <c:param name="title">管理者名産品一覧</c:param>

    <c:param name="content">
        <div class="container mt-4">
            <h2>管理者名産品一覧</h2>
            <a href="AdminSouvenirSetting.action" class="btn btn-link mb-3">戻る</a>

            <!-- ▼ 四季プルダウン（自動送信） -->
            <form method="get" action="AdminSouvenirList.action" id="seasonForm" class="mb-3">
                <select name="season" class="form-control" style="width:150px; display:inline-block;"
                        onchange="document.getElementById('seasonForm').submit();">
                    <option value="">すべて</option>
                    <option value="春" <c:if test="${param.season=='春'}">selected</c:if>>春</option>
                    <option value="夏" <c:if test="${param.season=='夏'}">selected</c:if>>夏</option>
                    <option value="秋" <c:if test="${param.season=='秋'}">selected</c:if>>秋</option>
                    <option value="冬" <c:if test="${param.season=='冬'}">selected</c:if>>冬</option>
                </select>
            </form>

            <!-- ▼ 名産品表示 -->
            <table class="table table-bordered">
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
                                <a href="AdminSouvenirUpdate.action?souvenirId=${souvenir.souvenirId}" class="btn btn-sm btn-primary">編集</a>
                            </td>
                        </tr>
                    </c:forEach>
                </tbody>
            </table>
        </div>
    </c:param>
</c:import>
