package action;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import execute.StatementInvoker;
@WebServlet(name = "WSA", urlPatterns = "/wsa")
public class SecretAction extends HttpServlet{

	/**
	 * 
	 */
	private static final long serialVersionUID = -8498276214443162876L;

	//更新整个SQL集合
	public String upStatementAll(){
		StatementInvoker si = new StatementInvoker();
		return "true";
	}
	
	public void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
			this.doPost(request, response);
    }

    public void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
    		
    		System.out.println("??????");
    		String t = request.getParameter("t");
    		if(t.equals("1")){
    			upStatementAll();
    			System.out.println("刷新sql--upStatementAll()");
    		}   	        		
    	
    }

}