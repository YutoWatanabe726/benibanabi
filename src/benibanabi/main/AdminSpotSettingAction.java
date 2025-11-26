package benibanabi.main;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import tool.Action;

public class AdminSpotSettingAction extends Action {

	@Override
	public void execute(HttpServletRequest req, HttpServletResponse res) throws Exception {


		req.getRequestDispatcher("admin_spot_setting.jsp").forward(req, res);
	}

}
