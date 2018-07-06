package action;

import action.service.RecommenditionService;
import servlet.BaseServlet;

import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServletRequest;

/**
 * 商品推荐
 */
@WebServlet(name = "Recommen", urlPatterns = "/recommen")
public class RecommenditionAction extends BaseServlet
{

    /**
     * 栏目列表查询
     * @param cname
     * @param cstatus
     * @param sales
     * @param start_usefultime
     * @param end_usefultime
     * @param page
     * @param limit
     * @return
     */
        public String getColumnList(String cname,String cstatus,String sales,String start_usefultime,String end_usefultime,String page,String limit){
            int pageI = Integer.valueOf(page);
            int limitI =Integer.valueOf(limit);
            String res = RecommenditionService.getColumnList(cname, cstatus, sales, start_usefultime, end_usefultime,(pageI-1)*limitI,limitI);
            return res;
        }

    /**
     * 修改栏目状态
     * @param cid
     * @param cstatus
     * @param req
     * @return
     */
        public String updateColumnStatus(String cid,String cstatus,HttpServletRequest req){
            String res = RecommenditionService.updateColumnStatus(cid, cstatus, req);
            return res;
        }

}
