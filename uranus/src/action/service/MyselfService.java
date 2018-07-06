package action.service;

import com.alibaba.fastjson.JSONArray;
import com.alibaba.fastjson.JSONObject;

import cache.AioTcpCache;
import cache.BaseCache;
import cache.ResultPoor;
import common.PropertiesConf;

public  class MyselfService extends BaseService{
    /** 
     * 返回邀请人列表
     * @return 
     */  
    public static JSONArray inviteFriends(String useId) {  
    	int sid = sendObject(179, useId,useId);
    	String inviteStr = ResultPoor.getResult(sid);
    	JSONObject invite_json = JSONObject.parseObject(inviteStr);
    	JSONArray inviteResult = invite_json.getJSONObject("result").getJSONArray("rs");
		return inviteResult;	
     }  
    
    /** 
     * 返回邀请码	邀请码先定位手机号
     * @return 
     */  
    public static JSONArray inviteCode(String useId) {  
    	int sid = sendObject(178, useId);
    	String inviteCodeStr = ResultPoor.getResult(sid);
    	JSONObject inviteCode_json = JSONObject.parseObject(inviteCodeStr);
    	JSONArray inviteCode = inviteCode_json.getJSONObject("result").getJSONArray("rs");
		return inviteCode;	
     }  
    
    /** 
     * 返回钱包列表
     * @return 
     */  
    public static JSONArray findWalletList(String useId,String nowMonth) {  
    	int sid = sendObject(180, useId,nowMonth);
    	String findWalletStr = ResultPoor.getResult(sid);
    	JSONObject findWallet_json = JSONObject.parseObject(findWalletStr);
    	JSONArray findWallet = findWallet_json.getJSONObject("result").getJSONArray("rs");
		return findWallet;	
     }
    
	/**
	 * 我的模块,礼包商品列表搜索
	 */
	public static String findGiftGoodList(Integer beginNum,Integer endNum) {  
    	String sql = " order by p.create_time desc";	        
		int searchGoodsGiftInt =  sendObject(AioTcpCache.ctc,186,sql,PropertiesConf.HESTIA_URL,beginNum,endNum);
		return ResultPoor.getResult(searchGoodsGiftInt);
    }  
	
	/**
	 * 确然上级和加入被邀请人列表
	 */
	public static String confirmSupmember(String useId,String phone) {  
		//更新我的上级
		sendObjectCreate(189,phone,useId);
		//查询邀请人信息
		int insertBeInvite =  sendObject(192,useId);
		//生成当前时间  插入邀请表
		String inviteDate = BaseCache.getTIME();
		JSONObject beInvite = JSONObject.parseObject(ResultPoor.getResult(insertBeInvite));
		String phoneInvite = beInvite.getJSONObject("result").getJSONArray("rs").getJSONObject(0).getString("phone");
		String nickNameInvite = beInvite.getJSONObject("result").getJSONArray("rs").getJSONObject(0).getString("nick_name"); 		
		int insertBeInvites =  sendObjectCreate(193,useId,phoneInvite,nickNameInvite,inviteDate);
		return ResultPoor.getResult(insertBeInvites);
    }  
	
	/**
	 * 查询我的上级
	 */
	public static String findSupmember(String useId) {  
		int findSupmember =  sendObject(198,useId);
		return ResultPoor.getResult(findSupmember);
    } 
	
	/**
	 * 根据用户Id查询用户信息
	 */
	public static String getUserMsg(String useId) {  
		int getUserMsg =  sendObject(514,useId);
		return ResultPoor.getResult(getUserMsg);
    } 
	
	/**
	 * 根据用户Id查询用户信息
	 */
	public static String getUsersgByPhone(String phone) {  
		int getUserMsg = sendObject(517,phone);
		return ResultPoor.getResult(getUserMsg);
    } 
	
	/**
	 * 先判断你是否是我的下级,而我刚好没有上级的情况
	 */
	public static String findIsNotSon(String useId) {  
		int findIsNotSon =  sendObject(199,useId,useId,useId);
		return ResultPoor.getResult(findIsNotSon);
    } 
	
	/**
	 * 用户会员状态下展示页面，显示分销计算
	 */
	public static String findMember(String useId,String nowTime) {  
		int findMember =  sendObject(504,nowTime.substring(0, 6),nowTime.substring(0, 4),useId);
		return ResultPoor.getResult(findMember);
    } 
	
	/**
	 * 收藏商品列表
	 */
	public static String storeGoods(String useId,String nowTime,String spuId) {  
		int storeGoodsInt =  sendObjectCreate(506,useId,spuId,nowTime);
		return ResultPoor.getResult(storeGoodsInt);
    } 
	
	/**
	 * 批量取消收藏
	 */
	public static String unStoreGoodsList(String useId,String spuIdStr) {  
		StringBuffer sql = new StringBuffer();
        sql.append(" and user_id = ").append(useId);
		if (spuIdStr != null && !spuIdStr.equals("")) {
            sql.append(" and spu_id in (").append(spuIdStr).append(")");
        }
		int storeGoodsInt = sendObjectBase(507,sql.toString());
		return ResultPoor.getResult(storeGoodsInt);
    } 
	
	/**
	 * 查询我的收藏列表
	 */
	public static String findStoreGoodsList(String useId,Integer beginNum,Integer endNum) {  
		int storeGoodsInt =  sendObject(508,PropertiesConf.HESTIA_URL,useId,1,beginNum,endNum);
		return ResultPoor.getResult(storeGoodsInt);
    } 
}
