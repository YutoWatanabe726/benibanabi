package bean;

import java.io.Serializable;

public class Spot implements Serializable {

	/*
	 *観光スポットID:int
	 */
	private int spotId;

	/*
	 *観光スポット名:String
	 */
	private String spotName;

	/*
	 *観光スポット説明:String
	 */
	private String description;

	/*
	 *スポット写真パス:String
	 */
	private String spotPhoto;

	/*
	 *緯度:double
	 */
	private double latitude;

	/*
	 *経度:double
	 */
	private double longitude;

	/*
	 *住所:String
	 */
	private String address;


	/*
	 *ゲッタ・セッタ
	 */
	public int getSpotId(){
		return spotId;
	}

	public void setSpotId(int spotId){
		this.spotId = spotId;
	}

	public String getSpotName(){
		return spotName;
	}

	public void setSpotName(String spotName){
		this.spotName = spotName;
	}

	public String getDescription(){
		return description;
	}

	public void setdescription(String description){
		this.description = description;
	}

	public String getSpotPhoto(){
		return spotPhoto;
	}

	public void setSpotPhoto(String spotPhoto){
		this.spotPhoto = spotPhoto;
	}

	public double getLatitude(){
		return latitude;
	}

	public void setLatitude(double latitude){
		this.latitude = latitude;
	}

	public double getLongitude(){
		return longitude;
	}

	public void setLongitude(double longitude){
		this.longitude = longitude;
	}

	public String getAddress(){
		return address;
	}

	public void setAddress(String address){
		this.address = address;
	}

}
