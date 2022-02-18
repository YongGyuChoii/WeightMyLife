<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="boardWeb.util.*"%>
<%@ page import="org.json.simple.*" %>
<%@ page import="java.sql.*"%>
<%@ page import="boardWeb.vo.*"%>
<%
	Member login = (Member)session.getAttribute("loginUser");

	request.setCharacterEncoding("UTF-8");
	
	String modifyEmail1 = request.getParameter("modifyEmail1");
	String modifyEmail2 = request.getParameter("modifyEmail2");
	String midx = request.getParameter("midx");
	
	Connection conn = null;
	PreparedStatement psmt = null;
	
	try{
		conn = DBManager.getConnection();
		
		String sql = "update member set email1 = ?, email2 = ? where midx="+midx;
		
		psmt = conn.prepareStatement(sql);
		psmt.setString(1, modifyEmail1);
		psmt.setString(2, modifyEmail2);
		
		psmt.executeUpdate();
		
		
	}catch(Exception e){
		e.printStackTrace();
	}finally{
		DBManager.close(psmt,conn);
	}
%>    
