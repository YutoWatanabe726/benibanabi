package benibanabi.main;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import tool.Action;

public class AdminSouvenirCreateAction extends Action {

    @Override
    public String execute(HttpServletRequest request, HttpServletResponse response) throws Exception {

        // ここが JSP の正しい実パス
        return "benibanabi/main/souvenir_add.jsp";
    }
}
