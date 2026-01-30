package benibanabi.main;

import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import bean.Reviews;
import bean.Spot;
import bean.Tag;
import dao.ReviewsDAO;
import dao.SpotDAO;
import dao.TagDAO;
import tool.Action;

public class SpotDetailAction extends Action {

	@Override
	public void execute(HttpServletRequest req, HttpServletResponse res) throws Exception {

	    req.setCharacterEncoding("UTF-8");

	    // ------------------------------
	    // 1. パラメータ取得
	    // ------------------------------
	    String sid = req.getParameter("spot_id");
	    if (sid == null) {
	        return;
	    }

	    int spotId = Integer.parseInt(sid);

	    // ★★★ ここから追加 ★★★
	    String pageStr = req.getParameter("page");
	    int page = 1;
	    if (pageStr != null && !pageStr.isEmpty()) {
	        page = Integer.parseInt(pageStr);
	    }
	    req.setAttribute("page", page);
	    // ★★★ ここまで追加 ★★★

	    // ------------------------------
	    // 2. DAO 呼び出し
	    // ------------------------------
	    SpotDAO spotDao = new SpotDAO();
	    Spot spot = spotDao.findById(spotId);

	    if (spot == null) {
	        return;
	    }

	    TagDAO tagDao = new TagDAO();
	    ArrayList<Tag> tagList = tagDao.findTagsBySpotId(spotId);

	    ReviewsDAO reviewsDao = new ReviewsDAO();
	    List<Reviews> reviewList = reviewsDao.findBySpotId(spotId);

	    // ------------------------------
	    // 3. request にセット
	    // ------------------------------
	    req.setAttribute("spot", spot);
	    req.setAttribute("tagList", tagList);
	    req.setAttribute("reviewList", reviewList);

	    // ------------------------------
	    // 4. JSP へフォワード
	    // ------------------------------
	    req.getRequestDispatcher("/benibanabi/main/spot_detail.jsp").forward(req, res);
	}
}
