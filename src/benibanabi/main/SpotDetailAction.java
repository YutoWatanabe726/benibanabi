package benibanabi.main;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import bean.Reviews;
import bean.Spot;
import bean.Tag;
import dao.ReviewsDAO;
import dao.SpotDAO;
import dao.TagDAO;

public class SpotDetailAction extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        // ------------------------------
        // 1. パラメータ取得
        // ------------------------------
        String sid = request.getParameter("spot_id");
        if (sid == null) {
            response.sendRedirect("SpotList.action");
            return;
        }

        int spotId = Integer.parseInt(sid);

        try {

            // ------------------------------
            // 2. スポット本体を取得
            // ------------------------------
            SpotDAO spotDao = new SpotDAO();
            Spot spot = spotDao.findById(spotId);

            if (spot == null) {
                response.sendRedirect("SpotList.action");
                return;
            }

            // ------------------------------
            // 3. スポットのタグ一覧を取得
            // ------------------------------
            TagDAO tagDao = new TagDAO();
            ArrayList<Tag> tagList = tagDao.findTagsBySpotId(spotId);

            // ------------------------------
            // 4. 口コミ一覧を取得
            // ------------------------------
            ReviewsDAO reviewsDao = new ReviewsDAO();
            List<Reviews> reviewList = reviewsDao.findBySpotId(spotId);

            // ------------------------------
            // 5. JSP へ渡す
            // ------------------------------
            request.setAttribute("spot", spot);
            request.setAttribute("tagList", tagList);
            request.setAttribute("reviewList", reviewList);

            RequestDispatcher rd =
                request.getRequestDispatcher("/main/spot_detail.jsp");

            rd.forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            throw new ServletException("SpotDetailAction の処理で例外が発生しました。");
        }
    }
}
