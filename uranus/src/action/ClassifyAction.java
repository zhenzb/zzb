package action;

import java.io.InputStream;
import java.util.HashMap;
import java.util.List;

import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServletResponse;

import com.alibaba.fastjson.JSONObject;
import action.service.ClassifyService;
import common.RedisClient;
import exception.SystemException;
import model.Category;
import servlet.BaseServlet;
import utils.QRCodeUtil;

@WebServlet(name = "Classify", urlPatterns = "/classify")
public class ClassifyAction extends BaseServlet{
		private static final long serialVersionUID = 1L;
		

		/**
		 * 商品搜索
		 * @param keySkuName
		 * @param saleMark	0:升序          1:降序 
		 * @param priceMark 0:升序	1:降序
		 * @return
		 */
		public static String searchGoods(String keySkuName,String saleMark,String priceMark,String begin,String end) { 
			//mysql limit的起始索引为0,便于前台理解，所以用此方式
			Integer beginNum = Integer.valueOf(begin)-1;
			Integer endNum = Integer.valueOf(end);					
			String searchGoodsStr = ClassifyService.searchGoods(keySkuName, saleMark, priceMark,beginNum,endNum);
			JSONObject searchGoods = JSONObject.parseObject(searchGoodsStr);			
			HashMap<String,Object> resMap = new HashMap<String,Object>();
			resMap.put("searchGoods", searchGoods);
			return creatResult(1, "亲,数据包回来了哦...",resMap ).toString();
		}
		
		/**
		 * 商品分类
		 */
		public static String classifyGoods(){   	
			//判断redis里是否有缓存，如果有直接取,否则走数据查询，完了再存到redis		
			String classifyGoodsDatacache = RedisClient.hget("service_datacache","classifyGoods","classifyGoods_datacache");
			if(classifyGoodsDatacache != null){
				return classifyGoodsDatacache;
			}
			List<Category> classifyGoods = ClassifyService.classifyGoods();	
			String classifyGoodsResult = JSONObject.toJSONString(classifyGoods);
			RedisClient.hset("service_datacache","classifyGoods","classifyGoods_datacache",classifyGoodsResult,300);		
			return classifyGoodsResult;
		} 
		
		/**
		 * 根据商品分类查询商品列表
		 * @param dictDataValue     category_id
		 */
		public static String getGoodsListByCategoryId(String dictDataValue,String begin,String end){
			//mysql limit的起始索引为0,便于前台理解，所以用此方式
			Integer beginNum = Integer.valueOf(begin)-1;
			Integer endNum = Integer.valueOf(end);
			String  getGoodsListstr = ClassifyService.getGoodsListByCategoryId(dictDataValue,beginNum,endNum);
			JSONObject getGoodsList = JSONObject.parseObject(getGoodsListstr);
			
			HashMap<String,Object> resMap = new HashMap<String,Object>();
			resMap.put("getGoodsList", getGoodsList);
			return creatResult(1, "",resMap).toString();
		}

	/**
	 * 获取商品的小程序码
	 * access_token 小程序access_token
	 * scene 小程序码参数
	 * path 页面路径
	 * width 图片大小
	 */
	public static void getGoodsQR(String access_token, String scene, String path, String width, HttpServletResponse response){
		 QRCodeUtil.getQRCode(access_token, scene, path, Integer.valueOf(width),response);
	}

	/**
	 * 获取掌达赚的商品列表
	 * @return
	 */
	public static String getZhangDZGoods(){
		String zhangDZGoodsList = ClassifyService.getZhangDZGoodsList();
		JSONObject zhangDZGoods = JSONObject.parseObject(zhangDZGoodsList);
		HashMap<String,Object> resMap = new HashMap<String,Object>();
		resMap.put("zhangDZGoods", zhangDZGoods);
		return creatResult(1, "亲,数据包回来了哦...",resMap ).toString();
	}

}