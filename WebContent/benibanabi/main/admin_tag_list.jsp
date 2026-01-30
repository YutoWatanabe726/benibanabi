<%-- 管理者タグ一覧JSP（新規作成・削除） --%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<c:import url="/common/admin_base.jsp">
  <c:param name="title">管理者タグ一覧</c:param>

  <c:param name="content">

    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/admin_tag_list.css">

    <div class="container mt-4">

      <!-- 上部操作ボタン -->
      <div class="top-actions">
        <a href="AdminTagCreate.action" class="btn-create">新規作成</a>
        <a href="AdminMenu.action" class="btn-back">戻る</a>
      </div>

      <h2>管理者タグ一覧</h2>

      <!-- エラーメッセージ表示 -->
      <c:if test="${not empty error}">
        <div class="alert alert-danger mt-3">
          ${error}
        </div>
      </c:if>

      <!-- タグが存在する場合 -->
      <c:if test="${not empty tagList}">
        <form action="AdminTagDelete.action" method="post">

          <div class="tag-container mt-3">
            <c:forEach var="tag" items="${tagList}">
              <div class="tag-item">
                <input
                  type="checkbox"
                  name="tagIds"
                  id="tag_${tag.tagId}"
                  value="${tag.tagId}"
                >
                <label for="tag_${tag.tagId}" class="tag-label">
                  ${tag.tagName}
                </label>
              </div>
            </c:forEach>
          </div>

          <div class="mt-5">
            <button type="submit" class="btn btn-danger">
              選択したタグを削除
            </button>
          </div>
        </form>
      </c:if>

      <!-- タグが存在しない場合 -->
      <c:if test="${empty tagList}">
        <div class="alert alert-info mt-3">
          登録されているタグはありません。
        </div>
      </c:if>

    </div>

  </c:param>
</c:import>
