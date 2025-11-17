package benibanabi.main;

import java.util.HashMap;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import bean.Admin;
import dao.AdminDAO;
import tool.Action;

public class AdminCreateExecuteAction extends Action {

	@Override
	public void execute(HttpServletRequest req, HttpServletResponse res) throws Exception {

		// ローカル変数の指定 1
		HttpSession session = req.getSession(); // セッション
		Admin admin = (Admin)session.getAttribute("user");

		String admin_id = "";
		String admin_password = "";

		AdminDAO adminDAO = new AdminDAO();
		Admin adminBean = new Admin();
		Map<String, String> errors = new HashMap<>(); // エラーメッセージ

		// リクエストパラメーターの取得 2
		admin_id = req.getParameter("id");
		admin_password = req.getParameter("password");

		// DBからデータ取得 3
		// なし

		// ビジネスロジック 4
		adminBean.setId(admin_id);
		adminBean.setPassword(admin_password);
		adminDAO.createAdmin(admin_id,admin_password);

		// レスポンス値をセット 6
		// リクエストに入学年度をセット

		// JSPへフォワード 7
		if (errors.isEmpty()) { // エラーメッセージがない場合
			// 登録完了画面にフォワード
			req.getRequestDispatcher("admin_create_done.jsp").forward(req, res);
		} else { // エラーメッセージがある場合
			// 登録画面にフォワード
			req.getRequestDispatcher("AdminCreate.action").forward(req, res);
		}
	}

}
