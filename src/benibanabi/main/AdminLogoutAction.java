package benibanabi.main;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import tool.Action;

public class AdminLogoutAction extends Action {

	@Override
	public void execute(HttpServletRequest req, HttpServletResponse res)
			throws Exception {
		//ローカル変数の宣言 1
		String url = "";
		HttpSession session=req.getSession();

		//リクエストパラメータ―の取得 2
		//なし

		//DBからデータ取得 3
		//なし

		//ビジネスロジック 4
		if (session.getAttribute("admin") != null) {
			session.invalidate();
		}

		//DBへデータ保存 5
		//なし

		//レスポンス値をセット 6
		//なし

		//JSPへフォワード 7
		url = "admin_logout.jsp";
		req.getRequestDispatcher(url).forward(req, res);
	}

}
