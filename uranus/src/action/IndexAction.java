package action;

import java.util.HashMap;

import javax.servlet.annotation.WebServlet;

import com.alibaba.fastjson.JSONObject;

import action.service.AddressService;
import action.service.GoodService;
import action.service.PlanService;
import action.service.UserService;
import cache.ResultPoor;
import common.RedisClient;
import servlet.BaseServlet;

@WebServlet(name = "Index", urlPatterns = "/index")
public class IndexAction extends BaseServlet{

	private static final long serialVersionUID = -903752277625921821L;
	
	/**
	 * 为了防止首页频繁被刷(不需要登录情况),导致chaos内存溢出
	 * 		1,精简6次请求为一次请求
	 *      2,redis缓存数据有效时间3分钟
	 * @param districtId
	 * @param groupId  
	 * @param begin
	 * @param end
	 * @param token
	 * @return
	 */
	public static String getBanner(String districtId) {
		String getBanner = RedisClient.hget("service_datacache","getBanner","banner_datacache");
		if(getBanner != null){
			return getBanner;
		}
		String bannerResult = PlanService.getBanner(districtId);		
		RedisClient.hset("service_datacache","getBanner","banner_datacache",bannerResult,300);
		return bannerResult;
	}
	
	
	public static String getSpu(String spuId,String token) {
		//登陆状态下到商品到商品详情页,如果是收藏过的商品,返回特殊标记
		String useId = null;
		if(!token.equals("")){
			useId = UserService.getUserIdByToken(token);
		}	
		
		int spuSid = PlanService.getSpu(spuId,useId);
		int spuAttributeSid = PlanService.getSpuAttribute(spuId);
		int skuSid = PlanService.getSkus(spuId);
		
		String spuText = ResultPoor.getResult(spuSid);
		String spuAttributeText = ResultPoor.getResult(spuAttributeSid);
		String skuText= ResultPoor.getResult(skuSid);
		
		JSONObject spuJo = JSONObject.parseObject(spuText);
		JSONObject spuAttributeJo = JSONObject.parseObject(spuAttributeText);
		JSONObject skuJo = JSONObject.parseObject(skuText);
		
		String showImgIds = spuJo.getJSONObject("result").getJSONArray("rs").getJSONObject(0).getString("show_img_ids");
		String detailImgIds = spuJo.getJSONObject("result").getJSONArray("rs").getJSONObject(0).getString("detail_img_ids");
		int showImgSid = PlanService.getImgs(showImgIds);
		int detailImgSid = PlanService.getImgs(detailImgIds);
		String showImgText = ResultPoor.getResult(showImgSid);
		String detailImgText = ResultPoor.getResult(detailImgSid);
		JSONObject showImgJo = JSONObject.parseObject(showImgText);
		JSONObject detailImgJo = JSONObject.parseObject(detailImgText);
		
		
		HashMap<String,Object> resMap = new HashMap<String,Object>();
		resMap.put("spuBase", spuJo.getJSONObject("result").getJSONArray("rs"));
		resMap.put("spuAttribute", spuAttributeJo.getJSONObject("result").getJSONArray("rs"));
		resMap.put("sku", skuJo.getJSONObject("result").getJSONArray("rs"));
		resMap.put("showImgs", showImgJo.getJSONObject("result").getJSONArray("rs"));
		resMap.put("detailImgs", detailImgJo.getJSONObject("result").getJSONArray("rs"));
		
		return creatResult(1, "", resMap).toString();
	}
	
	public static String getAddress(String token) {
		String userId = UserService.getUserIdByToken(token);
		return AddressService.getAddress(userId);
	}
	
	/**
	 * 根据skuId获取sku
	 * @param skuId
	 * @return
	 */
	public static String getGoodsBySkuId(String skuId) {
		return GoodService.getGoodsBySkuId(skuId);
	}
}