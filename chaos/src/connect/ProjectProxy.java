package connect;

import java.util.Iterator;
import java.util.Map;

import cache.ProjectSourceCache;
import model.BannerProjectSource;

/**
 * @ClassName: ProjectProxy
 * @Description: 实现读写分离代理
 * @author jiangshidi
 * @date 2016年10月5日 下午4:06:12
 * 
 */
public class ProjectProxy {

	private ProjectWeight readProjectWeight = new ProjectWeight();

	private ProjectWeight writeProjectWeight = new ProjectWeight();

	public ProjectProxy() {

	}

	public void addProject(int projectBaseId) {

		Map<Integer, BannerProjectSource> BannerProjectSources = ProjectSourceCache.ProjectBasesSources
				.get(projectBaseId);

		Iterator<Integer> keys = BannerProjectSources.keySet().iterator();

		while (keys.hasNext()) {
			Integer key = keys.next();
			BannerProjectSource bps = BannerProjectSources.get(key);

			int isMaster = bps.getIsMaster();
			if (isMaster == 1) {
				writeProjectWeight.addBannerProjectSource(bps);
			} else {
				readProjectWeight.addBannerProjectSource(bps);
			}
		}
	}
	
	public ProjectPoor getProjectPoor(int rw){
		if( rw == 1 ){
			return	writeProjectWeight.getProjectPoor();
		}else{
			return readProjectWeight.getProjectPoor();
		}
	}
	

}