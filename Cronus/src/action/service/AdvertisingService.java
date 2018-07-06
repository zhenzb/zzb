package action.service;

import cache.ResultPoor;
import common.BaseCache;
import common.StringHandler;
import common.Utils;

/**
 * Created by 18330 on 2018/6/6.
 */
public class AdvertisingService extends BaseService{
    //查询广告位列表
    public static String getPositionList(String operator,String page_location,String edit_time,String editend_time,String market_time,String marketend_time,int page, int limit){
        StringBuffer sql = new StringBuffer();
        //条件查询
        if(operator != null && !operator.equals("")){
            sql.append(" AND operator like '%").append(operator).append("%'");
        }
        if(page_location != null && !page_location.equals("")){
            sql.append(" AND page_location = ").append(page_location);
        }
        if((edit_time != null && !edit_time.equals("")) || (editend_time != null && !editend_time.equals(""))){
            String bDate = Utils.transformToYYMMddHHmmss(edit_time);
            String eDate = Utils.transformToYYMMddHHmmss(editend_time);
            sql.append(" and edit_time BETWEEN ").append(bDate).append(" and ").append(eDate);
        }
        if((market_time != null && !market_time.equals(""))){
            String marketTime = Utils.transformToYYMMddHHmmss(market_time);
            sql.append(" and market_time >= ").append(marketTime);
        }
        if((marketend_time != null && !marketend_time.equals(""))){
            String marketendTime = Utils.transformToYYMMddHHmmss(marketend_time);
            sql.append(" and marketend_time <= ").append(marketendTime);
        }
        int sid = sendObjectBase(700, sql.toString());
        System.out.println(sid);
        String retString = StringHandler.getRetString(ResultPoor.getResult(sid));
        System.out.println(retString);
        return retString;
    }

    //修改广告位状态
    public static String updatePositionStatus(String status,String ids){

        String[] idArray = ids.split(",");
        int sid = 0;
        for (String aid : idArray) {
            sid = sendObjectCreate(701,status, aid);
        }
        String result = ResultPoor.getResult(sid);
        return result;
    }

    //编辑广告位
    public static String updatePositionEdit(String id,String position_id,String position_name,String page_location,String position,String market_time,String marketend_time,String playback_length,int userId){
        int uId = UserService.checkUserPwdFirstStep(userId);
        String operator = UserService.selectLoginName(uId);
        String edit_time= BaseCache.getDateTime();
        int updateId=sendObjectCreate(702,position_id,position_name,page_location,position,market_time,marketend_time,playback_length,operator,edit_time,id);
        String res = ResultPoor.getResult(updateId);
        return res;
    }

    //广告列表查询
    public static String getAdvertList(String advert_id,String start_time,String end_time,int page, int limit){
        StringBuffer sql = new StringBuffer();
        if (advert_id != null && !advert_id.equals("")){
            sql.append(" and advert_id = ").append(advert_id);
        }
        int sid = sendObjectBase(703, sql.toString());
        System.out.println(sid);
        String retString = StringHandler.getRetString(ResultPoor.getResult(sid));
        System.out.println(retString);
        return retString;
    }
}
