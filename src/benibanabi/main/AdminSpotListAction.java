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

        SpotDAO dao = new SpotDAO();
        List<Spot> list = dao.findAll();

        req.setAttribute("spotList", list);

        req.getRequestDispatcher("admin_spot_list.jsp").forward(req, res);
    }
}
