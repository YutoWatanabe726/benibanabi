package bean;

import java.io.Serializable;

public class Admin implements Serializable {

	/*
	 *管理者ID:int
	 */
	private String id;

	/*
	 *パスワード:int
	 */
	private String password;

	/*
	 *ゲッタ・セッタ
	 */
	public String getId(){
		return id;
	}

	public void setId(String id){
		this.id = id;
	}

	public String getPassword(){
		return password;
	}

	public void setPassword(String password){
		this.password = password;
	}

}
