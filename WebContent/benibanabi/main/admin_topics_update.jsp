<%-- 管理者トピックス編集JSP --%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<c:import url="/common/admin_base.jsp">
    <c:param name="title">トピックス編集</c:param>
    <c:param name="content">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/admin_spot_topics_souvenir_all.css">
<div class="container mt-4">
    <h2 class="mb-4">トピックス編集</h2>

    <c:if test="${not empty error}">
        <div class="alert alert-danger">${error}</div>
    </c:if>

    <form action="AdminTopicsUpdateExecute.action" method="post" class="form">
        <input type="hidden" name="topicsId" value="${topics.topicsId}">

        <!-- 掲載開始日 -->
        <div class="mb-3">
            <label class="form-label">掲載開始日（必須）</label>
            <input type="date" name="publicationDate" class="form-control"
                   value="${topics.topicsPublicationDate}" required>
        </div>

        <!-- イベント開始日 -->
        <div class="mb-3">
            <label class="form-label">イベント開始日（必須）</label>
            <input type="date" name="startDate" class="form-control"
                   value="${topics.topicsStartDate}" required>
        </div>

        <!-- イベント終了日 -->
        <div class="mb-3">
            <label class="form-label">イベント終了日（必須）</label>
            <input type="date" name="endDate" class="form-control"
                   value="${topics.topicsEndDate}" required>
            <small>＊イベント終了日が掲載の終了日にもなります。</small>
        </div>

        <!-- トピックス内容 -->
        <div class="mb-3">
            <label class="form-label">トピックス内容（必須）</label>
            <textarea name="topicsContent" class="form-control" rows="4" required>${topics.topicsContent}</textarea>
        </div>

        <!-- 地区選択 -->
        <div class="mb-3">
            <label class="form-label">地区（必須）</label>
            <select name="district" id="areaSelect" class="form-control" required>
                <option value="">選択してください</option>
                <option value="庄内地区">庄内地区</option>
                <option value="最上地区">最上地区</option>
                <option value="村山地区">村山地区</option>
                <option value="置賜地区">置賜地区</option>
            </select>
        </div>

        <!-- 市町村 -->
        <div class="mb-3">
            <label class="form-label">市町村（必須）</label>
            <select name="city" id="citySelect" class="form-control" required>
                <option value="">先に地区を選択してください</option>
            </select>
        </div>

        <div class="text-center mt-4">
            <button type="submit" class="btn btn-primary px-4">更新</button>
            <a href="AdminTopicsList.action" class="ms-3">戻る</a>
        </div>
    </form>
</div>

<script type="text/javascript">
const areaCities = {
    "庄内地区": ["鶴岡市","酒田市","庄内町","遊佐町","三川町"],
    "最上地区": ["新庄市","最上町","金山町","舟形町","真室川町"],
    "村山地区": ["山形市","上山市","天童市","寒河江市","村山市","尾花沢市","東根市","河北町","中山町","山辺町","朝日町","大江町"],
    "置賜地区": ["米沢市","長井市","南陽市","高畠町","川西町","小国町","白鷹町","飯豊町"]
};

const areaSelect = document.getElementById("areaSelect");
const citySelect = document.getElementById("citySelect");

// 既存市町村
const initialCity = "${topics.topicsArea}";

// 初期地区を市町村から逆算
let initialArea = "";
for (const area in areaCities) {
    if (areaCities[area].includes(initialCity)) {
        initialArea = area;
        break;
    }
}

// 市町村選択肢セット関数
function setCityOptions(area, selectedCity) {
    citySelect.innerHTML = "";
    if (!area) {
        const option = document.createElement("option");
        option.value = "";
        option.text = "先に地区を選択してください";
        citySelect.appendChild(option);
        return;
    }
    areaCities[area].forEach(city => {
        const option = document.createElement("option");
        option.value = city;
        option.text = city;
        if (city === selectedCity) option.selected = true;
        citySelect.appendChild(option);
    });
}

// 初期値セット
areaSelect.value = initialArea;
setCityOptions(initialArea, initialCity);

// 選択変更時の処理
areaSelect.addEventListener("change", function() {
    setCityOptions(this.value, "");
});
</script>

    </c:param>
</c:import>
