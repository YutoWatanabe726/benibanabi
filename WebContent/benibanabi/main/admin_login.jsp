<%-- 管理者ログインJSP --%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<c:import url="/common/admin_base.jsp">
	<c:param name="title">
		管理者ログイン
	</c:param>

	<c:param name="content">
    	<link rel="stylesheet" href="${pageContext.request.contextPath}/css/admin_login_logout_password_delete.css" />

        <!-- ★ 追加：jQuery読み込み（これだけ追加） -->
        <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>

		<section class="w-75 text-center m-auto border pb-3">
			<form action="AdminLoginExecute.action" method="post">

				<h2 class="h3 mb-3 fw-norma bg-secondary bg-opacity-10 py-2">ログイン</h2>

				<c:if test="${errors.size()>0}">
					<div>
						<ul>
							<c:forEach var="error" items="${errors}">
								<li>${error}</li>
							</c:forEach>
						</ul>
					</div>
				</c:if>

				<div>
					<!-- ＩＤ -->
					<div class="form-floating mx-5">
						<label>ＩＤ</label>
						<input class="form-control px-5 fs-5" autocomplete="off"
							id="id-input" maxlength="20" name="id"
							placeholder="半角でご入力下さい"
							style="ime-mode: disabled" type="text"
							value="${id}" required />
					</div>

					<!-- パスワード -->
					<div class="form-floating mx-5 mt-3">
						<label>パスワード</label>
						<input class="form-control px-5 fs-5" autocomplete="off"
							id="password-input" maxlength="20" name="password"
							placeholder="20文字以内の半角英数字でご入力下さい"
							style="ime-mode: disabled"
							type="password" required />
					</div>

					<div class="form-check mt-3">
						<label class="form-check-label" for="password-display">
							<input class="form-check-input"
								id="password-display"
								name="chk_d_ps"
								type="checkbox" />
							パスワードを表示
						</label>
					</div>
				</div>

				<script type="text/javascript">
					$(function() {
						$('#password-display').change(function() {
							if ($(this).prop('checked')) {
								$('#password-input').attr('type', 'text');
							} else {
								$('#password-input').attr('type', 'password');
							}
						});
					});
				</script>

				<div class="button-group">
					<a href="AdminCreate.action" class="btn-secondary">新規作成</a>
					<input type="submit" value="ログイン" />
				</div>

			</form>
		</section>
	</c:param>
</c:import>
