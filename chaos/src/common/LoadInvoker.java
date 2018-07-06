package common;

import java.io.UnsupportedEncodingException;
import java.net.SocketAddress;

import javax.json.JsonObject;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;

import com.alibaba.fastjson.JSONArray;
import com.alibaba.fastjson.JSONObject;

import action.StatementAction;
import cache.ResultPoor;
import connect.ProjectConnect;
import execute.StatementInvoker;
import socket.AioTcpServer;

/**
 * @ClassName: LoadInvoker
 * @Description: TODO(工程启动加载类)
 * @author jiangshidi
 * @date 2016年9月14日 下午5:42:32
 * 
 */

@WebServlet(loadOnStartup = 1, urlPatterns = { "/dwr-invoker" })
public class LoadInvoker extends HttpServlet {
	/**
	 * @Fields serialVersionUID : TODO(序列化)
	 */
	private static final long serialVersionUID = 1L;

	public void init() {
		System.out.println(1);
		new PropertiesConf().init();
		
		//初始化socket连接池
		try {
			//
			AioTcpServer server = new AioTcpServer(PropertiesConf.SOCKETPORT) {
				
				@Override
				public String doSomething(JsonObject jo, SocketAddress address) {
					StatementAction at = new StatementAction(jo);
					return at.returnMsg;
				}
			};
			new Thread(server).start();
		} catch (Exception e) {
			e.printStackTrace();
		}

		//初始化数据库连接池
		new Thread() {
			@Override
			public void run() {
				new ProjectConnect();
				super.run();
			}
		}.start();

		//初始化statement缓存数据
		new Thread() {
			@Override
			public void run() {
				new StatementInvoker();
				super.run();
			}
		}.start();
		
		
		
		new Thread() {
			public void run() {
				aioclient.AioTcpClient atc = new aioclient.AioTcpClient() {
					@Override
					public void disconnect() {

					}
				};
				try {
					String[] uri = PropertiesConf.PHANTOM.split(":");

					atc.start(uri[0], Integer.valueOf(uri[1]), Integer.valueOf(uri[2]));

					//注册中心链接
					int sid = ResultPoor.sid.incrementAndGet();
					JSONObject mjo = new JSONObject();
					mjo.put("port", PropertiesConf.SOCKETPORT);
					mjo.put("id", uri[3]);
					mjo.put("sid", sid);
					mjo.put("mid", 0);
					atc.send(mjo.toString());
					
					ResultPoor.getResult(sid);
					
					//取得注册中心数
					int sid1= ResultPoor.sid.incrementAndGet();
					
					JSONObject mjo1 = new JSONObject();
					mjo1.put("id", "phantom");
					mjo1.put("sid", sid1);
					mjo1.put("mid", 2);
					atc.send(mjo1.toString());
					
					Thread.sleep(1000);
					
					JSONObject jo = new JSONObject().parseObject(ResultPoor.getResult(sid1));
					JSONArray ja = jo.getJSONArray("result");
					
					for(int i=0;i<ja.size();i++) {
						String urix = ja.getString(i);
						System.out.println(urix);
						int sid3= ResultPoor.sid.incrementAndGet();
						String[] uri3 = urix.split(":");
						aioclient.AioTcpClient atc1 = new aioclient.AioTcpClient() {
							@Override
							public void disconnect() {

							}
						};
						atc1.start(uri3[0], Integer.valueOf(uri3[1]), 1);
						
						JSONObject mjo2 = new JSONObject();
						mjo2.put("port", PropertiesConf.SOCKETPORT);
						mjo2.put("id", "chaos");
						mjo2.put("sid", sid3);
						mjo2.put("mid", 0);
						atc1.send(mjo2.toString());
						
						ResultPoor.getResult(sid3);
						
					}
					
					
				} catch (UnsupportedEncodingException e) {
					e.printStackTrace();
				} catch (InterruptedException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}
			};
		}.start();
		
		
		
	}
}