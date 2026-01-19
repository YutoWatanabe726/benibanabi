<%-- 管理者タグ削除 確認JSP（タグ名表示・中央揃え・カード風） --%>
<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<c:import url="/common/admin_base.jsp">
  <c:param name="title">タグ削除</c:param>

  <c:param name="content">
    <link
      rel="stylesheet"
      href="${pageContext.request.contextPath}/css/admin_spot_topics_souvenir_all.css"
    >

    <div class="container">
      <h2>タグ削除</h2>

      <p>以下のタグを削除します。よろしいですか？</p>

      <!-- タグ名表示（中央・カード風） -->
      <div style="display: flex; flex-direction: column; align-items: center; gap: 10px; margin: 20px 0;">
        <c:forEach var="tag" items="${tagList}">
          <div style="display: flex;align-items: center;width: 100%;max-width: 350px;padding: 10px 16px;border-radius: 12px;justify-content: center;align-items: center; ">
            <div style="width: 80px; font-weight: bold;">タグ名：</div>
            <div>${tag.tagName}</div>
          </div>
        </c:forEach>
      </div>

      <form action="AdminTagDeleteExecute.action" method="post">
        <c:forEach var="tag" items="${tagList}">
          <input
            type="hidden"
            name="tagIds"
            value="${tag.tagId}"
          >
        </c:forEach>

        <div class="button-group mt-3">
          <button type="submit" class="btn btn-danger">削除する</button>
          <a href="AdminTagList.action">戻る</a>
        </div>
      </form>
    </div>
  </c:param>
</c:import>
