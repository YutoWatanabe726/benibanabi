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

        // ▼ セッション（ログイン中の管理者）
        HttpSession session = req.getSession();
        Admin admin = (Admin) session.getAttribute("admin");

        // ▼ リクエストパラメータ（削除対象の管理者ID）
        String id = req.getParameter("admin_id");

        // ▼ DAO の準備
        AdminDAO adminDAO = new AdminDAO();

        // ▼ IDが null でない場合のみ削除
        if(id != null && !id.isEmpty()){
            adminDAO.deleteAdmin(id);   // ← IDで削除する
            req.getRequestDispatcher("admin_delete_done.jsp").forward(req, res);
        } else {
            // IDが無い場合 → エラー画面へ
            req.getRequestDispatcher("admin_delete.jsp").forward(req, res);
        }
    }
}
