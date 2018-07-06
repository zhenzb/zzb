package utils;

import java.util.HashMap;
import java.util.Map;
import java.util.Set;

import com.alibaba.fastjson.JSONException;
import com.alibaba.fastjson.JSONObject;

public class JsonUtils {

	/**
	 * 将json格式的数据格式化成map
	 * @param jsonString
	 * @return
	 * @throws JSONException
	 */
	public static Map<String,Object> jsonFormatMap(String jsonString){
		Map<String,Object> result = new HashMap<String,Object>();
		JSONObject jsonObject = JSONObject.parseObject(jsonString);
		Set<String> set = jsonObject.keySet();
		Object obj = null;
		for (String key : set) {
			obj = jsonObject.get(key);
			result.put(key, obj);			
		}
        return result;
    }
}
