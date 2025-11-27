package bean;

import java.io.Serializable;
import java.sql.Date;

public class Topics implements Serializable {

    private int topicsId;          // 主キー
    private Date topicsDate;       // 日付
    private String topicsContent;  // 内容
    private String topicsArea;     // 市区町村名

    public int getTopicsId() {
        return topicsId;
    }
    public void setTopicsId(int topicsId) {
        this.topicsId = topicsId;
    }

    public Date getTopicsDate() {
        return topicsDate;
    }
    public void setTopicsDate(Date topicsDate) {
        this.topicsDate = topicsDate;
    }

    public String getTopicsContent() {
        return topicsContent;
    }
    public void setTopicsContent(String topicsContent) {
        this.topicsContent = topicsContent;
    }

    public String getTopicsArea() {
        return topicsArea;
    }
    public void setTopicsArea(String topicsArea) {
        this.topicsArea = topicsArea;
    }

}
