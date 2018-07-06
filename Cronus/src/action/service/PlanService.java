package action.service;

import javax.servlet.http.HttpServletRequest;

import com.alibaba.fastjson.JSONObject;

import action.sqlhelper.GoodsSql;
import cache.ResultPoor;
import common.StringHandler;

public class PlanService extends BaseService {

    //商品加入到首页推荐
    public static String saveGoodsPlan(String jsonData, HttpServletRequest req) {

        JSONObject jsonObject = JSONObject.parseObject(jsonData);
        int spu_id = (jsonObject.get("ad_spu_id") == null ? 0 : (Integer.valueOf(jsonObject.get("ad_spu_id").toString())));

        //获取SPU商品中show图的第一个id值
        String imgId = GoodsService.getSPUFirstShowImgId(String.valueOf(spu_id));

        String title = jsonObject.get("ad_title").toString();
        String plan_group = jsonObject.get("plan_group").toString();
        String memo = jsonObject.get("ad_memo").toString();
        String promote = jsonObject.get("ad_promote").toString();
        int sort = (jsonObject.get("ad_sort") == null || "".equals(jsonObject.get("ad_sort"))) ? 0 : (Integer.valueOf(jsonObject.get("ad_sort").toString()));
        String uri = "spuId=" + spu_id;
        String category = "1";

        int cid = sendObject(411, uri);
        String checkResult = ResultPoor.getResult(cid);
        // 防止重复添加推荐商品
        int num = (int) PlanService.getFieldValue(checkResult, "num", Integer.class);
        String retResult = "";
        if (num == 1) {
            // 已经重复 不能添加
            return "{ success:0 }";
        } else {
            int ad_id = (jsonObject.get("ad_id") == null || "".equals(jsonObject.get("ad_id"))) ? 0 : (Integer.valueOf(jsonObject.get("ad_id").toString()));
            int sid = 0;
            if (ad_id == 0) {
                sid = sendObjectCreate(304, imgId, category, uri, sort, plan_group, memo, promote, title,spu_id);
            } else {
                //编辑
                sid = sendObjectCreate(306, imgId, category, uri, sort, plan_group, memo, promote, title, ad_id,spu_id);
            }

            retResult = ResultPoor.getResult(sid);
        }

        return retResult;
    }


    public static String getGoodsPlanInfo(String spuId) {
        StringBuffer sql = new StringBuffer();
        String uri = "spuId=" + spuId;
        sql.append(GoodsSql.getGoodsPlanInfo(uri));
        int sid = BaseService.sendObjectBase(9999, sql.toString());
        return StringHandler.getRetString(ResultPoor.getResult(sid));
    }


    public static String deleleGoodsPlanInfo(String ids) {

        String[] idArray = ids.split(",");
        int sid = 0;
        for (String planId : idArray) {
            sid = sendObjectCreate(307, planId);
        }
        String result = ResultPoor.getResult(sid);
        return result;
    }


    //更新首页推荐排序
    public static String updatePlanSort(String sort, String id, HttpServletRequest req) {
        int sid = sendObjectCreate(308, Integer.parseInt(sort), Integer.parseInt(id));
        String result = ResultPoor.getResult(sid);
        return result;
    }

    /**
     *
     * @param spu_name
     * @param goods_source
     * @param spu_code
     * @param cateName
     * @param goodsTypeName
     * @param status
     * @param begin
     * @param end
     * @param online
     * @return
     */
    public static String getExcGoodsList(String spu_name, String goods_source, String spu_code, String cateName, String goodsTypeName, String status, int begin, int end,String online) {
        StringBuffer sql = new StringBuffer();

        //查询条件
        if (spu_name != null && !spu_name.equals("")) {
            sql.append(" AND spu_name LIKE '%").append(spu_name).append("%'");
        }
        if (goods_source != null && !goods_source.equals("")) {
            sql.append(" AND source_code = '").append(goods_source).append("'");
        }
        if (spu_code != null && !spu_code.equals("")) {
            sql.append(" AND spu_code LIKE '%").append(spu_code).append("%'");
        }
        if (goodsTypeName != null && !goodsTypeName.equals("")) {
            sql.append(" AND goodsTypeName LIKE '%").append(goodsTypeName).append("%'");
        }
        if (cateName != null && !cateName.equals("")) {
            sql.append(" AND cateName LIKE '%").append(cateName).append("%'");
        }
        if (status != null && !status.equals("")) {
            sql.append(" AND T.status = ").append(status);
        }

        sql.append(" AND NOT EXISTS ( SELECT spu_key FROM b_plan WHERE spu_key = T.id)");
        //解决特殊分页效率问题（适用范围：只能传一个分页参数字符串类型，外部条件以buffer形式动态拼接，数据里只存主体部分）
        //String limit = "limit " + begin + "," + end;
        //int sid = BaseService.sendObject(503, sql.toString());
        int sid ;
        if(null !=online) {
            sql.append(" AND T.status = 1 ORDER BY sort,edit_time desc");
            sid = sendObjectBase(503, sql.toString(), begin, end);
        }else{
            sql.append(" ORDER BY sort,edit_time desc");
            sid = sendObjectBase(503, sql.toString(), begin, end);
        }
        return StringHandler.getRetString(ResultPoor.getResult(sid));
    }


    public static String getPlanList(String title, String plan_group, String promote, String category, int begin, int end) {

        StringBuffer sql = new StringBuffer();
        sql.append(GoodsSql.getPlanList());

        //查询条件
        sql.append(" WHERE 1=1 ");
        if (title != null && !title.equals("")) {
            sql.append(" AND P.title LIKE '%").append(title).append("%'");
        }

        if (plan_group != null && !plan_group.equals("")) {
            sql.append(" and P.plan_group = '").append(plan_group).append("'");
        }
        if (promote != null && !"".equals(promote)) {
            sql.append(" and P.promote LIKE '%").append(promote).append("%'");
        }
        if (category != null && !"".equals(category)) {
            sql.append(" and P.category = '").append(category).append("'");
        }

        sql.append(" ORDER BY plan_group,sort,id");

        int sid = BaseService.sendObjectBase(9997, sql.toString(), begin, end);
        System.out.println(sid);
        return StringHandler.getRetString(ResultPoor.getResult(sid));
    }

    /**
     *
     * @param companyName
     * @param begin
     * @param end
     * @return
     */
    public static String getLogisticCompanyList(String companyName,int begin, int end){
        StringBuffer sql = new StringBuffer();
        //查询条件
        sql.append(" WHERE 1=1 ");
        if (companyName != null && !companyName.equals("")) {
            sql.append(" AND company_name LIKE '%").append(companyName).append("%'");
        }
        sql.append(" ORDER BY create_date desc");

        int sid = BaseService.sendObjectBase(420,sql.toString(),begin,end);
        String res =  ResultPoor.getResult(sid);
        return StringHandler.getRetString(res);

    }
}
