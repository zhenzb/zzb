package common;

import java.io.IOException;
import java.io.InputStream;
import java.io.StringReader;
import java.util.Properties;

import javax.json.Json;
import javax.json.JsonObject;
import javax.json.JsonReader;

public class PropertiesConf{
	
	public static Integer SOCKETPORT;
	
	/**
	 * errorMessage
	 */
	public static JsonObject ERRORMESSAGE;

	
	public static String PHANTOM;
	
	
	public void init(){
		Properties prop = new Properties();
		InputStream in = getClass().getResourceAsStream("/properties/BaseConnect.properties");
		try {
			prop.load(in);
			SOCKETPORT = Integer.valueOf((String) prop.get("socketPort"));
			
			PHANTOM = (String) prop.get("phantom");			
			
			
			try (JsonReader jsonReader = Json.createReader(new StringReader((String) prop.get("errorMessage")))) {
				ERRORMESSAGE = jsonReader.readObject();
			}
			
		} catch (IOException e) {
			e.printStackTrace();
		}
	}
}