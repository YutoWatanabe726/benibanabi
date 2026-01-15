package benibanabi.main;

import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import bean.Souvenir;
import dao.SouvenirDAO;
import tool.Action;

public class SouvenirAction extends Action {

    @Override
    public void execute(HttpServletRequest req, HttpServletResponse res) throws Exception {

        // 季節取得
        String season = req.getParameter("season");

        // ▼ 初期アクセス時は「春」
        if (season == null || season.isEmpty()) {
            season = "春";
        }

        SouvenirDAO dao = new SouvenirDAO();
        List<Souvenir> list = dao.getBySeason(season);

        // JSP用
        req.setAttribute("souvenirList", list);
        req.setAttribute("season", season);

        // 表示
        req.getRequestDispatcher("souvenir.jsp").forward(req, res);
    }
}
