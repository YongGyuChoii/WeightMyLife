<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="boardWeb.util.*"%>
<%@ page import="org.json.simple.*" %>
<%@ page import="java.sql.*"%>
<%@ page import="boardWeb.vo.*"%>
<%
	Member login = (Member)session.getAttribute("loginUser");

	request.setCharacterEncoding("UTF-8");
	
	String modifyId = request.getParameter("modifyId");
	String midx = request.getParameter("midx");
	
	Connection conn = null;
	PreparedStatement psmt = null;
	
	try{
		conn = DBManager.getConnection();
		
		String sql = "update member set memberid = ? where midx="+midx;
		
		psmt = conn.prepareStatement(sql);
		psmt.setString(1, modifyId);
		
		psmt.executeUpdate();
		
		
	}catch(Exception e){
		e.printStackTrace();
	}finally{
		DBManager.close(psmt,conn);
	}
%>    
