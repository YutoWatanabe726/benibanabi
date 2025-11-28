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

        // ▼ リクエストパラメータ取得
        String publicationDateStr = req.getParameter("publicationDate");
        String startDateStr       = req.getParameter("startDate");
        String endDateStr         = req.getParameter("endDate");
        String topicsContent      = req.getParameter("topicsContent");
        String city               = req.getParameter("city");

        // ▼ 日付変換
        Date publicationDate = Date.valueOf(publicationDateStr);
        Date startDate       = Date.valueOf(startDateStr);
        Date endDate         = Date.valueOf(endDateStr);


     // ▼ バリデーション: 終了日が掲載開始日より前の場合
        if (endDate.before(publicationDate)) {
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

        // ▼ Topics Bean 作成
        Topics t = new Topics();
        t.setTopicsPublicationDate(publicationDate);
        t.setTopicsStartDate(startDate);
        t.setTopicsEndDate(endDate);
        t.setTopicsContent(topicsContent);
        t.setTopicsArea(city);

        // ▼ DAO で登録
        TopicsDAO dao = new TopicsDAO();
        dao.insert(t);

        // ▼ 登録完了画面へ
        req.getRequestDispatcher("admin_topics_create_done.jsp").forward(req, res);
    }
}
