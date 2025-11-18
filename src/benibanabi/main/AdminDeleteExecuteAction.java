package benibanabi.main;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import bean.Admin;
import dao.AdminDAO;
import tool.Action;

public class AdminDeleteExecuteAction extends Action {

    @Override
    public void execute(HttpServletRequest req, HttpServletResponse res) throws Exception {

        HttpSession session = req.getSession();
        Admin currentAdmin = (Admin) session.getAttribute("admin");

        if (currentAdmin == null) {
            req.setAttribute("errorMessage", "ログインしていません。");
            req.getRequestDispatcher("login.jsp").forward(req, res);
            return;
        }

        // 修正：Admin クラスの getter に合わせる
        String adminId = currentAdmin.getId();
        AdminDAO adminDAO = new AdminDAO();

        try {
            adminDAO.deleteAdmin(adminId);
            session.invalidate(); // 自分のアカウント削除なのでセッション破棄
            req.getRequestDispatcher("admin_delete_done.jsp").forward(req, res);
        } catch (Exception e) {
            req.setAttribute("errorMessage", "削除処理でエラーが発生しました: " + e.getMessage());
            req.getRequestDispatcher("admin_delete.jsp").forward(req, res);
        }
    }
}
