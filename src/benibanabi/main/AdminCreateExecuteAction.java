package benibanabi.main;

import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import bean.Admin;
import dao.AdminDAO;
import tool.Action;

public class AdminCreateExecuteAction extends Action {

    @Override
    public void execute(HttpServletRequest req, HttpServletResponse res) throws Exception {

        String admin_id = req.getParameter("id");
        String admin_password = req.getParameter("password");

        Admin adminBean = new Admin();
        adminBean.setId(admin_id);
        adminBean.setPassword(admin_password);

        AdminDAO adminDAO = new AdminDAO();
        List<String> errors = new ArrayList<>();   // ★ここをListに変更

        // ▼ 入力チェック
        if(admin_id == null || admin_id.isEmpty()){
            errors.add("管理者IDを入力してください");
        }
        if(admin_password == null || admin_password.isEmpty()){
            errors.add("パスワードを入力してください");
        }

        // ▼ エラーあり → 画面戻す
        if(!errors.isEmpty()){
            req.setAttribute("errors", errors);
            req.setAttribute("admin", adminBean);
            req.getRequestDispatcher("admin_create.jsp").forward(req, res);
            return;
        }

        try{
            // ▼ DB 登録（ID重複時は Exception）
            adminDAO.createAdmin(admin_id, admin_password);
            req.getRequestDispatcher("admin_create_done.jsp").forward(req, res);

        }catch(Exception e){
            // ▼ ID重複時 → 1行だけ出したいとの希望仕様
            errors.add("指定された管理者IDは既に存在しています。");
            req.setAttribute("errors", errors);
            req.setAttribute("admin", adminBean);
            req.getRequestDispatcher("admin_create.jsp").forward(req, res);
        }
    }
}
