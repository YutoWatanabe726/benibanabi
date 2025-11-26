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
import bean.Tag;
import dao.SpotDAO;
import dao.TagDAO;
import tool.Action;

public class CourseSpotSearchAction extends Action {

    private static final String FAV_COOKIE_NAME = "benibanabi_favs_v1"; // JS と統一

    @Override
    public void execute(HttpServletRequest req, HttpServletResponse res) throws Exception {

        req.setCharacterEncoding("UTF-8");
        res.setContentType("application/json; charset=UTF-8");
        res.setCharacterEncoding("UTF-8");

        String listOnlyParam = req.getParameter("listOnly");
        boolean listOnly = "true".equalsIgnoreCase(listOnlyParam);

        SpotDAO spotDao = new SpotDAO();
        TagDAO tagDao = new TagDAO();

        List<String> areas = spotDao.getAllAreas();
        List<Tag> tags = tagDao.findAllTags();

        if (listOnly) {
            // JSON作成（エリア・タグ一覧だけ返す）
            StringBuilder sb = new StringBuilder();
            sb.append("{");

            sb.append("\"areas\":[");
            for(int i=0;i<areas.size();i++){
                sb.append("\"").append(escapeJson(areas.get(i))).append("\"");
                if(i < areas.size()-1) sb.append(",");
            }
            sb.append("],");

            sb.append("\"tags\":[");
            for(int i=0;i<tags.size();i++){
                Tag t = tags.get(i);
                sb.append("{\"id\":").append(t.getTagId())
                  .append(",\"name\":\"").append(escapeJson(t.getTagName())).append("\"}");
                if(i < tags.size()-1) sb.append(",");
            }
            sb.append("]");

            sb.append("}");

            try(PrintWriter out = res.getWriter()) {
                out.print(sb.toString());
            }
            return;
        }

        // 通常の検索
        String keyword = req.getParameter("keyword");
        String[] areasParam = req.getParameterValues("areaIds"); // JS 側に合わせる
        String[] tagsParam = req.getParameterValues("tagIds");   // JS 側に合わせる
        String favOnlyParam = req.getParameter("favOnly");

        List<String> areaList = areasParam != null ? Arrays.asList(areasParam) : new ArrayList<>();
        List<String> tagList = tagsParam != null ? Arrays.asList(tagsParam) : new ArrayList<>();
        boolean favOnly = "true".equalsIgnoreCase(favOnlyParam);

        List<Spot> spots = spotDao.searchSpots(keyword, areaList, tagList);

        // クッキーからお気に入りID取得
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

        // favOnly の場合フィルター
        if(favOnly){
            spots = spots.stream()
                    .filter(s -> favIds.contains(s.getSpotId()))
                    .collect(Collectors.toList());
        }

        // JSON作成
        StringBuilder sb = new StringBuilder();
        sb.append("{");

        // スポット
        sb.append("\"spots\":[");
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
            sb.append("\"spotPhoto\":\"").append(escapeJson(s.getSpotPhoto()!=null?s.getSpotPhoto():"")).append("\"");
            sb.append("}");
            if(i<spots.size()-1) sb.append(",");
        }
        sb.append("],");

        // エリア一覧
        sb.append("\"areas\":[");
        for(int i=0;i<areas.size();i++){
            sb.append("\"").append(escapeJson(areas.get(i))).append("\"");
            if(i<areas.size()-1) sb.append(",");
        }
        sb.append("],");

        // タグ一覧
        sb.append("\"tags\":[");
        for(int i=0;i<tags.size();i++){
            Tag t = tags.get(i);
            sb.append("{\"id\":").append(t.getTagId())
              .append(",\"name\":\"").append(escapeJson(t.getTagName())).append("\"}");
            if(i<tags.size()-1) sb.append(",");
        }
        sb.append("]");

        sb.append("}");

        try(PrintWriter out = res.getWriter()) {
            out.print(sb.toString());
        }
    }

    private String escapeJson(String str){
        if(str==null) return "";
        return str.replace("\\","\\\\")
                  .replace("\"","\\\"")
                  .replace("\b","\\b")
                  .replace("\f","\\f")
                  .replace("\n","\\n")
                  .replace("\r","\\r")
                  .replace("\t","\\t");
    }
}
