<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<!DOCTYPE html>
<html lang="ja">
<head>
<meta charset="UTF-8">
<title>名産品の追加</title>

<link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">

<style>
  .admin-wrapper {
    max-width: 900px;
    margin: 120px auto;
    padding: 40px;
    background: #fff;
    border-radius: 20px;
    box-shadow: 0 8px 26px rgba(0,0,0,0.12);
  }
  .form-group { margin-bottom: 20px; }
  .form-group label { font-weight:bold; display:block; margin-bottom:6px; }
  input[type="text"], textarea {
    width: 100%;
    padding: 10px;
    border: 1px solid #ccc;
    border-radius: 8px;
  }
  .submit-btn {
    margin-top: 20px;
    background: #D92929;
    color: #fff;
    padding: 14px 25px;
    border: none;
    border-radius: 10px;
    cursor:pointer;
    font-size:1rem;
  }
</style>

</head>

<body>

<jsp:include page="/common/header.jsp" />

<div class="admin-wrapper">
  <h2>名産品を追加する</h2>

  <!-- ★重要：Action方式 -->
  <form action="AdminSouvenirCreateExecute.action" method="post" enctype="multipart/form-data">

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

<jsp:include page="/common/footer.jsp" />

</body>
</html>
