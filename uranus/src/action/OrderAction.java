package action;

import java.io.UnsupportedEncodingException;
import java.net.URLEncoder;
import java.util.HashMap;
import javax.servlet.annotation.WebServlet;
import com.alibaba.fastjson.JSONObject;
import action.service.FinanceService;
import action.service.GoodService;
import action.service.OrderService;
import action.service.UserService;
import action.service.WechatPayService;
import cache.BaseCache;
import constant.RspCode;
import servlet.BaseServlet;


import static action.WechatNotityAction.getFieldValue;

@WebServlet(name = "Order", urlPatterns = "/order")
public class OrderAction extends BaseServlet{
		private static final long serialVersionUID = 1L;

    /**
     * 创建订单
     * @param skuId
     * @param token
     * @param deliveryAddress
     * @param consignee
     * @param consigneeTel
     * @param dataSource
     * @param orderType 会过，自营，礼包
     * @param skuNumber
     * @param remark
     * @param paymentWaykey
     * @param jsCode
     * @param transactionBody
     * @param spbillCreateIp
     * @param sceneInfo
     * @param deviceInfo
     * @return
     * @throws Exception
     */
		public static String createOrder(String skuId,String token,String deliveryAddress,String consignee,String consigneeTel,
				String dataSource,String orderType,String skuNumber,String remark,String paymentWaykey,String jsCode,String transactionBody,String spbillCreateIp,String sceneInfo,String deviceInfo)throws Exception  {
			
			String useId = UserService.getUserIdByToken(token);
			if(useId==null){
				return creatResult(0, "亲，未登录....", null).toString();
			}
			
			//判断商品库存   订单表里存useId
			String result_str = GoodService.getGoodsBySkuId(skuId);
			//String userPurchase_str = GoodService.userPurchase(useId,skuId);
			JSONObject resultArray = JSONObject.parseObject(result_str).getJSONObject("result").getJSONArray("rs").getJSONObject(0);
			int stock = Integer.parseInt(resultArray.getString("stock"));
			int buyconfine = Integer.parseInt(resultArray.getString("buyconfine"));
			int skuStatus = Integer.parseInt(resultArray.getString("sku_status"));
			//由于运营修改商品信息后的造成的订单和商品价格存在不时效的不同步问题
			int marketPrice = Integer.parseInt(resultArray.getString("market_price"));
			int originalPrice = Integer.parseInt(resultArray.getString("original_price"));
			
			//JSONObject userPurchase_json = JSONObject.parseObject(userPurchase_str);
			//取消用户限购
//			int size= userPurchase_json.getJSONObject("result").getJSONArray("rs").size();	
//			if(size != 0){
//				return creatResult(5, "亲，该用户限购了", null).toString();
//			}
			if(skuStatus == 0){
				return creatResult(2, "亲，商品下架了", null).toString();
			}	
			if(buyconfine !=0 && Integer.parseInt(skuNumber)>buyconfine){
				return creatResult(3, "亲,限购买数量了", null).toString();
			}		
			if(stock<Integer.parseInt(skuNumber)){
				return creatResult(4, "亲,库存不足", null).toString();
			}           		
		
			//生成订单号
			String orderNo = OrderService.getOrderNo(useId);
			//生成当前时间
			String createdDate = BaseCache.getTIME();
			int rps_code = OrderService.createOrder(skuId,useId,deliveryAddress,consignee,consigneeTel,orderNo,dataSource,orderType,skuNumber,createdDate,remark,paymentWaykey,marketPrice,originalPrice);					
			if(rps_code != 1){
				return creatResult(6, "亲，系统忙，请稍等......", null).toString();
			}
			
			//为了优化下单速度，先把创建订单和预支付环境整合到一起
			//微信预支付金额不能前台传，只能后台获取
			String resultStr = OrderService.findOrderByNo(orderNo);
			JSONObject resultJson = JSONObject.parseObject(resultStr);
			String totalPrice = resultJson.getJSONObject("result").getJSONArray("rs").getJSONObject(0).getString("total_price");
			//获取财务流水号
			String transactionNo = FinanceService.getTradeNo(useId);		
			
			//订单支付整合小程序支付和webapp支付
			HashMap<String, Object> wechatPayInfoMap = null;	
			if(paymentWaykey.equals("WetCat")){
				wechatPayInfoMap = WechatPayService.miniWetCatOrderCreate(jsCode,transactionBody,transactionNo,totalPrice);				
			}else{
				wechatPayInfoMap = WechatPayService.winFruitWechatH5Pay(transactionBody,transactionNo,totalPrice,spbillCreateIp,sceneInfo,deviceInfo);
			}
			//与微信平台交互生成prePayId
			if(wechatPayInfoMap == null){
				return creatResult(1, RspCode.WECHAT_ERROR, null).toString();
			}
			//定义微信支付
			//交易表插入交易记录,将其交易id更新到订单表（便于财务对账）
	    	String financeStr = FinanceService.createFinance(useId,transactionNo,transactionBody, orderNo,totalPrice,paymentWaykey);    	                                                                                                         
	    	JSONObject financeJson = JSONObject.parseObject(financeStr);
	    	String financeId = financeJson.getJSONObject("result").getJSONArray("ids").get(0).toString();
	    	//由于下单单线流程过于复杂，现在考虑用线程异步的方式复杂的数据库操作			
			new Thread(){
				public void run() {
					//补全订单计算佣金状态 	  补全订单状态的过程中,存在无父级情况下,父级和顶级会员级别和会员级别和id不可以避免为空的情况,故留到算佣金时处理		
					OrderService.updateOrderDate(orderNo);	
					//将其交易id及其流水号更新到订单表（便于财务对账）    	
			    	OrderService.updateOrderFinance(financeId,orderNo);
				};
			}.start();	
	    	   	
			return creatResult(7, "", wechatPayInfoMap).toString();
		}
		
		
		/**
		 * 订单列表去支付时调用,首次创建订单预支付环节已经整合到创建订单逻辑里了
		 * @param orderNo
		 * @param skuId
		 * @param token
		 * @param deliveryAddress
		 * @param consignee
		 * @param consigneeTel
		 * @param skuNumber
		 * @param remark
		 * @param jsCode
		 * @param transactionBody
		 * @return
		 * @throws Exception
		 */
		public static String repOrderCreate(String orderNo,String skuId,String token,String deliveryAddress,String consignee,String consigneeTel,String skuNumber,String remark,String jsCode,String transactionBody,String spbillCreateIp,String sceneInfo,String deviceInfo,String paymentWaykey)throws Exception {
			
			String useId = UserService.getUserIdByToken(token);
			if(useId==null){
				return creatResult(0, "亲，未登录....", null).toString();
			}
			
			//判断商品库存   订单表里存useId
			/*String result_str = GoodService.getGoodsBySkuId(skuId);
			JSONObject result_json = JSONObject.parseObject(result_str);
			int stock = Integer.parseInt(result_json.getJSONObject("result").getJSONArray("rs").getJSONObject(0).getString("stock"));
			int buyconfine = Integer.parseInt(result_json.getJSONObject("result").getJSONArray("rs").getJSONObject(0).getString("buyconfine"));
			int skuStatus = Integer.parseInt(result_json.getJSONObject("result").getJSONArray("rs").getJSONObject(0).getString("sku_status"));
			//由于运营修改商品信息后的造成的订单和商品价格存在不时效的不同步问题
			int marketPrice = Integer.parseInt(result_json.getJSONObject("result").getJSONArray("rs").getJSONObject(0).getString("market_price"));
			int originalPrice = Integer.parseInt(result_json.getJSONObject("result").getJSONArray("rs").getJSONObject(0).getString("original_price"));

			if(skuStatus == 0){
				return creatResult(2, "亲，商品下架了", null).toString();
			}	
			if(buyconfine !=0 && Integer.parseInt(skuNumber)>buyconfine){
				return creatResult(3, "亲,限购买数量了", null).toString();
			}		
			if(stock<Integer.parseInt(skuNumber)){
				return creatResult(4, "亲,库存不足", null).toString();
			} */
			//计算订单支付总价  获取交易商户流水号
			//int skuNum =  Integer.valueOf(skuNumber);
			//String totalPrice =String.valueOf(marketPrice*skuNum);
            //String orderByNo = OrderService.findOrderByNo(orderNo);
            String resultStr = OrderService.findOrderByNo(orderNo);
			JSONObject resultJson = JSONObject.parseObject(resultStr);
			String totalPrice = resultJson.getJSONObject("result").getJSONArray("rs").getJSONObject(0).getString("total_price");
            String originalPrice = resultJson.getJSONObject("result").getJSONArray("rs").getJSONObject(0).getString("original_price");
            String marketPrice = resultJson.getJSONObject("result").getJSONArray("rs").getJSONObject(0).getString("market_price");
            String transactionNo = resultJson.getJSONObject("result").getJSONArray("rs").getJSONObject(0).getString("transaction_no");
            String transaction_id = resultJson.getJSONObject("result").getJSONArray("rs").getJSONObject(0).getString("transaction_id");
			//获取财务流水号
			//String transactionNo = FinanceService.getTradeNo(useId);
			
			//订单支付整合小程序支付和webapp支付
			HashMap<String, Object> wechatPayInfoMap = null;
			if(paymentWaykey.equals("WetCat")){
				wechatPayInfoMap = WechatPayService.miniWetCatOrderCreate(jsCode,transactionBody,transactionNo,totalPrice);				
			}else{
				wechatPayInfoMap = WechatPayService.winFruitWechatH5Pay(transactionBody,transactionNo,totalPrice,spbillCreateIp,sceneInfo,deviceInfo);
			}
			if(wechatPayInfoMap == null){
				return creatResult(1, RspCode.WECHAT_ERROR, null).toString();
			}
			
			//String financeStr = FinanceService.createFinance(useId,transactionNo,transactionBody, orderNo,totalPrice,paymentWaykey);
	    	//JSONObject financeJson = JSONObject.parseObject(financeStr);
	    	//String financeId = financeJson.getJSONObject("result").getJSONArray("ids").get(0).toString();
	    	
	    	//由于下单单线流程过于复杂，现在考虑用线程异步的方式复杂的数据库操作   再去支付由于存在时间的对应性,所以需要再次更新各个佣金的计算状态	
			new Thread(){
				public void run() {
					//补全订单计算佣金状态 	  补全订单状态的过程中,存在无父级情况下,父级和顶级会员级别和会员级别和id不可以避免为空的情况,故留到算佣金时处理,一些的订单修改操作	
					OrderService.updateGoOrderDate(deliveryAddress,consignee,consigneeTel,skuNumber,totalPrice,remark,orderNo,Integer.parseInt(originalPrice),Integer.parseInt(marketPrice));
					//将其交易id及其流水号更新到订单表（便于财务对账）    	
			    	OrderService.updateOrderFinance(transaction_id,orderNo);
				};
			}.start();	
	    	
			return creatResult(1, "", wechatPayInfoMap).toString();
		}
		
		
		/**
		 * 取消订单
		 * @param orderNo
		 * @param token
		 * @return
		 */
		public static String cancelOrder(String token,String orderNo,String remark) {              
			
			//判断商品库存   订单表里存useId
			String useId = UserService.getUserIdByToken(token);
			if(useId==null){
				return creatResult(0, "亲，未登录....", null).toString();
			}						
			OrderService.cancelOrder(orderNo,remark);
			
			//取消订单需要做得三件是工作:1，改变订单状态;2，退回库存;3，修改交易表状态
			return creatResult(1, "亲,不要走...",null ).toString();
		}
	
		
		/**
		 * 用户订单确认收货
		 * @param orderNo
		 * @param token
		 * @return
		 */
		public static String complteOrder(String token,String orderNo) {              
			
			//判断商品库存   订单表里存useId
			String useId = UserService.getUserIdByToken(token);
			if(useId==null){
				return creatResult(0, "亲，未登录....", null).toString();
			}						
			OrderService.complteOrder(orderNo);
			
			//取消订单需要做得三件是工作:1，改变订单状态;2，退回库存;3，修改交易表状态
			return creatResult(1, "亲,订单完成喽...",null ).toString();
		}
		
		
		/**
		 * 根据不同状态查询订单列表
		 * @param 
		 * @param token
		 * @param status
		 * @return
		 */
		public static String findOrderList(String token,String status,String begin,String end) {
			String useId = UserService.getUserIdByToken(token);
			if(useId==null){
				return creatResult(2, "亲，未登录....", null).toString();
			}
			//mysql limit的起始索引为0,便于前台理解，所以用此方式
			Integer beginNum = Integer.valueOf(begin)-1;
			Integer endNum = Integer.valueOf(end);
			String OrderListStr = OrderService.findOrderList(useId,status,beginNum,endNum);
			JSONObject OrderList = JSONObject.parseObject(OrderListStr);
			
			HashMap<String,Object> resMap = new HashMap<String,Object>();
			resMap.put("OrderList", OrderList);
			
			return creatResult(1, "",resMap).toString();
		}		
		
	    /**
	     * 根据快递公司编号和运单编号查询快递信息
	     * 
	     * @param expressType
	     *            快递公司类型 {@link String}
	     * @param expressNo
	     *            快递单号 {@link String}
	     * @return 快递100返回的json数据 {@link String}
	     */
	    public static String execLookKuaiDi(String expressType, String expressNo) throws UnsupportedEncodingException {
	    	//汉字转化成拼音
	    	//String com = PinYinUtil.getPingYin(expressType);
	    	//String expressInfo = kuaidi100.getExpressInfo(expressType, expressNo);
			String _expressType  =   URLEncoder.encode(expressType,"utf-8");
			String _expressNo =  URLEncoder.encode(expressNo,"utf-8");
	    	String expressInfo = OrderService.sendPostLogistic(_expressType,_expressNo);
	    	return expressInfo;
		}

	/**
	 * 保存掌达赚下单记录
	 * @param orderNo
	 * @param goodsName
	 * @param remark
	 * @return
	 */
		public static String addZhangDZOrder(String token,String orderNo,String goodsName,String remark){
			if(orderNo == null || "".equals(orderNo) || goodsName == null || "".equals(goodsName)){
				return creatResult(3, "订单号和商品都不能为空哦！", null).toString();
			}
			String zhangDZOrderByOrderNo = OrderService.findZhangDZOrderByOrderNo(orderNo);
			String  orderNo1 = (String) getFieldValue(zhangDZOrderByOrderNo, "order_no", String.class);
			if(orderNo1 != null){
				return creatResult(2, "该订单号已存在！", null).toString();
			}
			String user = UserService.getUserByToken(token);
			if(user==null){
				return creatResult(0, "亲，未登录....", null).toString();
			}
			String  phone = (String) getFieldValue(user, "phone", String.class);
			int i = OrderService.saveZhangDZOrder(orderNo, phone,goodsName, remark);
			if(i !=1){
				return creatResult(6, "亲，系统忙，请稍等......", null).toString();
			}else {
				return creatResult(1, "下单成功", null).toString();
			}
		}
}