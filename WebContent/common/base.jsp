<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<!DOCTYPE html>
<html lang="ja">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>${param.title}</title>
  <style>
  .page-container {
  padding-top: 80px;
}</style>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
  <link rel="icon" href="${pageContext.request.contextPath}/favicon.ico">
</head>

<body>

  <!-- ヘッダー読込 -->
  <jsp:include page="/common/header.jsp" />

  <!-- 各ページの中身 -->
  <main class="page-container">
  ${param.content}
  </main>


  <!-- フッター読込 -->
  <jsp:include page="/common/footer.jsp" />

</body>
</html>


<script>
document.addEventListener('DOMContentLoaded', () => {

  const targets = document.querySelectorAll('.fade-up, .fade-left, .fade-right, .fade-zoom');
  const options = { threshold: 0.15 };

  const observer = new IntersectionObserver(entries => {
    entries.forEach(entry => {
      if (entry.isIntersecting) {
        entry.target.classList.add('show');
        observer.unobserve(entry.target);
      }
    });
  }, options);

  targets.forEach(el => observer.observe(el));
});
</script>
