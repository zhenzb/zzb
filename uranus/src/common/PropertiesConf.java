
package common;

import java.io.IOException;
import java.io.InputStream;
import java.util.Properties;

public class PropertiesConf{
	
	public static Integer SOCKETPORT;
	
	public static String PHANTOM;
	
	public static String REDIS_IP;
	
	public static Integer REDIS_PORT;
	
	public static String APP_ID;
	
	public static String APP_SECRET;
	
	public static String WETCAT_URL;
	
	public static String MINI_MCH_ID;
	
	public static String MINI_APP_KEY;
	
	public static String MINI_NOTIFY_URL;
	
	public static String HESTIA_URL;

	public static String LOGISTIC_NORMAL;
	// 正式环境物流请求接口路径
	public static String LOGISTIC_KEY;
	// 申请正式物流KEY
	public static String CUSTOMERID;
	// 申请企业版本获得
	
	public void init(){
		Properties prop = new Properties();
		InputStream in = getClass().getResourceAsStream("/properties/BaseConnect.properties");
		try {
			prop.load(in);
			
			SOCKETPORT = Integer.valueOf((String) prop.get("socketPort"));
			
			PHANTOM = (String) prop.get("phantom");
			
			String redisPath = prop.getProperty("redis");
			REDIS_IP = redisPath.split(":")[0];
			REDIS_PORT = Integer.valueOf(redisPath.split(":")[1]);
			
			APP_ID = (String) prop.get("app_id");
			APP_SECRET = (String) prop.get("app_key");
			WETCAT_URL = (String) prop.get("wetcat_url");
			
			MINI_MCH_ID = (String) prop.get("mini_mch_id");
			MINI_APP_KEY = (String) prop.get("mini_app_key");
			MINI_NOTIFY_URL = (String) prop.get("mini_notify_url");
			
			HESTIA_URL = (String) prop.get("hestia");

			// 物流信息
			LOGISTIC_NORMAL = (String) prop.get("logistic_normal");
			LOGISTIC_KEY = (String) prop.get("logistic_key");
			CUSTOMERID = (String) prop.get("customerId");


		} catch (IOException e) {
			e.printStackTrace();
		}
	}
}