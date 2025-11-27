<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<c:import url="/common/admin_base.jsp">
    <c:param name="title">管理者トピックス一覧</c:param>

    <c:param name="content">
        <div class="container mt-4">
            <h2>管理者トピックス一覧</h2>
            <a href="AdminTopicsSetting.action">戻る</a>

<!-- ▼ 年選択プルダウン -->
<form method="get" class="mt-3">
    <label for="yearSelect">年で絞り込み：</label>
    <select name="year" id="yearSelect" onchange="this.form.submit()">
        <c:forEach var="y" items="${years}">
            <option value="${y}" <c:if test="${y == selectedYear}">selected</c:if>>
                ${y}年
            </option>
        </c:forEach>
    </select>
</form>


<!-- ▼ 現在掲載中 -->
<h4 class="mt-4">現在掲載中のトピックス</h4>
<c:if test="${not empty ongoingTopics}">
<table class="table table-bordered mt-2">
<thead>
<tr>
    <th>掲載開始日</th>
    <th>イベント開始日</th>
    <th>イベント終了日</th>
    <th>トピックス内容</th>
    <th>市町村</th>
    <th>操作</th>
</tr>
</thead>
<tbody>
<c:forEach var="t" items="${ongoingTopics}">
<tr>
    <td>${t.formattedPublicationDate}</td>
    <td>${t.formattedStartDate}</td>
    <td>${t.formattedEndDate}</td>
    <td>${t.topicsContent}</td>
    <td>${t.topicsArea}</td>
    <td>
        <a href="AdminTopicsUpdate.action?id=${t.topicsId}" class="btn btn-sm btn-primary">編集</a>
    </td>
</tr>
</c:forEach>
</tbody>
</table>
</c:if>
<c:if test="${empty ongoingTopics}">
    <p>現在掲載中のトピックスはありません。</p>
</c:if>



<!-- ▼ 掲載期間外 -->
<h4 class="mt-5">掲載期間外のトピックス</h4>
<c:if test="${not empty expiredTopics}">
<table class="table table-bordered mt-2">
<thead>
<tr>
    <th>掲載開始日</th>
    <th>イベント開始日</th>
    <th>イベント終了日</th>
    <th>トピックス内容</th>
    <th>市町村</th>
    <th>操作</th>
</tr>
</thead>
<tbody>
<c:forEach var="t" items="${expiredTopics}">
<tr>
    <td>${t.formattedPublicationDate}</td>
    <td>${t.formattedStartDate}</td>
    <td>${t.formattedEndDate}</td>
    <td>${t.topicsContent}</td>
    <td>${t.topicsArea}</td>
    <td>
        <a href="AdminTopicsUpdate.action?id=${t.topicsId}" class="btn btn-sm btn-primary">編集</a>
    </td>
</tr>
</c:forEach>
</tbody>
</table>
</c:if>
<c:if test="${empty expiredTopics}">
    <p>掲載期間外のトピックスはありません。</p>
</c:if>

</div>
</c:param>
</c:import>
