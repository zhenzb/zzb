package action.service;

import cache.AioTcpCache;
import cache.ResultPoor;
import common.PropertiesConf;

public class PlanService  extends BaseService {
    	
	public static String getBanner(String districtId) {
		int bannerId;
		String sql = " order by plan_group asc,sort asc";
		if(districtId != null && !districtId.equals("")) {
			sql = " and plan.district_id = ? " + sql;
			bannerId = sendObject(AioTcpCache.getCtc(),203,sql,PropertiesConf.HESTIA_URL,districtId);
		}else {
			bannerId = sendObject(AioTcpCache.getCtc(),203,sql,PropertiesConf.HESTIA_URL);
		}
		return ResultPoor.getResult(bannerId);
	}
	
	public static int getSpu(String spuId,String useId) {
		int resultInt = 0;
		if(useId == null){
			resultInt = sendObject(204,spuId);		
		}else{
			resultInt = sendObject(509,useId,spuId);
		}
		return resultInt;
	}
	
	public static int getSpuAttribute(String spuId) {
		return sendObject(205,spuId,spuId);
	}
	
	public static int getSkus(String spuId) {
		return sendObject(206,spuId);
	}
	
	public static int getImgs(String imgIds) {
		imgIds = imgIds.equals("")?"0":imgIds;
		//if(image.http_path is not null,concat( \"http:\" ,image.http_path) ,concat( ""+ PropertiesConf.HESTIA_URL +"\",image.image_path)) 
		String sql = "SELECT id,if(http_path is not null,concat(\"http:\" ,http_path) ,concat(\" "+ PropertiesConf.HESTIA_URL +"\",image_path))  as image_path FROM uranus.b_image where id in (" + imgIds + ")";
		return sendObject(AioTcpCache.getCtc(),9999,sql);
	}
	
}