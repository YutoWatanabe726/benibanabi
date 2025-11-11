package bean;

import java.io.Serializable;

public class Tag implements Serializable {

	/*
	 *タグID:int
	 */
	private int tagId;

	/*
	 *タグ名:String
	 */
	private String tagName;

	/*
	 *ゲッタ・セッタ
	 */
	public int getTagId(){
		return tagId;
	}

	public void setTagId(int tagId){
		this.tagId = tagId;
	}

	public String getTagName(){
		return tagName;
	}

	public void setTagName(String tagName){
		this.tagName = tagName;
	}

}
