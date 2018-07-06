package action;

import action.service.AdvertisingService;
import servlet.BaseServlet;

import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

/**
 * Created by 18330 on 2018/6/6.
 */
@WebServlet(name = "Advertising", urlPatterns = "/advertising")
public class AdvertisingAction extends BaseServlet {

    private static final long serialVersionUID = 1L;

    //广告位列表查询
    public String getPositionList(String operator,String page_location,String edit_time,String editend_time,String market_time,String marketend_time,String page, String limit){

        int pageI = Integer.valueOf(page);
        int end = Integer.valueOf(limit);

        return AdvertisingService.getPositionList(operator,page_location,edit_time,editend_time,market_time,marketend_time,(pageI - 1) * end, end);
    }
    //修改广告位状态
    public String updatePositionStatus(String status,String ids){
        String res = AdvertisingService.updatePositionStatus(status,ids);
        return res;
    }
    //编辑广告位
    public String updatePositionEdit(String id,String position_id,String position_name,String page_location,String position,String market_time,String marketend_time,String playback_length,HttpServletRequest request){

        HttpSession session=request.getSession();
        int userId=Integer.valueOf(session.getAttribute("userId").toString());

        String res = AdvertisingService.updatePositionEdit(id,position_id, position_name, page_location, position, market_time, marketend_time, playback_length,userId);
        return res;
    }

    //广告列表查询
    public String getAdvertList(String advert_id,String start_time,String end_time,String page, String limit){
//        String advert_id = request.getParameter("advert_id");
        int pageI = Integer.valueOf(page);
        int end = Integer.valueOf(limit);
        return AdvertisingService.getAdvertList(advert_id,start_time,end_time,(pageI - 1) * end, end);
    }

}
