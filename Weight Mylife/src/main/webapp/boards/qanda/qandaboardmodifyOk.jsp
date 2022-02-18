<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="boardWeb.util.*" %>
<%	
	request.setCharacterEncoding("UTF-8");
	
	String subject = request.getParameter("fsubject");
	String content = request.getParameter("fcontent");
	String bidx = request.getParameter("fbidx");
	
	Connection conn = null;
	PreparedStatement psmt = null;
	
	try{
		conn=DBManager.getConnection();
		
		String sql = "update board set subject='"+subject+"' "+",content='"+content+"' "+"where bidx="+bidx;
		
		psmt = conn.prepareStatement(sql);
		
		psmt.executeUpdate();
		
		response.sendRedirect("qandaboardview.jsp?bidx="+bidx);

	}catch(Exception e){
		e.printStackTrace();
	}finally{
		DBManager.close(psmt, conn);
	}
%>    