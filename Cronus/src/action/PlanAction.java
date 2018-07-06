package action;

import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServletRequest;

import action.service.PlanService;
import servlet.BaseServlet;

@WebServlet(name = "Plan", urlPatterns = "/plan")
public class PlanAction extends BaseServlet {

    private static final long serialVersionUID = 1L;


    public String getGoodsPlanInfo(String spuId) {
        String res = PlanService.getGoodsPlanInfo(spuId);
        return res;
    }

    //删除
    public String deleleGoodsPlanInfo(String ids) {
        String res = PlanService.deleleGoodsPlanInfo(ids);
        return res;
    }

    //将SPU添加到首页推荐（新增或修改）
    public String saveGoodsPlan(String jsonString, HttpServletRequest req) {
        String res = PlanService.saveGoodsPlan(jsonString, req);
        return res;
    }

    //更新排序
    public String updatePlanSort(String sort, String id, HttpServletRequest req) {
        String res = PlanService.updatePlanSort(sort, id, req);
        return res;
    }

    public String getPlanList(String title, String plan_group, String promote, String category, String page, String limit) {
        int pageI = Integer.valueOf(page);
        int limitI = Integer.valueOf(limit);
        String res = PlanService.getPlanList(title, plan_group, promote, category, (pageI - 1) * limitI, limitI);
        return res;
    }

    /**
     * @param spu_name
     * @param goods_source
     * @param spu_code
     * @param cateName
     * @param goodsTypeName
     * @param status
     * @param page
     * @param limit
     * @param online
     * @return
     */
    public String getExcGoodsList(String spu_name, String goods_source, String spu_code, String cateName, String goodsTypeName, String status, String page, String limit, String online) {
        int pageI = Integer.valueOf(page);
        int limitI = Integer.valueOf(limit);
        String res = PlanService.getExcGoodsList(spu_name, goods_source, spu_code, cateName, goodsTypeName, status, (pageI - 1) * limitI, limitI, online);
        return res;
    }


    /**
     * 查询出所有快递物流公司
     *
     * @param company_name
     * @param page
     * @param limit
     * @return
     */
    public String getLogisticCompanyList(String company_name, String page, String limit) {
        int pageI = Integer.valueOf(page);
        int limitI = Integer.valueOf(limit);
        String res = PlanService.getLogisticCompanyList(company_name,(pageI - 1) * limitI, limitI);
        return res;
    }
}
