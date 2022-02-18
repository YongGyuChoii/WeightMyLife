<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="boardWeb.util.*"%>
<%@ page import="java.sql.*" %>
<%
	String midx = request.getParameter("midx");

	Connection conn = null;
	PreparedStatement psmt = null;
	
	try{
		conn = DBManager.getConnection();
		
		String sql = "UPDATE MEMBER SET Ranking = CASE WHEN Ranking='관리자' THEN '일반회원' WHEN Ranking='일반회원' THEN '관리자' ELSE 'null' END WHERE midx="+midx;
		
		psmt = conn.prepareStatement(sql);
		
		psmt.executeUpdate();
		
		
	}catch(Exception e){
		e.printStackTrace();
	}finally{
		DBManager.close(psmt,conn);
	}
%>