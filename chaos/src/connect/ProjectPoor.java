package connect;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Collections;
import java.util.List;

import model.BannerProjectSource;

public class ProjectPoor{
	
	public String mDriverClass;
	public String mJdbcUrl;
	public String mUser;
	public String mPassword;
	public int mConnections;
	
	//等待中连接
	private List<Connection> cm = Collections.synchronizedList(new ArrayList<Connection>());
	
	//占用中连接
	private List<Connection> mm = Collections.synchronizedList(new ArrayList<Connection>());
	
	
	public ProjectPoor(BannerProjectSource bps){
		
		mDriverClass = bps.getDriverClass();
		mJdbcUrl = bps.getUrl();
		mUser = bps.getUser();
		mPassword = bps.getPwd();
		mConnections = bps.getConnections();
		
		
		try {
			Class.forName(mDriverClass);// 指定连接类型
			for (int i = 0; i < mConnections; i++) {
				Connection conn = DriverManager.getConnection(mJdbcUrl, mUser, mPassword);// 获取连接
				cm.add(conn);
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
	
	
	public Connection getConn() {
		Connection c = null;
		try {
			if (cm.isEmpty()){
				c = DriverManager.getConnection(mJdbcUrl, mUser, mPassword);
				System.out.println("连接数不足，创建新链接，当前连接池数量：" + cm.size() + " , 占用中链接 :" + mm.size());
			}else{
				c = cm.get(0);
				cm.remove(0);
			}
			mm.add(c);
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return c;
	}
	
	public void close(Connection c) {
		boolean b =  mm.remove(c);
		cm.add(c);
		if(b){
			System.out.println("移除空闲链接，当前连接池剩余数:" + cm.size() + " ，使用中连接数 ： "  + mm.size());
		}else{
			System.out.println("关闭失败");
		}
	}
	
	public void replace(Connection oldc,Connection newc){
		boolean b =  mm.remove(oldc);
		cm.add(newc);
		if(b){
			System.out.println("移除无用连接，当前连接池剩余数:" + cm.size() + " ，使用中连接数 ： "  + mm.size());
			oldc = null;
		}else{
			System.out.println("关闭失败");
		}
	}
	
}