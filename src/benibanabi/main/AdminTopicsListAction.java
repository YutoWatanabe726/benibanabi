package benibanabi.main;

import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.List;
import java.util.Locale;
import java.util.stream.Collectors;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import bean.Topics;
import dao.TopicsDAO;
import tool.Action;

public class AdminTopicsListAction extends Action {

    // ▼ 日付 → 「MM/dd(曜)」形式で変換
    private String formatDateWithWeek(java.sql.Date date) {
        if (date == null) return "";
        LocalDate localDate = date.toLocalDate();
        DateTimeFormatter format = DateTimeFormatter.ofPattern("MM/dd(E)", Locale.JAPANESE);
        return localDate.format(format);
    }

    @Override
    public void execute(HttpServletRequest req, HttpServletResponse res) throws Exception {

        TopicsDAO dao = new TopicsDAO();
        List<Topics> allTopics = dao.findAll();

        // ▼ 掲載開始日の年を一覧化
        List<Integer> years = allTopics.stream()
                .map(t -> t.getTopicsPublicationDate().toLocalDate().getYear())
                .distinct()
                .sorted((a, b) -> b - a) // 新しい順
                .collect(Collectors.toList());
        req.setAttribute("years", years);

        // ▼ ここ！ デフォルトは現在の年度
        String yearParam = req.getParameter("year");
        int selectedYear = (yearParam != null && !yearParam.isEmpty())
                ? Integer.parseInt(yearParam)
                : LocalDate.now().getYear();   // ← ★ 最新ではなく「今年」

        req.setAttribute("selectedYear", selectedYear);

        // ▼ 指定年度だけ抽出
        List<Topics> filteredTopics = allTopics.stream()
                .filter(t -> t.getTopicsPublicationDate().toLocalDate().getYear() == selectedYear)
                .collect(Collectors.toList());

        // ▼ JSP表示用の曜日つき文字列に変換
        for (Topics t : filteredTopics) {
            t.setFormattedPublicationDate(formatDateWithWeek(t.getTopicsPublicationDate()));
            t.setFormattedStartDate(formatDateWithWeek(t.getTopicsStartDate()));
            t.setFormattedEndDate(formatDateWithWeek(t.getTopicsEndDate()));
        }

        // ▼ 掲載中／終了に分類
        LocalDate today = LocalDate.now();
        List<Topics> ongoing = new ArrayList<>();
        List<Topics> expired = new ArrayList<>();

        for (Topics t : filteredTopics) {
            LocalDate start = t.getTopicsStartDate().toLocalDate();
            LocalDate end = t.getTopicsEndDate().toLocalDate();
            if (!today.isBefore(start) && !today.isAfter(end)) ongoing.add(t);
            else expired.add(t);
        }

        req.setAttribute("ongoingTopics", ongoing);
        req.setAttribute("expiredTopics", expired);

        req.getRequestDispatcher("admin_topics_list.jsp").forward(req, res);
    }
}
