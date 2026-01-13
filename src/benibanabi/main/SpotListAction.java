package benibanabi.main;

import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import bean.Spot;
import bean.Tag;
import constant.PaginationConst;
import dao.SpotDAO;
import dao.TagDAO;
import tool.Action;

/**
 * 観光スポット一覧（ページネーション対応）
 */
public class SpotListAction extends Action {

    // 1ページあたりの表示件数
    private static final int PAGE_SIZE = PaginationConst.PAGE_SIZE;

    @Override
    public void execute(HttpServletRequest req, HttpServletResponse res) throws Exception {

        req.setCharacterEncoding("UTF-8");

        // ===============================
        // ページ番号取得
        // ===============================
        int currentPage = 1;
        String pageStr = req.getParameter("page");
        if (pageStr != null && pageStr.matches("\\d+")) {
            currentPage = Integer.parseInt(pageStr);
        }

        int offset = (currentPage - 1) * PAGE_SIZE;

        // ===============================
        // DAO
        // ===============================
        SpotDAO sDao = new SpotDAO();

        // 全件数
        int totalCount = sDao.countAll();

        // 総ページ数
        int totalPages = (int) Math.ceil((double) totalCount / PAGE_SIZE);
        if (totalPages == 0) totalPages = 1;

        // ページ分のデータ取得
        List<Spot> spotList = sDao.findByPage(PAGE_SIZE, offset);

        TagDAO tDao = new TagDAO();
        ArrayList<Tag> tagAllList = tDao.findAllTags();

        // ===============================
        // JSPへ渡す
        // ===============================
        req.setAttribute("spotList", spotList);
        req.setAttribute("tagAllList", tagAllList);

        req.setAttribute("currentPage", currentPage);
        req.setAttribute("totalPages", totalPages);

        // 検索条件初期値
        req.setAttribute("keyword", "");
        req.setAttribute("selectedAreas", new ArrayList<String>());
        req.setAttribute("selectedTags", new ArrayList<String>());
        req.setAttribute("favoriteOnly", "");

        // ===============================
        // forward
        // ===============================
        req.getRequestDispatcher("/benibanabi/main/spot_list.jsp")
           .forward(req, res);
    }
}
