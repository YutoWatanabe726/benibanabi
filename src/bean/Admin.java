package bean;

import java.io.Serializable;

public class Admin implements Serializable {

	/*
	 *管理者ID:int
	 */
	private int id;

	/*
	 *パスワード:int
	 */
	private int password;

	/*
	 *ゲッタ・セッタ
	 */
	public int getId(){
		return id;
	}

	public void setId(int id){
		this.id = id;
	}

	public int getPassword(){
		return password;
	}

	public void setPassword(int password){
		this.password = password;
	}

}
