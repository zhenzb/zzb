package connect;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Random;

import model.BannerProjectSource;

public class ProjectWeight {

	// 每个连接ID对应的连接池
	private Map<Integer, ProjectPoor> pwm = new HashMap<Integer, ProjectPoor>();

	// 每个ID对应的对象
	private Map<Integer, BannerProjectSource> bpss = new HashMap<Integer, BannerProjectSource>();

	// 根据权重，将对象引用加入数组
	private List<ProjectPoor> pwl = new ArrayList<ProjectPoor>();

	public ProjectWeight() {

	}

	public void addBannerProjectSource(BannerProjectSource bps) {

		ProjectPoor pp = new ProjectPoor(bps);

		pwm.put(bps.getId(), pp);

		bpss.put(bps.getId(), bps);

		int weight = bps.getWeight();

		for (int i = 0; i < weight; i++) {
			pwl.add(pp);
		}
	}
	
	public ProjectPoor getProjectPoor(){
		int size = pwl.size();
		Random ra =new Random();
		int rd = ra.nextInt(size);
		return pwl.get(rd);
	}
	
	

}