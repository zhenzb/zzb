package action;

import javax.json.JsonArray;
import javax.json.JsonObject;

import cache.StatementCache;
import execute.AbsExecute;
import execute.CreateExecute;
import execute.DeleteExecute;
import execute.RetrieveExecute;
import execute.SpePaginExecute;
import execute.TransExecute;
import execute.UpdateExecute;
import model.BannerStatement;

public class StatementAction {

	public String returnMsg;

	public StatementAction(JsonObject requestJo) {
		AbsExecute ae = null;
		// 此通道此消息唯一标识
		int sid = requestJo.getInt("sid");
		int mid = requestJo.getInt("mid");

		JsonArray parametersJa = requestJo.getJsonArray("pts");

		if (!StatementCache.statements.containsKey(mid)) {
			returnMsg = "{\"sid\":" + sid + ",\"success\":0,\"errorMessage\":\"mid不存在\"}";
		} else {
			BannerStatement bs = StatementCache.statements.get(mid);

			if (bs.getCategory() == 1) {
				ae = new CreateExecute();
			} else if (bs.getCategory() == 2) {
				ae = new UpdateExecute();
			} else if (bs.getCategory() == 3) {
				ae = new RetrieveExecute();
			} else if (bs.getCategory() == 4) {
				ae = new DeleteExecute();
			} else if (bs.getCategory() == 5) {
				ae = new TransExecute();
			} else if(bs.getCategory() == 6){
				ae = new SpePaginExecute();
			}
			ae.init(bs);
			JsonObject ruseltJo = ae.execute(sid, parametersJa);
			returnMsg = ruseltJo.toString();
		}
	}
}