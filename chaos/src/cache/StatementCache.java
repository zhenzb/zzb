package cache;

import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;

import model.BannerStatement;

public class StatementCache{
	
	//缓存数据库SQL
	public static Map<Integer,BannerStatement> statements = new ConcurrentHashMap<Integer,BannerStatement>();
	
}