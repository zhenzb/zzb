package connect;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Collections;
import java.util.HashMap;
import java.util.Iterator;
import java.util.Map;

import cache.ProjectSourceCache;
import model.BannerProjectBase;
import model.BannerProjectSource;

public class ProjectConnect{
	
	private static Map<Integer,ProjectProxy> pps = Collections.synchronizedMap(new HashMap<Integer,ProjectProxy>()); 
	
	public ProjectConnect(){
		
		BaseConnect bc = new BaseConnect();
		
		
		try {
			PreparedStatement pstbpb = bc.conn.prepareStatement("SELECT * FROM banner_project_base");
			ResultSet rsbpb = pstbpb.executeQuery();
			
			PreparedStatement pstbps = bc.conn.prepareStatement("SELECT * FROM banner_project_source where baseid = ?");
			
			while(rsbpb.next()){
				
				int baseid = rsbpb.getInt("id");
				
				BannerProjectBase bpb = new BannerProjectBase();
				bpb.setId(baseid);
				bpb.setName(rsbpb.getString("name"));
				
				ProjectSourceCache.ProjectBases.put(baseid, bpb);
				
				pstbps.setInt(1, baseid);
				ResultSet rsbps = pstbps.executeQuery();
				
				Map<Integer,BannerProjectSource> bpss = new HashMap<Integer,BannerProjectSource>();
				
				while(rsbps.next()){
					int bpsid = rsbps.getInt("id");					
					
					BannerProjectSource bps = new BannerProjectSource();
					
					bps.setId(bpsid);
					bps.setBaseId(baseid);
					bps.setIsMaster(rsbps.getInt("ismaster"));
					bps.setUrl(rsbps.getString("url"));
					bps.setUser(rsbps.getString("user"));
					bps.setPwd(rsbps.getString("pwd"));
					bps.setConnections(rsbps.getInt("connections"));
					bps.setWeight(rsbps.getInt("weight"));
					bps.setDriverClass(rsbps.getString("driverClass"));
					
					ProjectSourceCache.ProjectSources.put(bpsid, bps);
					
					bpss.put(bpsid, bps);
					
				}
				
				ProjectSourceCache.ProjectBasesSources.put(baseid, bpss);
				
				rsbps.close();
				
			}
			
			pstbps.close();
			
			rsbpb.close();
			pstbpb.close();
			
			bc.conn.close();
			
			Iterator<Integer> keys = ProjectSourceCache.ProjectBases.keySet().iterator();
			
			while (keys.hasNext()) {
				ProjectProxy pp = new ProjectProxy();
				Integer key = keys.next();
				pp.addProject(key);
				
				pps.put(key, pp);
			}

		} catch (SQLException e) {
			e.printStackTrace();
		}
	}
	
	public static ProjectPoor getConnection(int projectId,int rw){
		ProjectProxy pp = pps.get(projectId);
		return pp.getProjectPoor(rw);
	}
	
}