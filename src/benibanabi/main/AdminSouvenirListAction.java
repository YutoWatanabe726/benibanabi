package benibanabi.main;

import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import bean.Souvenir;
import dao.SouvenirDAO;
import tool.Action;

public class AdminSouvenirListAction extends Action {
    @Override
    public void execute(HttpServletRequest req, HttpServletResponse res) throws Exception {

        // リクエストパラメータで季節を取得
        String season = req.getParameter("season");

        SouvenirDAO dao = new SouvenirDAO();
        List<Souvenir> list;

        if (season != null && !season.isEmpty()) {
            // 季節指定があればその季節だけ取得
            list = dao.getBySeason(season);
        } else {
            // 指定なしなら全件取得
            list = dao.getAll();
        }

        req.setAttribute("souvenirList", list);
        req.getRequestDispatcher("admin_souvenir_list.jsp").forward(req, res);
    }
}
