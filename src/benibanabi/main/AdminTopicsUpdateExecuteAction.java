package benibanabi.main;

import java.sql.Date;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import bean.Topics;
import dao.TopicsDAO;
import tool.Action;

public class AdminTopicsUpdateExecuteAction extends Action {

    @Override
    public void execute(HttpServletRequest req, HttpServletResponse res) throws Exception {

        // リクエストパラメータ取得
        String idStr = req.getParameter("topicsId");
        String pubDateStr = req.getParameter("publicationDate");
        String startDateStr = req.getParameter("startDate");
        String endDateStr = req.getParameter("endDate");
        String content = req.getParameter("topicsContent");
        String city = req.getParameter("city"); // ← 市町村だけ保存

        if (idStr == null || idStr.isEmpty()) {
            req.setAttribute("error", "トピックスIDが指定されていません。");
            req.getRequestDispatcher("AdminTopicsList.action").forward(req, res);
            return;
        }

        int topicsId = Integer.parseInt(idStr);

        // 日付変換
        Date pubDate = (pubDateStr != null && !pubDateStr.isEmpty()) ? Date.valueOf(pubDateStr) : null;
        Date startDate = (startDateStr != null && !startDateStr.isEmpty()) ? Date.valueOf(startDateStr) : null;
        Date endDate = (endDateStr != null && !endDateStr.isEmpty()) ? Date.valueOf(endDateStr) : null;


        // ▼ バリデーション: 終了日が掲載開始日より前の場合
        if (endDate.before(pubDate)) {
            // エラー内容をリクエスト属性にセット
            req.setAttribute("error", "掲載開始日より前の日付に設定はできません");
            // 再表示（作成画面に戻す）
            req.getRequestDispatcher("admin_topics_create.jsp").forward(req, res);
            return; // 以降処理は中断
        }

        // ▼ バリデーション: 終了日が開始日より前の場合
        if (endDate.before(startDate)) {
            // エラー内容をリクエスト属性にセット
            req.setAttribute("error", "イベント開始日より前の日付に設定はできません");
            // 再表示（作成画面に戻す）
            req.getRequestDispatcher("admin_topics_create.jsp").forward(req, res);
            return; // 以降処理は中断
        }

        // Topics Bean 作成
        Topics topics = new Topics();
        topics.setTopicsId(topicsId);
        topics.setTopicsPublicationDate(pubDate);
        topics.setTopicsStartDate(startDate);
        topics.setTopicsEndDate(endDate);
        topics.setTopicsContent(content);
        topics.setTopicsArea(city); // 市町村だけ保存

        // DB 更新
        TopicsDAO dao = new TopicsDAO();
        int result = dao.update(topics);

        if (result == 1) {
            // 更新成功 → 完了ページへ
            req.getRequestDispatcher("admin_topics_update_done.jsp").forward(req, res);
        } else {
            // 更新失敗
            req.setAttribute("error", "更新に失敗しました。");
            req.setAttribute("topics", topics);
            req.getRequestDispatcher("admin_topics_update.jsp").forward(req, res);
        }
    }
}
