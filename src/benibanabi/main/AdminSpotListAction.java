package benibanabi.main;

import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import bean.Spot;
import dao.SpotDAO;
import tool.Action;

public class AdminSpotListAction extends Action {

    @Override
    public void execute(HttpServletRequest req, HttpServletResponse res) throws Exception {

        // SpotDAOを使用してスポット一覧取得
        SpotDAO dao = new SpotDAO();
        List<Spot> spotList = dao.searchSpots(null, null, null);

        // JSP に渡す
        req.setAttribute("spotList", spotList);

        // admin_spot_list.jsp にフォワード
        req.getRequestDispatcher("/benibanabi/main/admin_spot_list.jsp").forward(req, res);
    }
}
