package benibanabi.main;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import dao.SpotAdminDAO;
import tool.Action;

public class AdminSpotDeleteExecuteAction extends Action {

    @Override
    public void execute(HttpServletRequest req, HttpServletResponse res) throws Exception {
        String spotIdStr = req.getParameter("spotId");
        if (spotIdStr == null || spotIdStr.isEmpty()) {
            throw new Exception("削除対象IDが指定されていません");
        }

        int spotId = Integer.parseInt(spotIdStr);

        // DAOを使って削除
        SpotAdminDAO dao = new SpotAdminDAO();
        dao.deleteSpotWithTagsAndReviews(spotId);

        // 削除完了画面へ
        req.getRequestDispatcher("admin_spot_delete_done.jsp").forward(req, res);
    }
}
