package connect;

import java.io.IOException;
import java.io.InputStream;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.util.Properties;

public class BaseConnect {

	private String driverClass;
	private String jdbcUrl;
	private String user;
	private String password;
	public Connection conn;
	public BaseConnect() {
		Properties prop = new Properties();
		InputStream in = getClass().getResourceAsStream("/properties/BaseConnect.properties");
		try {
			prop.load(in);

			driverClass = (String) prop.get("driverClass");
			jdbcUrl = (String) prop.get("jdbcUrl");
			user = (String) prop.get("user");
			password = (String) prop.get("password");

			Class.forName(driverClass);
			conn = DriverManager.getConnection(jdbcUrl, user, password);// 获取连接
			
		} catch (IOException e) {
			e.printStackTrace();
		} catch (ClassNotFoundException e) {
			e.printStackTrace();
		} catch (SQLException e) {
			e.printStackTrace();
		}
	}
	
	public void initProjectSource(){
		
	}
	
}