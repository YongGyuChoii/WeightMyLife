<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.*"%>
<%@ page import="boardWeb.util.*" %>
<%
	request.setCharacterEncoding("UTF-8");

	String email1 = request.getParameter("email1");
	String email2 = request.getParameter("email2");
	String memberid = request.getParameter("memberid");
	
	Connection conn = null;
	PreparedStatement psmt = null;
	ResultSet rs = null;
	String memberPwd = "";
	
	try{
		conn = DBManager.getConnection();
		
		String sql = "select * from member where email1='"+email1+"'"+" and email2='"+email2+"'"+" and memberid='"+memberid+"'";
		psmt = conn.prepareStatement(sql);
		
		rs = psmt.executeQuery();
		
		if(rs.next()){
			memberPwd = rs.getString("memberpwd");
		}else {
			memberPwd = "찾는 비밀번호가 없습니다.";
		}
		out.print(memberPwd);
	}catch(Exception e){
		e.printStackTrace();
	}finally{
		DBManager.close(psmt,conn,rs);
	}
%>