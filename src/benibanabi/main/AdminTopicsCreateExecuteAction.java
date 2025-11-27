package benibanabi.main;

import java.sql.Date;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import bean.Topics;
import dao.TopicsDAO;
import tool.Action;

public class AdminTopicsCreateExecuteAction extends Action {

    @Override
    public void execute(HttpServletRequest req, HttpServletResponse res) throws Exception {

        req.setCharacterEncoding("UTF-8");

        // ▼ フォーム値取得
        String topicsDateStr   = req.getParameter("topicsDate");
        String topicsContent   = req.getParameter("topicsContent");
        String city            = req.getParameter("city");

        // ▼ 日付処理（空なら今日）
        Date topicsDate;
        try {
            if (topicsDateStr != null && !topicsDateStr.isEmpty()) {
                topicsDate = Date.valueOf(topicsDateStr);
            } else {
                topicsDate = new Date(System.currentTimeMillis());
            }
        } catch (IllegalArgumentException e) {
            topicsDate = new Date(System.currentTimeMillis());
        }

        // ▼ 内容チェック
        if (topicsContent == null || topicsContent.trim().isEmpty()) {
            req.setAttribute("error", "トピックス内容を入力してください");
            req.getRequestDispatcher("admin_topics_create.jsp").forward(req, res);
            return;
        }

        // ▼ Beanにセット
        Topics topics = new Topics();
        topics.setTopicsDate(topicsDate);
        topics.setTopicsContent(topicsContent);
        topics.setTopicsArea(city);

        // ▼ DAOで登録
        TopicsDAO dao = new TopicsDAO();
        int result = dao.insert(topics);

        // ▼ 成功/失敗処理
        if(result == 1) {
            req.getRequestDispatcher("admin_topics_create_done.jsp").forward(req, res);
        } else {
            req.setAttribute("error", "登録に失敗しました");
            req.getRequestDispatcher("admin_topics_create.jsp").forward(req, res);
        }
    }
}
