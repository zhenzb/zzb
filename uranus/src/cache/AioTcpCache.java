package cache;

import java.util.ArrayList;
import java.util.Random;

import aioclient.AioTcpClient;

public class AioTcpCache {
	public static AioTcpClient ctc;
	public static AioTcpClient gtc;
	public static ArrayList<AioTcpClient> ctcs = new ArrayList<AioTcpClient>();

	public static AioTcpClient getCtc() {
		Random rand = new Random();
		return ctcs.get(rand.nextInt(ctcs.size()));
	}
	
	
}