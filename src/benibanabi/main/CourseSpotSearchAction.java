package benibanabi.main;

import java.io.PrintWriter;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;
import java.util.stream.Collectors;

import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import bean.Spot;
import dao.SpotDAO;
import tool.Action;

public class CourseSpotSearchAction extends Action {

    private static final String FAV_COOKIE_NAME = "benibanabi_favs_v1"; // JS と統一

    @Override
    public void execute(HttpServletRequest req, HttpServletResponse res) throws Exception {

        // ★必須（print(XML/JSON) 時の文字化け防止）
        req.setCharacterEncoding("UTF-8");
        res.setContentType("application/json; charset=UTF-8");
        res.setCharacterEncoding("UTF-8");

        String keyword = req.getParameter("keyword");
        String areasParam = req.getParameter("areas");
        String tagsParam = req.getParameter("tags");
        String favOnlyParam = req.getParameter("favOnly");

        List<String> areaList = new ArrayList<>();
        List<String> tagList = new ArrayList<>();
        boolean favOnly = "true".equalsIgnoreCase(favOnlyParam);

        if (areasParam != null && !areasParam.isEmpty()) {
            areaList = Arrays.asList(areasParam.split(","));
        }
        if (tagsParam != null && !tagsParam.isEmpty()) {
            tagList = Arrays.asList(tagsParam.split(","));
        }

        // DAOで検索
        SpotDAO dao = new SpotDAO();
        List<Spot> spots = dao.searchSpots(keyword, areaList, tagList);

        // クッキーに保存されたお気に入り ID を取得
        List<Integer> favIds = new ArrayList<>();
        if(req.getCookies() != null){
            for(Cookie c : req.getCookies()){
                if(FAV_COOKIE_NAME.equals(c.getName())){
                    String[] ids = c.getValue().split(",");
                    for(String id : ids){
                        try {
                            favIds.add(Integer.parseInt(id));
                        } catch(NumberFormatException e){}
                    }
                    break;
                }
            }
        }

        // favOnly の場合、お気に入りだけに絞る
        if(favOnly){
            spots = spots.stream()
                    .filter(s -> favIds.contains(s.getSpotId()))
                    .collect(Collectors.toList());
        }

        // JSON作成
        StringBuilder sb = new StringBuilder();
        sb.append("[");
        for(int i=0;i<spots.size();i++){
            Spot s = spots.get(i);
            boolean isFav = favIds.contains(s.getSpotId());
            sb.append("{");
            sb.append("\"spotId\":").append(s.getSpotId()).append(",");
            sb.append("\"spotName\":\"").append(escapeJson(s.getSpotName())).append("\",");
            sb.append("\"area\":\"").append(escapeJson(s.getArea())).append("\",");
            sb.append("\"lat\":").append(s.getLatitude()).append(",");
            sb.append("\"lng\":").append(s.getLongitude()).append(",");
            sb.append("\"fav\":").append(isFav).append(",");
            sb.append("\"spotPhoto\":\"").append(escapeJson(
                    s.getSpotPhoto() != null ? s.getSpotPhoto() : ""
            )).append("\"");
            sb.append("}");
            if(i < spots.size()-1) sb.append(",");
        }
        sb.append("]");

        // ★ここが最重要：PrintWriter を必ず使う
        try(PrintWriter out = res.getWriter()) {
            out.print(sb.toString());
        }
    }

    // JSONエスケープ
    private String escapeJson(String str){
        if(str == null) return "";
        return str.replace("\\","\\\\")
                  .replace("\"","\\\"")
                  .replace("\b","\\b")
                  .replace("\f","\\f")
                  .replace("\n","\\n")
                  .replace("\r","\\r")
                  .replace("\t","\\t");
    }
}
