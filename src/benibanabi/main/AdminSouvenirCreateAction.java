package benibanabi.main;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import tool.Action;

public class AdminSouvenirCreateAction extends Action {

    @Override
    public void execute(HttpServletRequest request, HttpServletResponse response) throws Exception {

        // 名産品追加画面へ
        request.getRequestDispatcher(
            "/benibanabi/benibanabi/main/souvenir_add.jsp"
        ).forward(request, response);
    }
}
