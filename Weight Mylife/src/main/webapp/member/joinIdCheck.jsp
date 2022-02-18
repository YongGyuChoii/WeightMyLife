<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.*"%>
<%@ page import="boardWeb.util.*" %>
<%
	request.setCharacterEncoding("UTF-8");

	String memberid = request.getParameter("memberid");
	
	Connection conn = null;
	PreparedStatement psmt = null;
	ResultSet rs = null;
	int idCheck = 0;
	
	try{
		conn = DBManager.getConnection();
		
		String sql = "select * from member where memberid='"+memberid+"'";
		psmt = conn.prepareStatement(sql);
		
		rs = psmt.executeQuery();
		
		if(rs.next() || memberid.equals("")){
			idCheck = 0;
		}else {
			idCheck = 1;
		}
		out.print(idCheck);
	}catch(Exception e){
		e.printStackTrace();
	}finally{
		DBManager.close(psmt,conn,rs);
	}
%>