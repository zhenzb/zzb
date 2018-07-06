package Timer;

import action.service.BaseService;
import cache.ResultPoor;
import com.alibaba.fastjson.JSONArray;
import com.alibaba.fastjson.JSONObject;
import common.BaseCache;

import java.util.ArrayList;

public class TimerTest extends BaseService {

	public static String getStatus() {
		System.out.println("***你的小可爱来处理流转的订单状态喽***");
		int getStatus = sendObject(130);
		String rsSta = ResultPoor.getResult(getStatus);
		JSONObject jsonObject = JSONObject.parseObject(rsSta);
		JSONObject results = jsonObject.getJSONObject("result");
		JSONArray us = results.getJSONArray("rs");
		for (int i = 0; i < us.size(); i++) {
			System.out.println("####################################");
			JSONObject jsonTemp = (JSONObject) us.getJSONObject(i);
			String str = jsonTemp.getString("submission_time").toString();
			String strStatus = jsonTemp.getString("status").toString();
			String id = jsonTemp.getString("id").toString();
			if (str != null && !str.equals("")) {
				long submissionDate = Long.valueOf(jsonTemp.getString("submission_time"));
				long now = Long.valueOf(BaseCache.getDateTime());
				//180508113500  18-05-08 11:35:00    超过7天变成：已签收/已收货（107）
				if ("106".equals(strStatus) && now - 700000 >= submissionDate ) {
					sendObjectCreate(128, id);
				}
				// 超过7天变成 已完成（108）
				if ("107".equals(strStatus)&& now - 700000 >= submissionDate ) {
					sendObjectCreate(129, id);
				}
				// 超过7天变成 关闭（120）
				if ("108".equals(strStatus)&& now - 700000 >= submissionDate ) {
					sendObjectCreate(133, id);
				}
			}
		}
		return rsSta;
	}

	/**
	 * 商品超过预期销售时间自动下架
	 */
	public static void updateShelfState(){
		System.out.println("***你的小可爱来下架商品喽***");
		//生成当前时间
		String time= BaseCache.getTIME();
		//根据是否到达预售时间，下架sku
		sendObjectCreate(401,time);
		//sku下架后再全部检查对应spu的sku是否全部下架，如果全部下级，下降spu
		sendObjectCreate(402);
	}

	/**
	 * 顶级：奖励;	父级：佣金;	子级：返现
	 * b_commission表profit_source来源		1:奖励 ; 2,佣金 ； 3：返现
	 * 佣金有计算波动的订单状态：已支付：103   插入操作
	 *                       待付款状态取消订单（手动取消）110	申请退款已确认（线下申请售后）111	已取消订单（售后）113
	 *                       已关闭（确保用户不能退货）：120 确定有效
	 * b_commission表statu		0：预估佣金 	1：取消佣金  	2：实际佣金 	3：提现佣金
	 */
	public static void commissions(){
		System.out.println("***你的小可爱来算佣金喽***");
		//生成当前时间
		String time= BaseCache.getTIME();

		//计算已支付103 没有核算过的情况
		int unCommissions = sendObject(135);
		String unCommissionsStr = ResultPoor.getResult(unCommissions);
		JSONArray unOrderList = JSONObject.parseObject(unCommissionsStr).getJSONObject("result").getJSONArray("rs");
		for (int i = 0; i < unOrderList.size(); i++) {
			JSONObject jsonTemp = unOrderList.getJSONObject(i);
			int status = jsonTemp.getString("status").equals("")?0:Integer.valueOf(jsonTemp.getString("status"));
			String orderId = jsonTemp.getString("id");
			int profit = jsonTemp.getString("profit").equals("")?0:Integer.valueOf(jsonTemp.getString("profit"));

			int outsiderTop = jsonTemp.getString("outsider_top").equals("")?0:Integer.valueOf(jsonTemp.getString("outsider_top"));
			int outsiderParent = jsonTemp.getString("outsider_parent").equals("")?0:Integer.valueOf(jsonTemp.getString("outsider_parent"));
			int outsiderSelf = jsonTemp.getString("outsider_self").equals("")?0:Integer.valueOf(jsonTemp.getString("outsider_self"));

			int memberTop = jsonTemp.getString("member_top").equals("")?0:Integer.valueOf(jsonTemp.getString("member_top"));
			int memberParent = jsonTemp.getString("member_parent").equals("")?0:Integer.valueOf(jsonTemp.getString("member_parent"));
			int memberSelf = jsonTemp.getString("member_self").equals("")?0:Integer.valueOf(jsonTemp.getString("member_self"));
			int myIsMember = jsonTemp.getString("my_is_member").equals("")?0:Integer.valueOf(jsonTemp.getString("my_is_member"));

			//存在无父级情况下,父级和顶级会员级别和会员级别和id不可以避免为空的情况,下单时候留到算佣金时处理,三元运算符解决该问题
			//topId		supIsMember   	topIsMember
			int supIsMember = jsonTemp.getString("sup_is_member").equals("")?0:Integer.valueOf(jsonTemp.getString("sup_is_member"));
			int topIsMember = jsonTemp.getString("top_is_member").equals("")?0:Integer.valueOf(jsonTemp.getString("top_is_member"));
			int topId = jsonTemp.getString("top_id").equals("")?0:Integer.valueOf(jsonTemp.getString("top_id"));
			int parentId = jsonTemp.getString("parent_id").equals("")?0:Integer.valueOf(jsonTemp.getString("parent_id"));
			int buyerId = jsonTemp.getString("buyer_id").equals("")?0:Integer.valueOf(jsonTemp.getString("buyer_id"));

			//不同的订单状态时刻
			int money = 0;
			int supMoney = 0;
			int topMoney = 0;

			//确认用户支付成功或用户点击确定收货，开始计算预估金额
			if (status == 103||status == 108) {
				//采用事物方式：一起提交减少通道的占用
				ArrayList<Object> ay = new ArrayList<>();
				String sql1 = "INSERT INTO uranus.b_commission (beneficiary_id,money,order_id,status,memo,profit_source,create_time) VALUES (?,?,?,?,?,?,?)";
				String sql2 = "UPDATE uranus.b_order set If_Commission = 1 where id = ?";
				if(buyerId !=0){
					if(myIsMember==0){
						money = profit*outsiderSelf;
					}else{
						money = profit*memberSelf;
					}
					ay = addTransJa(ay,sql1,buyerId,money,orderId,0,"",3,time);
				}

				if(parentId != 0){
					if(supIsMember==0){
						supMoney = profit*outsiderParent;
					}else{
						supMoney = profit*memberParent;
					}
					ay = addTransJa(ay,sql1,parentId,supMoney,orderId,0,"",2,time);
				}

                if(topId != 0){
					if(topIsMember==0){
						topMoney = profit*outsiderTop;
					}else{
						topMoney = profit*memberTop;
					}
					ay = addTransJa(ay,sql1,topId,topMoney,orderId,0,"",1,time);
				}
				//订单佣金计算完毕，修改订单修改状态，避免重复计算
				ay = addTransJa(ay,sql2,orderId);
				//用事物的方式一起发送sql,减少通道的频繁占用
				sendTransJa(ay);
			}
	    }

		//更新  已经核算过的情况
		int commissions = sendObject(139);
		String commissionsStr = ResultPoor.getResult(commissions);
		JSONArray orderList = JSONObject.parseObject(commissionsStr).getJSONObject("result").getJSONArray("rs");
		for (int x = 0;  x< orderList.size(); x++) {
			JSONObject jsonTemps = orderList.getJSONObject(x);
			int status1 = Integer.valueOf(jsonTemps.getString("status"));
			String orderId1 = jsonTemps.getString("id");

			//待付款状态取消订单（手动取消）110	申请退款已确认（线下申请售后）111	已取消订单（售后）113，修改佣金计算状态
			if (status1 == 110||status1 == 111|| status1 == 113) {
				sendObjectCreate(137,1,orderId1);
			}
			//订单正常关闭，预估佣金变成实际佣金
			if (status1 == 120) {
				sendObjectCreate(137,2,orderId1);
			}
		}
	}
}
