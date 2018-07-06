package action;

import action.service.FinanceService;
import servlet.BaseServlet;

import javax.servlet.annotation.WebServlet;

@WebServlet(name = "Finance", urlPatterns = "/finance")
public class FinanceAction extends BaseServlet {

    private static final long serialVersionUID = 1L;

    /**
     * 获取支付信息列表
     * 2018/3/8 木易
     * @return
     */
       public String getpayment(String page,String limit) {
        int pageI = Integer.valueOf(page);
        int limitI =Integer.valueOf(limit);
        String res = FinanceService.getpayment((pageI-1)*limitI,pageI*limitI);
        return res;
    }

    /**
     * 更改支付信息列表
     * 2018/3/8 木易
     * @return
     */
    public String updatepayment(String account_name ,String account_num,String bank_name,String company_name) {
        String res = FinanceService.updatepayment(account_name,account_num,bank_name,company_name);
        return res;
    }

    /**
     * 佣金收益管理列表
     * 2018/3/20 木易
     * @return
     */
    public String Commissio(String page,String limit,String member_level,String phone) {
        int pageI = Integer.valueOf(page);
        int limitI =Integer.valueOf(limit);
        String res = FinanceService.Commissio((pageI-1)*limitI,pageI*limitI,member_level, phone);
        return res;
    }

    public String Withdraw(String page,String limit,String nick_name,String phone,String test5,String test6,String commi_id,String status) {
        int pageI = Integer.valueOf(page);
        int limitI =Integer.valueOf(limit);
        String res = FinanceService.Withdraw((pageI-1)*limitI,pageI*limitI,nick_name, phone,test5,test6,commi_id,status);
        return res;
    }
    public String WithdrawShowdetail(String page,String limit,String id,String order_id) {
        int pageI = Integer.valueOf(page);
        int limitI =Integer.valueOf(limit);
        int ids =Integer.valueOf(id);
        String res = FinanceService.WithdrawShowdetail((pageI-1)*limitI,pageI*limitI,ids,order_id);
        return res;
    }

    public String WithdrawDetail(String id,String page,String limit,String name,String test5,String test6,String order_status,String earnings_type) {
        int pageI = Integer.valueOf(page);
        int limitI =Integer.valueOf(limit);
        String res = FinanceService.WithdrawDetail(id,(pageI-1)*limitI,pageI*limitI,name,test5,test6,order_status,earnings_type);
        return res;
    }



    public String Agreerequest(String id,String order_id) {
       // int wallet_id = Integer.valueOf(id);
        String res = FinanceService.Agreerequest(id,order_id);

        return res;
    }

    public String Getpeople(String user_id) {

        String res = FinanceService.Getpeople(user_id);

        return res;
    }
    public String Rejectrequest(String reason,String id) {
        // int wallet_id = Integer.valueOf(id);
        String res = FinanceService.Rejectrequest(reason,id);

        return res;
    }



    public String  abolishquest(String id) {
        // int wallet_id = Integer.valueOf(id);
        String res = FinanceService.abolishquest(id);

        return res;
    }
}
