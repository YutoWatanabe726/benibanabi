<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<c:import url="/common/admin_base.jsp">
    <c:param name="title">観光スポット更新完了</c:param>

    <c:param name="content">
        <div class="container mt-4">
            <h2>観光スポット更新完了</h2>
            <p>更新が完了しました。</p>
            <a href="AdminSpotSetting.action" class="btn btn-primary">管理者観光スポット一覧へ</a>
            <a href="admin_menu.jsp" class="btn btn-secondary">管理者メニューへ</a>
        </div>
    </c:param>
</c:import>
