<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="ja">

<head>
<meta charset="UTF-8">
<title>名産品の追加｜管理者画面</title>

<link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">

<style>
/* ===============================
      管理画面レイアウト
=============================== */
.admin-wrapper {
  max-width: 900px;
  margin: 120px auto 60px;
  background: #fff;
  padding: 40px 50px;
  border-radius: 20px;
  box-shadow: 0 6px 25px rgba(0,0,0,0.12);
}

/* タイトル */
.admin-wrapper h2 {
  font-size: 2rem;
  font-weight: 900;
  color: #D92929;
  margin-bottom: 30px;
}

/* 入力フォーム */
.form-group {
  margin-bottom: 20px;
}

.form-group label {
  font-weight: 700;
  display: block;
  margin-bottom: 6px;
  font-size: 1.05rem;
}

.form-group input[type="text"],
.form-group textarea,
.form-group select {
  width: 100%;
  padding: 12px 14px;
  font-size: 1rem;
  border: 1px solid #ccc;
  border-radius: 12px;
  outline: none;
  transition: 0.25s;
}

.form-group input:focus,
.form-group textarea:focus,
.form-group select:focus {
  border-color: #D92929;
  box-shadow: 0 0 8px rgba(217,41,41,0.25);
}

/* 画像アップロード */
.form-group input[type="file"] {
  border: none;
  padding: 5px;
}

/* 送信ボタン */
.submit-btn {
  margin-top: 28px;
  width: 100%;
  padding: 16px 0;
  font-size: 1.2rem;
  color: white;
  font-weight: 800;
  border: none;
  border-radius: 14px;
  background: linear-gradient(90deg, #FFB35E, #D92929);
  box-shadow: 0 8px 18px rgba(217,41,41,0.32);
  cursor: pointer;
  transition: 0.3s;
}

.submit-btn:hover {
  transform: translateY(-3px);
  box-shadow: 0 12px 22px rgba(217,41,41,0.45);
}
</style>

</head>

<body>

<jsp:include page="/common/header.jsp" />

<div class="admin-wrapper">

  <h2>名産品を追加する</h2>

  <!-- ★ 画像アップロードがあるので multipart/form-data 必須 -->
  <form action="souvenir_add_action.jsp" method="POST" enctype="multipart/form-data">

    <!-- 名産品名 -->
    <div class="form-group">
      <label>名産品名</label>
      <input type="text" name="name" required placeholder="例：尾花沢スイカ">
    </div>

    <!-- 説明 -->
    <div class="form-group">
      <label>説明文</label>
      <textarea name="description" rows="4" required placeholder="名産品の特徴を入力してください"></textarea>
    </div>

    <!-- 外部リンク -->
    <div class="form-group">
      <label>公式・外部リンク</label>
      <input type="text" name="link" placeholder="https://www.example.com/">
    </div>

    <!-- 季節 -->
    <div class="form-group">
      <label>季節カテゴリ</label>
      <select name="season">
        <option value="spring">🌸 春</option>
        <option value="summer">🌻 夏</option>
        <option value="autumn">🍁 秋</option>
        <option value="winter">❄ 冬</option>
      </select>
    </div>

    <!-- 画像アップロード -->
    <div class="form-group">
      <label>画像アップロード</label>
      <input type="file" name="image" accept="image/*" required>
    </div>

    <button type="submit" class="submit-btn">登録する</button>

  </form>
</div>

<jsp:include page="/common/footer.jsp" />

</body>
</html>
