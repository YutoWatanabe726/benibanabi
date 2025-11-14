/*package benibanabi;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import tool.Action;

public class courseAction extends Action {

    @Override
    public void execute(HttpServletRequest req, HttpServletResponse res) throws Exception {
        // フォームの値をローカル変数として取得
        String courseTitle = req.getParameter("courseTitle");   // コースタイトル
        int tripDays = req.getParameter("tripDays");         // 旅行期間（日数）
        String startPoint = req.getParameter("startPoint");     // スタート地点
        String address = req.getParameter("address");           // 任意住所
        String startTime = req.getParameter("startTime");       // 観光開始時間

        // JSPに渡すためにリクエスト属性として設定
        req.setAttribute("courseTitle", courseTitle);
        req.setAttribute("tripDays", tripDays);
        req.setAttribute("startPoint", startPoint);
        req.setAttribute("address", address);
        req.setAttribute("startTime", startTime);

        // spot_list.jsp にフォワード
        req.getRequestDispatcher("spot_list.jsp").forward(req, res);
    }
}*/


package benibanabi.main;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import tool.Action;

public class CourseAction extends Action {

    @Override
    public void execute(HttpServletRequest req, HttpServletResponse res) throws Exception {

        // フォームの値を取得
        String courseTitle = req.getParameter("courseTitle");
        String tripDaysParam = req.getParameter("tripDays");
        int tripDays = Integer.parseInt(req.getParameter("tripDays"));
        String startPoint = req.getParameter("startPoint");
        String address = req.getParameter("address");
        String startTime = req.getParameter("startTime");

        // JSPに渡す
        req.setAttribute("courseTitle", courseTitle);
        req.setAttribute("tripDays", tripDays);
        req.setAttribute("startPoint", startPoint);
        req.setAttribute("address", address);
        req.setAttribute("startTime", startTime);

        // spot_list.jsp にフォワード
        req.getRequestDispatcher("spot_list.jsp").forward(req, res);
    }
}