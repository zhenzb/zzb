package execute;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.ResultSetMetaData;
import java.sql.SQLException;

import javax.json.JsonArray;
import javax.json.JsonArrayBuilder;
import javax.json.JsonObject;
import javax.json.JsonObjectBuilder;

import connect.ProjectConnect;
import connect.ProjectPoor;

public class RetrieveExecute extends AbsExecute {
	@Override
	public JsonObject execute(int sid, JsonArray parameters) {
		JsonObjectBuilder job = factory.createObjectBuilder();
		
		boolean isE = false;
		
		ProjectPoor pp = ProjectConnect.getConnection(mbs.getProjectid(), 1);
		Connection c = pp.getConn();

		
		try {
			String Sql = mbs.getStatement();
			Sql = Sql + parameters.getString(0);
			String ListSql = Sql;
			int size = parameters.size();
			int total = 0;
			if (mbs.getSqlmode() == 1) {
				ListSql = ListSql + " limit ? , ?";
				PreparedStatement countPS = c
						.prepareStatement("select count(*) as total from (" + Sql + ") as totaltable");
				System.out.println("select count(*) as total from (" + Sql + ") as totaltable");
				for (int i = 1; i < size - 2; i++) {
					JsonObject jo = parameters.getJsonObject(i);

					int parameterType = jo.getInt("type");
					if (parameterType == 1) {
						// 字符型
						countPS.setString(i, jo.getString("value"));
						System.out.println(jo.getString("value"));
					} else if (parameterType == 2) {
						// 整型
						countPS.setInt(i, jo.getInt("value"));
						System.out.println(jo.getInt("value"));
					}
				}
				countPS.setQueryTimeout(20);
				ResultSet rs = countPS.executeQuery();

				while (rs.next()) {
					total = rs.getInt("total");
				}

			}

			PreparedStatement ps = c.prepareStatement(ListSql);
			System.out.println(ListSql);

			for (int i = 1; i < size; i++) {
				JsonObject jo = parameters.getJsonObject(i);

				int parameterType = jo.getInt("type");
				if (parameterType == 1) {
					// 字符型
					ps.setString(i, jo.getString("value"));
					System.out.println(jo.getString("value"));
				} else if (parameterType == 2) {
					// 整型
					ps.setInt(i, jo.getInt("value"));
					System.out.println(jo.getInt("value"));
				}
			}
			ps.setQueryTimeout(20);
			ResultSet rs = ps.executeQuery();

			ResultSetMetaData rsmd = rs.getMetaData(); // 得到结果集的定义结构
			int colCount = rsmd.getColumnCount(); // 得到列的总数

			

			JsonArrayBuilder jab = factory.createArrayBuilder();

			while (rs.next()) {

				JsonObjectBuilder rsJob = factory.createObjectBuilder();
				for (int i = 1; i <= colCount; i++) {
					// String type = rsmd.getColumnTypeName(i); // 获取字段类型
					String value = rs.getString(i);
					rsJob.add(rsmd.getColumnLabel(i), value == null ? "" : value);
				}
				jab.add(rsJob);
			}

			rs.close();

			job.add("total", total);
			JsonObject ruseltJo = job.add("rs", jab).build();
			
			CreateResultJson(sid, 1, "", ruseltJo);

		} catch (Exception e) {
			e.printStackTrace();
			System.out.println("分隔符-----------------");
			System.out.println(e.getMessage());
			System.out.println(e.getMessage().indexOf("Communications link failure"));
			System.out.println("分隔符-----------------");
			if (e.getMessage().indexOf("Communications link failure") != -1) {
				isE = true;
				try {
					Connection newc = DriverManager.getConnection(pp.mJdbcUrl, pp.mUser, pp.mPassword);
					pp.replace(c, newc);
					RetrieveExecute re = new RetrieveExecute();
					re.init(mbs);
					return re.execute(sid, parameters);
				} catch (SQLException e1) {
					e1.printStackTrace();
					System.out.println("数据库连接超时失效，重新创建，创建失败");
				}
				System.out.println("数据库连接超时失效，重新创建");
			}else{
				CreateResultJson(sid, 0, e.getMessage() ,job.build());
			}
		} finally {
			if(!isE)
			pp.close(c);
		}

		return resultJson.build();
	}

}