<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ja">
<head>
<meta charset="UTF-8">
<title>スタート地点設定</title>
<style>
body { font-family: Arial, sans-serif; background:#f5f7fa; margin:0; padding:0; }
header { background:#2563eb; color:#fff; text-align:center; padding:16px; font-size:1.4rem; }
main { max-width:500px; margin:2rem auto; background:#fff; padding:20px; border-radius:12px; box-shadow:0 2px 8px rgba(0,0,0,0.1); }
label { display:block; margin-top:1rem; font-weight:bold; }
input[type="text"], input[type="number"], input[type="time"] { width:100%; padding:8px; margin-top:4px; border-radius:6px; border:1px solid #ccc; }
.radio-group { margin-top:0.5rem; }
.radio-group label { display:inline-block; margin-right:1rem; font-weight:normal; }
button { margin-top:20px; width:100%; padding:10px; font-size:1.1rem; font-weight:bold; background:#2563eb; color:#fff; border:none; border-radius:8px; cursor:pointer; }
button:hover { background:#1e4fd6; }
</style>
</head>
<body>
<header>スタート地点設定</header>
<main>
  <!-- サーブレットにPOST送信 -->
  <form id="startForm" action="courseAction" method="post">
    <label for="courseTitle">コースタイトル</label>
    <input type="text" id="course-title" name="courseTitle" placeholder="例：山形名所巡りコース" required />

    <label>旅行期間（日数）</label>
    <input type="number" id="trip-days" name="tripDays" min="1" max="30" value="1" required />

    <label>スタート地点</label>
    <div class="radio-group">
      <label><input type="radio" name="startPoint" value="山形駅" checked /> 山形駅</label>
      <label><input type="radio" name="startPoint" value="山形空港" /> 山形空港</label>
    </div>

    <label for="address">任意の住所を入力</label>
    <input type="text" id="address" name="address" placeholder="例：山形県山形市七日町1-2-3" />

    <label for="start-time">観光開始時間</label>
    <input type="time" id="start-time" name="startTime" value="09:00" required />

    <button type="submit">スタート地点を設定</button>
  </form>
</main>
</body>
</html>
