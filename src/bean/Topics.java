package bean;

import java.sql.Date;

public class Topics {
    private int topicsId;
    private Date topicsPublicationDate;
    private Date topicsStartDate;
    private Date topicsEndDate;
    private String topicsContent;
    private String topicsArea;

    // ▼ 表示用（フォーマット済み）日付
    private String formattedPublicationDate;
    private String formattedStartDate;
    private String formattedEndDate;

    public int getTopicsId() { return topicsId; }
    public void setTopicsId(int topicsId) { this.topicsId = topicsId; }

    public Date getTopicsPublicationDate() { return topicsPublicationDate; }
    public void setTopicsPublicationDate(Date topicsPublicationDate) { this.topicsPublicationDate = topicsPublicationDate; }

    public Date getTopicsStartDate() { return topicsStartDate; }
    public void setTopicsStartDate(Date topicsStartDate) { this.topicsStartDate = topicsStartDate; }

    public Date getTopicsEndDate() { return topicsEndDate; }
    public void setTopicsEndDate(Date topicsEndDate) { this.topicsEndDate = topicsEndDate; }

    public String getTopicsContent() { return topicsContent; }
    public void setTopicsContent(String topicsContent) { this.topicsContent = topicsContent; }

    public String getTopicsArea() { return topicsArea; }
    public void setTopicsArea(String topicsArea) { this.topicsArea = topicsArea; }

    // ▼ Getter/Setter（表示用日付）
    public String getFormattedPublicationDate() {
        return formattedPublicationDate;
    }
    public void setFormattedPublicationDate(String formattedPublicationDate) {
        this.formattedPublicationDate = formattedPublicationDate;
    }

    public String getFormattedStartDate() {
        return formattedStartDate;
    }
    public void setFormattedStartDate(String formattedStartDate) {
        this.formattedStartDate = formattedStartDate;
    }

    public String getFormattedEndDate() {
        return formattedEndDate;
    }
    public void setFormattedEndDate(String formattedEndDate) {
        this.formattedEndDate = formattedEndDate;
    }
}
