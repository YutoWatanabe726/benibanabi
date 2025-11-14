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

  <!-- ヘッダー読込 -->
  <jsp:include page="/common/header.jsp" />

  <!-- 各ページの中身 -->
  <main>
    ${param.content}
  </main>

  <!-- フッター読込 -->
  <jsp:include page="/common/footer.jsp" />

</body>
</html>
