package benibanabi.main;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import bean.Admin;
import tool.Action;

public class AdminSpotSettingAction extends Action {

	@Override
	public void execute(HttpServletRequest req, HttpServletResponse res) throws Exception {

		HttpSession session = req.getSession(); // セッション
		Admin admin = (Admin)session.getAttribute("admin");

		// ローカル変数の指定 1

		// リクエストパラメーターの取得 2
		// なし

		// DBからデータ取得 3
		// ログインユーザーの学校コードをもとにクラス番号の一覧を取得


		// ビジネスロジック 4
		// リストを初期化


		// レスポンス値をセット 6
		// リクエストにデータをセット


		// JSPへフォワード 7
		req.getRequestDispatcher("admin_spot_setting.jsp").forward(req, res);
	}

}
