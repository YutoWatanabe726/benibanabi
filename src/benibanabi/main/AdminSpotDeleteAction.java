package benibanabi.main;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import bean.Spot;
import tool.Action;

public class AdminSpotDeleteAction extends Action {

    @Override
    public void execute(HttpServletRequest req, HttpServletResponse res) throws Exception {
        // リクエストパラメータから削除対象IDを取得
        String spotIdStr = req.getParameter("spotId");
        if (spotIdStr == null || spotIdStr.isEmpty()) {
            throw new Exception("削除対象IDが指定されていません");
        }

        int spotId = Integer.parseInt(spotIdStr);

        // DAOからスポット情報を取得（最低限の情報だけ取得）
        Spot spot = new Spot();
        spot.setSpotId(spotId);
        spot.setSpotName(req.getParameter("spotName"));
        spot.setArea(req.getParameter("area"));


        req.setAttribute("spot", spot);

        // 削除確認画面へ
        req.getRequestDispatcher("admin_spot_delete.jsp").forward(req, res);
    }
}
