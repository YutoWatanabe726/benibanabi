<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<!DOCTYPE html>
<html lang="ja">
<head>
  <meta charset="UTF-8">
  <title>${param.title}</title>

  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>

<body>

  <!-- 各ページの中身 -->
  <main>
    ${param.content}
  </main>

</body>
</html>
