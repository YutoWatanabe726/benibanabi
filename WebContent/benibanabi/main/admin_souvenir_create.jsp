<%-- 管理者名産品新規作成JSP --%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<c:import url="/common/admin_base.jsp">
    <c:param name="title">名産品新規作成</c:param>

    <c:param name="content">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/admin_spot_topics_souvenir_all.css">
    <div class="container mt-4">
        <h2 class="mb-4">名産品新規作成</h2>

        <c:if test="${not empty error}">
            <div class="alert alert-danger">${error}</div>
        </c:if>

        <form action="AdminSouvenirCreateExecute.action" method="post"
              enctype="multipart/form-data" class="form">

            <!-- 名産品名 -->
            <div class="mb-3">
                <label class="form-label">名産品名（必須）</label>
                <input type="text" name="souvenirName" class="form-control" required placeholder="例：さくらんぼ">
            </div>

            <!-- 説明 -->
            <div class="mb-3">
                <label class="form-label">名産品説明</label>
                <textarea name="souvenirContent" class="form-control" rows="4"  maxlength="50" placeholder="50文字以内で入力してください"></textarea>
            </div>

            <!-- 四季 -->
            <div class="mb-3">
                <label class="form-label">四季（必須）</label>
                <select name="souvenirSeasons" class="form-control" required>
                    <option value="">選択してください</option>
                    <option value="春">春</option>
                    <option value="夏">夏</option>
                    <option value="秋">秋</option>
                    <option value="冬">冬</option>
                </select>
            </div>

            <!-- 写真アップロード -->
            <div class="mb-3">
                <label class="form-label">名産品写真</label>
                <input type="file" name="souvenirPhoto" accept="image/*" class="form-control">
            </div>

            <div class="text-center mt-4">
                <button type="submit" class="btn btn-primary px-4">登録</button>
                <a href="AdminSouvenirList.action" class="btn btn-link">戻る</a>
            </div>
        </form>
    </div>
    </c:param>
</c:import>
