package execute;

import javax.json.Json;
import javax.json.JsonArray;
import javax.json.JsonBuilderFactory;
import javax.json.JsonObject;
import javax.json.JsonObjectBuilder;

import model.BannerStatement;

public abstract class AbsExecute {

	public BannerStatement mbs;
	public JsonBuilderFactory factory = Json.createBuilderFactory(null);
	public JsonObjectBuilder resultJson = factory.createObjectBuilder();

	public void init(BannerStatement bs) {
		mbs = bs;
	}

	public abstract JsonObject execute(int sid, JsonArray parameters);

	public void CreateResultJson(int sid,int success, String errorMessage, JsonObject resultJo) {
		resultJson.add("sid", sid).add("success", success).add("errorMessage", errorMessage).add("result", resultJo);
	}
}