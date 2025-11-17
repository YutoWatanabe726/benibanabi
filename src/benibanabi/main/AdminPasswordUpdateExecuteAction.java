package benibanabi.main;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import bean.Admin;
import dao.AdminDAO;
import tool.Action;

public class AdminPasswordUpdateExecuteAction extends Action {

    @Override
    public void execute(HttpServletRequest req, HttpServletResponse res) throws Exception {

        // ▼ ローカル変数
        String currentPass = "";
        String newPass = "";
        String newPass2 = "";
        String error = "";

        HttpSession session = req.getSession();
        Admin admin = (Admin)session.getAttribute("user");


        // ▼ リクエストパラメータ取得
        currentPass = req.getParameter("currentPass");
        newPass = req.getParameter("newPass");
        newPass2 = req.getParameter("newPass2");

        AdminDAO dao = new AdminDAO();

        // ▼ ビジネスロジック：入力チェック
        if (!newPass.equals(newPass2)) {
            error = "新しいパスワードが一致しません。";
        } else if (!dao.login(admin.getId(), currentPass)) {
            error = "現在のパスワードが違います。";
        }

        // ▼ エラーがあれば元画面へ戻す
        if (!error.isEmpty()) {
            req.setAttribute("error", error);
            req.getRequestDispatcher("admin_password_update.jsp").forward(req, res);
            return;
        }

        // ▼ パスワード更新
        dao.changePassword(admin.getId(), newPass);

        // ▼ 完了画面へ
        req.getRequestDispatcher("admin_password_update_done.jsp").forward(req, res);
    }
}
