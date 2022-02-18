<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="boardWeb.util.*"%>
<%@ page import="org.json.simple.*" %>
<%@ page import="java.sql.*"%>
<%@ page import="boardWeb.vo.*"%>
<%
	Member login = (Member)session.getAttribute("loginUser");

	request.setCharacterEncoding("UTF-8");
	
	String modifyPhone1 = request.getParameter("modifyPhone1");
	String modifyPhone2 = request.getParameter("modifyPhone2");
	String modifyPhone3 = request.getParameter("modifyPhone3");
	String midx = request.getParameter("midx");
	
	Connection conn = null;
	PreparedStatement psmt = null;
	
	try{
		conn = DBManager.getConnection();
		
		String sql = "update member set phone1 = ?, phone2 = ?, phone3 = ? where midx="+midx;
		
		psmt = conn.prepareStatement(sql);
		psmt.setInt(1, Integer.parseInt(modifyPhone1));
		psmt.setInt(2, Integer.parseInt(modifyPhone2));
		psmt.setInt(3, Integer.parseInt(modifyPhone3));
		
		psmt.executeUpdate();
		
		
	}catch(Exception e){
		e.printStackTrace();
	}finally{
		DBManager.close(psmt,conn);
	}
%>    
