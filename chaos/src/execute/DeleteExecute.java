package execute;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;

import javax.json.JsonArray;
import javax.json.JsonObject;

import connect.ProjectConnect;
import connect.ProjectPoor;

public class DeleteExecute extends AbsExecute{
	@Override
	public JsonObject execute(int sid, JsonArray parameters) {

		ProjectPoor pp = ProjectConnect.getConnection(mbs.getProjectid(), 1);
		Connection c = pp.getConn();
		try {
			PreparedStatement ps = c.prepareStatement(mbs.getStatement());

			int size = parameters.size();
			for (int i = 0; i < size; i++) {
				JsonObject jo = parameters.getJsonObject(i);

				int parameterType = jo.getInt("type");
				if (parameterType == 1) {
					// 字符型
					ps.setString(i + 1, jo.getString("value"));
				} else if (parameterType == 2) {
					// 整型
					ps.setInt(i + 1, jo.getInt("value"));
				}
			}

			int s = ps.executeUpdate();

			JsonObject ruseltJo = factory.createObjectBuilder().add("num", s).build();

			CreateResultJson(sid, 1, "", ruseltJo);

		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			pp.close(c);
		}

		return resultJson.build();
	}

}