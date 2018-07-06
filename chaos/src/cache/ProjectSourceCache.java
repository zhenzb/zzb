package cache;

import java.util.Collections;
import java.util.HashMap;
import java.util.Map;

import model.BannerProjectBase;
import model.BannerProjectSource;

public class ProjectSourceCache{
	
	//数据库连接池项目集合
	public static Map<Integer,BannerProjectBase> ProjectBases = Collections.synchronizedMap(new HashMap<Integer,BannerProjectBase>());

	//数据库连接池配置
	public static Map<Integer,BannerProjectSource> ProjectSources = Collections.synchronizedMap(new HashMap<Integer,BannerProjectSource>());
	
	//每个数据库项目，对应的数据库连接池集合
	public static Map<Integer,Map<Integer,BannerProjectSource>> ProjectBasesSources = Collections.synchronizedMap(new HashMap<Integer,Map<Integer,BannerProjectSource>>());

}