<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<c:import url="/common/admin_base.jsp">
    <c:param name="title">名産品編集</c:param>

    <c:param name="content">
    <div class="container mt-4">
        <h2 class="mb-4">名産品編集</h2>

        <c:if test="${not empty error}">
            <div class="alert alert-danger">${error}</div>
        </c:if>

        <form action="AdminSouvenirUpdateExecute.action" method="post"
              enctype="multipart/form-data" class="form">

            <input type="hidden" name="souvenirId" value="${souvenir.souvenirId}">

            <!-- 名産品名 -->
            <div class="mb-3">
                <label class="form-label">名産品名（必須）</label>
                <input type="text" name="souvenirName" class="form-control"
                       required placeholder="例：さくらんぼ"
                       value="${souvenir.souvenirName}">
            </div>

            <!-- 説明 -->
            <div class="mb-3">
                <label class="form-label">名産品説明</label>
                <textarea name="souvenirContent" class="form-control" rows="4">${souvenir.souvenirContent}</textarea>
            </div>

            <!-- 四季 -->
            <div class="mb-3">
                <label class="form-label">四季（必須）</label>
                <select name="souvenirSeasons" class="form-control" required>
                    <option value="">選択してください</option>
                    <option value="春" <c:if test="${souvenir.souvenirSeasons=='春'}">selected</c:if>>春</option>
                    <option value="夏" <c:if test="${souvenir.souvenirSeasons=='夏'}">selected</c:if>>夏</option>
                    <option value="秋" <c:if test="${souvenir.souvenirSeasons=='秋'}">selected</c:if>>秋</option>
                    <option value="冬" <c:if test="${souvenir.souvenirSeasons=='冬'}">selected</c:if>>冬</option>
                </select>
            </div>

            <!-- 写真アップロード -->
            <div class="mb-3">
                <label class="form-label">名産品写真</label>
                <input type="file" name="souvenirPhoto" accept="image/*" class="form-control">
                <small>＊変更がない場合は現在の写真が適応されます</small>
            </div>

            <!-- 現在の写真表示 -->
            <div class="mb-3">
                <label class="form-label">現在の名産品写真</label>
                <c:if test="${not empty souvenir.souvenirPhoto}">
                    <div class="mt-2">
                        <img src="${pageContext.request.contextPath}${souvenir.souvenirPhoto}"
                             alt="current photo" style="max-width:200px;">
                        <input type="hidden" name="oldPhoto" value="${souvenir.souvenirPhoto}">
                    </div>
                </c:if>
            </div>

            <div class="text-center mt-4">
                <button type="submit" class="btn btn-primary px-4">更新</button>
                <a href="AdminSouvenirSetting.action" class="btn btn-link">戻る</a>
            </div>
        </form>
    </div>
    </c:param>
</c:import>
