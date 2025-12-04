<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>

<c:import url="/common/admin_base.jsp">
    <c:param name="title">観光スポット更新</c:param>
    <c:param name="content">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/admin_spot_topics_souvenir_all.css">
    <div class="container mt-4">
        <h2 class="mb-4">観光スポット更新</h2>

        <c:if test="${not empty error}">
            <div class="alert alert-danger">${error}</div>
        </c:if>

        <form action="AdminSpotUpdateExecute.action" method="post" enctype="multipart/form-data" class="form">
            <input type="hidden" name="spotId" value="${spot.spotId}"/>

            <!-- 観光スポット名 -->
            <div class="mb-3">
                <label class="form-label">観光スポット名（必須）</label>
                <input type="text" name="spotName" class="form-control" required placeholder="例:○○温泉"
                       value="${spot.spotName}">
            </div>

            <!-- 説明 -->
            <div class="mb-3">
                <label class="form-label">観光スポット説明</label>
                <textarea name="description" class="form-control" rows="4">${spot.description}</textarea>
            </div>

			<!-- 写真アップロード -->
			<div class="mb-3">
			    <label class="form-label">観光スポット写真</label>
			    <input type="file" name="spotPhoto" accept="image/*" class="form-control">
			    <small>＊変更がない場合は現在の写真が適応されます</small>
			</div>

			<!-- 現在の写真表示-->
			<div class="mb-3">
				<label class="form-label">現在の観光スポット写真</label>
			    <c:if test="${not empty spot.spotPhoto}">
			        <div class="mt-2">
			            <img src="${pageContext.request.contextPath}${spot.spotPhoto}"
			                 alt="current photo" style="max-width:200px;">
			            <input type="hidden" name="oldPhoto" value="${spot.spotPhoto}">
			        </div>
			    </c:if>
			</div>

            <!-- エリア（地区） -->
            <div class="mb-3">
                <label class="form-label">地区（必須）</label>
                <select name="district" id="areaSelect" class="form-control" required>
                    <option value="">選択してください</option>
                    <option value="庄内地区" <c:if test="${spot.area=='鶴岡市' or spot.area=='酒田市' or spot.area=='庄内町' or spot.area=='遊佐町' or spot.area=='三川町'}">selected</c:if>>庄内地区</option>
                    <option value="最上地区" <c:if test="${spot.area=='新庄市' or spot.area=='最上町' or spot.area=='金山町' or spot.area=='舟形町' or spot.area=='真室川町'}">selected</c:if>>最上地区</option>
                    <option value="村山地区" <c:if test="${spot.area=='山形市' or spot.area=='上山市' or spot.area=='天童市' or spot.area=='寒河江市' or spot.area=='村山市' or spot.area=='尾花沢市' or spot.area=='東根市' or spot.area=='河北町' or spot.area=='中山町' or spot.area=='山辺町' or spot.area=='朝日町' or spot.area=='大江町'}">selected</c:if>>村山地区</option>
                    <option value="置賜地区" <c:if test="${spot.area=='米沢市' or spot.area=='長井市' or spot.area=='南陽市' or spot.area=='高畠町' or spot.area=='川西町' or spot.area=='小国町' or spot.area=='白鷹町' or spot.area=='飯豊町'}">selected</c:if>>置賜地区</option>
                </select>
            </div>

            <!-- 市町村 -->
            <div class="mb-3">
                <label class="form-label">市町村（必須）</label>
                <select name="city" id="citySelect" class="form-control" required>
                    <option value="${spot.area}" selected>${spot.area}</option>
                </select>
            </div>

            <!-- 住所 -->
            <div class="mb-3">
                <label class="form-label">住所(番地以降)(必須)</label>
                <input type="text" name="address" class="form-control" required placeholder="例：○○町0-00-00"
                       value="${spot.address}">
            </div>

            <!-- タグ -->
            <div class="mb-3">
                <label class="form-label">タグ（複数選択可）</label><br>
                <c:forEach var="tag" items="${tagList}">
                    <label class="form-check-label me-3">
                        <input type="checkbox" name="tags" value="${tag.tagId}" class="form-check-input"
                               <c:if test="${spotTagIds != null and spotTagIds.contains(tag.tagId)}">checked</c:if>>
                        ${tag.tagName}
                    </label>
                </c:forEach>
            </div>

            <div class="text-center mt-4">
                <button type="submit" class="btn btn-primary px-4">更新</button>
                <a href="AdminSpotList.action">戻る</a>
            </div>
        </form>
    </div>

    <!-- JS：エリア選択に応じて市町村を切り替える -->
    <script type="text/javascript">
        const areaCities = {
            "庄内地区": ["鶴岡市","酒田市","庄内町","遊佐町","三川町"],
            "最上地区": ["新庄市","最上町","金山町","舟形町","真室川町"],
            "村山地区": ["山形市","上山市","天童市","寒河江市","村山市","尾花沢市","東根市","河北町","中山町","山辺町","朝日町","大江町"],
            "置賜地区": ["米沢市","長井市","南陽市","高畠町","川西町","小国町","白鷹町","飯豊町"]
        };

        const areaSelect = document.getElementById("areaSelect");
        const citySelect = document.getElementById("citySelect");

        areaSelect.addEventListener("change", function() {
            const area = this.value;
            citySelect.innerHTML = "";

            if (area === "") {
                const option = document.createElement("option");
                option.value = "";
                option.text = "先にエリアを選択してください";
                citySelect.appendChild(option);
                return;
            }

            areaCities[area].forEach(function(city){
                const option = document.createElement("option");
                option.value = city;
                option.text = city;
                citySelect.appendChild(option);
            });
        });
    </script>
    </c:param>
</c:import>
