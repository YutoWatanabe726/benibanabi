<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<!DOCTYPE html>
<html lang="ja">
<head>
<meta charset="UTF-8">
<title>名産品の追加</title>
</head>

<body>

<jsp:include page="/common/header.jsp" />

<div class="admin-wrapper">
  <h2>名産品を追加する</h2>

  <form action="${pageContext.request.contextPath}/benibanabi/main/AdminSouvenirCreateExecute.action"
        method="post" enctype="multipart/form-data">

    <div class="form-group">
      <label>商品名</label>
      <input type="text" name="name" required>
    </div>

    <div class="form-group">
      <label>説明</label>
      <textarea name="description" rows="5" required></textarea>
    </div>

    <div class="form-group">
      <label>価格</label>
      <input type="text" name="price">
    </div>

    <div class="form-group">
      <label>画像</label>
      <input type="file" name="image" accept="image/*">
    </div>

    <button class="submit-btn">登録する</button>
  </form>
</div>

</body>
</html>
