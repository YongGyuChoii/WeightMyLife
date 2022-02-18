<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="boardWeb.util.*"%>
<%@ page import="org.json.simple.*" %>
<%@ page import="java.sql.*"%>
<%
	request.setCharacterEncoding("UTF-8");

	String ridx = request.getParameter("fridx");
	String rcontent = request.getParameter("frcontent");
	
	Connection conn = null;
	PreparedStatement psmt = null;
	
	try{
		conn = DBManager.getConnection();
		
		String sql = "update reply set rcontent = ? where ridx="+ridx;
		
		psmt = conn.prepareStatement(sql);
		psmt.setString(1, rcontent);
		
		psmt.executeUpdate();
		
		
	}catch(Exception e){
		e.printStackTrace();
	}finally{
		DBManager.close(psmt,conn);
	}
%>