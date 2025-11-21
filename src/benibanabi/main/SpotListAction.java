package benibanabi.main;

import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import bean.Spot;
import bean.Tag;
import dao.SpotDAO;
import dao.TagDAO;
import tool.Action;

/**
 * 観光スポット一覧の初期表示
 */
public class SpotListAction extends Action {

    @Override
    public void execute(HttpServletRequest req, HttpServletResponse res) throws Exception {

        req.setCharacterEncoding("UTF-8");

        // --- DAO 呼び出し ---
        SpotDAO sDao = new SpotDAO();
        List<Spot> spotList = sDao.findAll();

        TagDAO tDao = new TagDAO();
        ArrayList<Tag> tagAllList = tDao.findAllTags();

        // --- 検索条件の初期値 ---
        req.setAttribute("spotList", spotList);
        req.setAttribute("tagAllList", tagAllList);

        req.setAttribute("keyword", "");
        req.setAttribute("selectedAreas", new ArrayList<String>());
        req.setAttribute("selectedTags", new ArrayList<String>());
        req.setAttribute("favoriteOnly", "");

        // --- JSP へフォワード ---
        req.getRequestDispatcher("/benibanabi/main/spot_list.jsp").forward(req, res);
    }
}
