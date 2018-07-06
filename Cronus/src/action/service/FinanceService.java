package action.service;

import action.sqlhelper.FinanceSql;
import cache.ResultPoor;
import common.StringHandler;
import common.Utils;

public class FinanceService extends BaseService {

	public static String getpayment(int begin, int end) {
		int sid = sendObject(81, begin, end);
		String rsFinance = ResultPoor.getResult(sid);
		String rsFinanceJson = StringHandler.getRetString(rsFinance);
		return rsFinanceJson;

	}

	public static String updatepayment(String account_name, String account_num, String bank_name, String company_name) {
		int sid = sendObjectCreate(82, account_name, account_num, bank_name, company_name);
		String rsFinance = ResultPoor.getResult(sid);

		return rsFinance;

	}

	public static String Commissio(int begin, int end, String member_level, String phone) {
		StringBuffer sql = new StringBuffer();
		sql.append(FinanceSql.CommissioListPage_sql);
		if (phone != null && !phone.equals("")) {
			sql.append(" and t_user.phone like '%").append(phone).append("%'");
		}
		if (member_level != null && !member_level.equals("")) {
			sql.append(" and member_level like '%").append(member_level).append("%'");
		}

		//sql.append(" GROUP BY `user`.id ");
		int sid = BaseService.sendObjectBase(9997, sql.toString(), begin, end);
		System.out.println(sid);
		return StringHandler.getRetString(ResultPoor.getResult(sid));
	}

	public static String Withdraw(int begin, int end, String nick_name, String phone, String test5, String test6,
			String commi_id, String status) {
		StringBuffer sql = new StringBuffer();
		sql.append(FinanceSql.WithdrawListPage_sql);
		if (phone != null && !phone.equals("")) {
			sql.append(" and phone like '%").append(phone).append("%'");
		}
		if (nick_name != null && !nick_name.equals("")) {
			sql.append(" and nick_name like '%").append(nick_name).append("%'");
		}
		if ((test5 != null && !test5.equals("")) || (test6 != null && !test6.equals(""))) {
			String tests = Utils.transformToYYMMddHHmmss(test5);
			String teste = Utils.transformToYYMMddHHmmss(test6);
			sql.append(" and operation_time BETWEEN ").append(tests).append(" and ").append(teste);
		}
		if (commi_id != null && !commi_id.equals("")) {
			sql.append(" and commi_id like '%").append(commi_id).append("%'");
		}
		if (status != null && !status.equals("")) {
			if (status.equals("0")) {
				sql.append(" and status =").append(status).append("");
			} else {

				sql.append(" and status in (1,2)");
			}

		}
		int sid = BaseService.sendObjectBase(9997, sql.toString(), begin, end);

		return StringHandler.getRetString(ResultPoor.getResult(sid));
	}

	public static String WithdrawShowdetail(int begin, int end, int ids, String order_id) {
		StringBuffer sql = new StringBuffer();
		if (order_id == null || order_id.equals("null")) {
			sql.append(FinanceSql.WithdrawListPage_sql);
			sql.append(" and wallet.id= ").append(ids);
		} else {

			sql.append(FinanceSql.WithdrawListDetailPage_sql(ids, order_id));
		}

		int sid = BaseService.sendObjectBase(9997, sql.toString(), begin, end);

		return StringHandler.getRetString(ResultPoor.getResult(sid));
	}

	public static String WithdrawDetail(String id, int begin, int end, String name, String test5, String test6,
			String order_status, String earnings_type) {
		StringBuffer sql = new StringBuffer();
		sql.append(FinanceSql.WithdrawDetailPage_sql(id));
		if (name != null && !name.equals("")) {
			sql.append(" and USER.nick_name like '%").append(name).append("%'");
		}
		if ((test5 != null && !test5.equals("")) || (test6 != null && !test6.equals(""))) {
			String tests = Utils.transformToYYMMddHHmmss(test5);
			String teste = Utils.transformToYYMMddHHmmss(test6);

			sql.append(" and der.created_date BETWEEN ").append(tests).append(" and ").append(teste);
		}
		if (earnings_type != null && !earnings_type.equals("")) {
			sql.append(" and c.profit_source like '%").append(earnings_type).append("%'");
		}
		if (order_status != null && !order_status.equals("")) {
			if (order_status.equals("0")) {
				sql.append(" and der.STATUS in(109,110,112)");
			}
			if (order_status.equals("1")) {
				sql.append(" and der.STATUS =108");
			}
			if (order_status.equals("2")) {
				sql.append(" and der.STATUS in(101,102,103,104,105,106,107)");
			}
		}
		int sid = BaseService.sendObjectBase(9997, sql.toString(), begin, end);
		return StringHandler.getRetString(ResultPoor.getResult(sid));
	}

	public static String Agreerequest(String id, String order_id) {
		int sid = sendObjectCreate(91, id);
		String rsFinance = ResultPoor.getResult(sid);
		String rsFinanceJson = StringHandler.getRetString(rsFinance);
		if (order_id != null && !order_id.equals("")) {
			int sid2 = sendObjectCreate(93, order_id);
			String rsFinance2 = ResultPoor.getResult(sid2);
			String rsFinanceJson2 = StringHandler.getRetString(rsFinance2);
			return rsFinanceJson2;
		} else {
			return rsFinanceJson;
		}

	}

	public static String Rejectrequest(String reason, String id) {
		int sid = sendObjectCreate(94, reason, id);
		String rsFinance = ResultPoor.getResult(sid);
		String rsFinanceJson = StringHandler.getRetString(rsFinance);
		return rsFinanceJson;
	}

	public static String Getpeople(String user_id) {
		int sid = sendObject(92, user_id);
		String rsIndex = ResultPoor.getResult(sid);
		String OBIndex = StringHandler.getRetString(rsIndex);
		return OBIndex;

	}

	public static String abolishquest(String id) {
		int sid = sendObjectCreate(95, id);
		String rsFinance = ResultPoor.getResult(sid);
		String rsFinanceJson = StringHandler.getRetString(rsFinance);
		return rsFinanceJson;

	}
}
