package execute;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Statement;

import javax.json.JsonArray;
import javax.json.JsonArrayBuilder;
import javax.json.JsonObject;

import connect.ProjectConnect;
import connect.ProjectPoor;

public class CreateExecute extends AbsExecute {

	@Override
	public JsonObject execute(int sid, JsonArray parameters) {

		ProjectPoor pp = ProjectConnect.getConnection(mbs.getProjectid(), 1);
		Connection c = pp.getConn();
		try {
			PreparedStatement ps = c.prepareStatement(mbs.getStatement(),Statement.RETURN_GENERATED_KEYS);

			int size = parameters.size();
			for (int i = 0; i < size; i++) {
				JsonObject jo = parameters.getJsonObject(i);

				int parameterType = jo.getInt("type");
				if (parameterType == 1) {
					// 字符型
					if(jo.getString("value").equals(""))
						ps.setString(i + 1, null);
					else
						ps.setString(i + 1, jo.getString("value"));
				} else if (parameterType == 2) {
					// 整型
					ps.setInt(i + 1, jo.getInt("value"));
				}
			}

			JsonArrayBuilder ruseltIds = factory.createArrayBuilder();
			ps.setQueryTimeout(10);
			int s = ps.executeUpdate();
			ResultSet rs = ps.getGeneratedKeys(); 
			if (rs.next()) {
				int pid = rs.getInt(1);
				System.out.println("数据主键：" + pid);
				ruseltIds.add(pid);
			}
			
			JsonObject ruseltJo = factory.createObjectBuilder().add("num", s).add("ids", ruseltIds).build();

			CreateResultJson(sid, 1, "", ruseltJo);

		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			pp.close(c);
		}

		return resultJson.build();
	}

}