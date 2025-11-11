package bean;

import java.io.Serializable;

public class Reviews implements Serializable {

	/*
	 *口コミID:int
	 */
	private int reviewId;

	/*
	 *スポットID:int
	 */
/*	private int spotId;

	/*
	 *口コミ本文:String
	 */
	private String reviewText;

	/*
	 *投稿日:int
	 */
	private int reviewDate;

	/*
	 *ゲッタ・セッタ
	 */
	public int getReviewId(){
		return reviewId;
	}

	public void setReviewId(int reviewId){
		this.reviewId = reviewId;
	}

/*	public int getSpotId(){
		return spotId;
	}

	public void setSpotId(int spotId){
		this.spotId = spotId;
	}
*/
	public String getReviewText(){
		return reviewText;
	}

	public void setReviewText(String reviewText){
		this.reviewText = reviewText;
	}

	public int getReviewDate(){
		return reviewDate;
	}

	public void setReviewDate(int reviewDate){
		this.reviewDate = reviewDate;
	}

}