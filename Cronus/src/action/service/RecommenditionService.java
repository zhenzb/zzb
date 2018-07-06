package action.service;

import cache.ResultPoor;
import common.StringHandler;
import common.Utils;

import javax.servlet.http.HttpServletRequest;
import java.text.SimpleDateFormat;

public class RecommenditionService extends BaseService {

    public static  String  getColumnList(String cname,String cstatus,String sales,String start_usefultime,String end_usefultime,int pageI,int limitI){

        StringBuffer sql = new StringBuffer();
        // 用户条件查询
        //查询条件
        if (cname != null && !cname.equals("")) {
            sql.append(" AND cname LIKE '%").append(cname).append("%'");
        }
        if (cstatus != null && !cstatus.equals("")) {
            sql.append(" AND cstatus = '").append(cstatus).append("'");
        }
        if (start_usefultime != null && !"".equals(start_usefultime)) {
            String created_date1 = Utils.transformToYYMMddHHmmss(start_usefultime);
            sql.append(" and start_usefultime between '").append(created_date1).append("'");
        }
        if (end_usefultime != null && !"".equals(end_usefultime)) {
            String created_date1 = Utils.transformToYYMMddHHmmss(end_usefultime);
            sql.append(" and '").append(created_date1).append("'");
        }
        int sid = BaseService.sendObjectBase(417, sql.toString(), pageI, limitI);
        String res =   StringHandler.getRetString(ResultPoor.getResult(sid));
        return res;
    }

    /**
     * 修改栏目状态
     * @param cid
     * @param cstatus
     * @param request
     * @return
     */
    public static String updateColumnStatus(String cid, String cstatus, HttpServletRequest request){
        int userId = StringHandler.getUserId(request);
        long dateTime = System.currentTimeMillis();
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        String dateStr = sdf.format(dateTime);
        String dateTimeStr = Utils.transformToYYMMddHHmmss(dateStr);
        int sid = sendObjectCreate(418, cstatus, dateTimeStr, userId,Integer.valueOf(cid));
        String result = ResultPoor.getResult(sid);
        return result;
    }


}
