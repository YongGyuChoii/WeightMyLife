<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.*"%>
<%@ page import="boardWeb.util.*" %>
<%
	request.setCharacterEncoding("UTF-8");

	String email1 = request.getParameter("email1");
	String email2 = request.getParameter("email2");
	
	Connection conn = null;
	PreparedStatement psmt = null;
	ResultSet rs = null;
	String memberid = "";
	
	try{
		conn = DBManager.getConnection();
		
		String sql = "select * from member where email1='"+email1+"'"+" and email2='"+email2+"'";
		psmt = conn.prepareStatement(sql);
		
		rs = psmt.executeQuery();
		
		if(rs.next()){
			memberid = rs.getString("memberid");
		}else {
			memberid = "찾는 아이디가 없습니다.";
		}
		out.print(memberid);
	}catch(Exception e){
		e.printStackTrace();
	}finally{
		DBManager.close(psmt,conn,rs);
	}
%>