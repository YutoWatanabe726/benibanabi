package bean;

import java.sql.Date;

public class Topics {
    private int topicsId;
    private Date topicsPublicationDate;
    private Date topicsStartDate;
    private Date topicsEndDate;
    private String topicsContent;
    private String topicsArea;

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
}
