package execute;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;

import javax.json.JsonArray;
import javax.json.JsonObject;

import connect.ProjectConnect;
import connect.ProjectPoor;

public class TransExecute extends AbsExecute {

	@Override
	public JsonObject execute(int sid, JsonArray parameters) {
		System.out.println(mbs.getProjectid());
		ProjectPoor pp = ProjectConnect.getConnection(mbs.getProjectid(), 1);
		Connection c = pp.getConn();

		try {
			c.setAutoCommit(false);

			PreparedStatement ps = null;
			ArrayList<Integer> ids = new ArrayList<Integer>();
			for (int i = 0; i < parameters.size(); i++) {
				JsonObject jo = parameters.getJsonObject(i);

				String SQL = jo.getString("SQL");
				JsonArray SQLPS = jo.getJsonArray("SQLPS");
				ps = c.prepareStatement(SQL,Statement.RETURN_GENERATED_KEYS);

				for (int pi = 0; pi < SQLPS.size(); pi++) {
					JsonObject psjo = SQLPS.getJsonObject(pi);
					int parameterType = psjo.getInt("type");
					if (parameterType == 1) {
						if(psjo.getString("value").equals(""))
							ps.setString(pi + 1, null);
						else
							ps.setString(pi + 1, psjo.getString("value"));
					} else if (parameterType == 2) {
						// 整型
						ps.setInt(pi + 1, psjo.getInt("value"));
					} else if (parameterType == 3) {
						// 整型/取返回主键
						ps.setInt(pi + 1, ids.get(psjo.getInt("value")));
					}
				}
				
				ps.executeUpdate();
				
				ResultSet rs = ps.getGeneratedKeys(); 
				if (rs.next()) {
					int pid = rs.getInt(1);
					System.out.println("数据主键：" + pid);
					ids.add(pid);
				}
				rs.close();
			}
			//ps.executeBatch();
			c.commit();
			
			JsonObject ruseltJo = factory.createObjectBuilder().add("num", parameters.size()).add("ids", ids.toString()).build();

			CreateResultJson(sid, 1, "", ruseltJo);

			return resultJson.build();
			
		} catch (Exception e) {
			e.printStackTrace();
			try {
				CreateResultJson(sid, 0, "fail", factory.createObjectBuilder().build());
				System.out.println("回滚");
				c.rollback();
			} catch (SQLException e1) {
				System.out.println("回滚失败");
				e1.printStackTrace();
			}
		} finally {
			try {
				c.setAutoCommit(true);
				pp.close(c);
			} catch (SQLException e) {
				System.out.println("自动提交");
				e.printStackTrace();
			}
		}

		return resultJson.build();
	}

}