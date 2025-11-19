package benibanabi.main;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import tool.Action;

public class CourseAction extends Action {

    @Override
    public void execute(HttpServletRequest req, HttpServletResponse res) throws Exception {

        String courseTitle = req.getParameter("courseTitle");
        String tripDaysParam = req.getParameter("tripDays");
        int tripDays = Integer.parseInt(tripDaysParam);
        String startPoint = req.getParameter("startPoint");
        String address = req.getParameter("address");
        String startTime = req.getParameter("startTime");

        req.setAttribute("courseTitle", courseTitle);
        req.setAttribute("tripDays", tripDays);
        req.setAttribute("startPoint", startPoint);
        req.setAttribute("address", address);
        req.setAttribute("startTime", startTime);

        req.getRequestDispatcher("CourseSpot.jsp").forward(req, res);
    }
}
