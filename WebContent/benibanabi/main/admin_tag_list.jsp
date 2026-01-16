<%-- 管理者タグ一覧JSP（ピル型・クリック選択） --%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<c:import url="/common/admin_base.jsp">
  <c:param name="title">管理者タグ一覧</c:param>

  <c:param name="content">

    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/admin_tag_list.css">

    <div class="container mt-4">
      <h2>管理者タグ一覧</h2>
      <a href="AdminTagSetting.action">戻る</a>

      <form action="AdminTagDeleteExecute.action" method="post"
            onsubmit="return confirm('選択したタグを削除しますか？');">

        <div class="tag-container">
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

        <div class="mt-4">
          <button type="submit" class="btn btn-danger">
            選択したタグを削除
          </button>
        </div>
      </form>
    </div>

  </c:param>
</c:import>
