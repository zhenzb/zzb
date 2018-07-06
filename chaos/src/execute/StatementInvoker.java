package execute;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import cache.StatementCache;
import connect.BaseConnect;
import model.BannerStatement;

public class StatementInvoker{
	public StatementInvoker(){
		BaseConnect bc = new BaseConnect();
		try {
			PreparedStatement pstbs = bc.conn.prepareStatement("SELECT * FROM banner_statement");
			ResultSet rsbs = pstbs.executeQuery();
			
			while(rsbs.next()){
				
				BannerStatement bs = new BannerStatement();
				
				int bsid = rsbs.getInt("id");
				
				bs.setId(bsid);
				bs.setSpace(rsbs.getString("space"));
				bs.setMethod(rsbs.getString("method"));
				bs.setStatement(rsbs.getString("statement"));
				//分页情况查询总数的sql
				bs.setTotalStatement(rsbs.getString("total_statement"));
				bs.setCategory(rsbs.getInt("category"));
				bs.setIspro(rsbs.getInt("ispro"));
				bs.setProjectid(rsbs.getInt("projectid"));
				bs.setKeeper(rsbs.getString("keeper"));
				bs.setMemo(rsbs.getString("memo"));
				bs.setSqlmode(rsbs.getInt("sqlmode"));
				StatementCache.statements.put(bsid, bs);
				//为了查找出刷sql不生效,待用的数据输出
				System.out.println("bsid = "+bsid+" statement = "+rsbs.getString("statement"));
				
			}
			
			rsbs.close();
			pstbs.close();
			bc.conn.close();
			
		} catch (SQLException e) {
			e.printStackTrace();
		}
		
	}
}