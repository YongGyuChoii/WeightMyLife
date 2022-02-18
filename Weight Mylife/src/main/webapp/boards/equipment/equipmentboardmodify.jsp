<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="boardWeb.util.*" %>
<%	
	request.setCharacterEncoding("UTF-8");
	
	String esubject = request.getParameter("esubject");
	String econtent = request.getParameter("econtent");
	String ebidx = request.getParameter("ebidx");
	
	Connection conn = null;
	PreparedStatement psmt = null;
	
	try{
		conn=DBManager.getConnection();
		
		String sql = "update equipmentboard set esubject='"+esubject+"' "+",econtent='"+econtent+"' "+"where ebidx="+ebidx;
		
		psmt = conn.prepareStatement(sql);
		
		psmt.executeUpdate();

	}catch(Exception e){
		e.printStackTrace();
	}finally{
		DBManager.close(psmt, conn);
	}
%>    