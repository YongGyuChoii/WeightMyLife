<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.*"%>
<%@ page import="boardWeb.util.*" %>
<%
	request.setCharacterEncoding("UTF-8");
	
	String memberid = request.getParameter("memberid");
	String memberpwd = request.getParameter("memberpwd");
	String membername = request.getParameter("membername");
	String addr = request.getParameter("addr");
	String gender = request.getParameter("gender");
	String email1 = request.getParameter("email1");
	String email2 = request.getParameter("email2");
	String phone1 = request.getParameter("phone1");
	String phone2 = request.getParameter("phone2");
	String phone3 = request.getParameter("phone3");
	String age = request.getParameter("age");
	
	Connection conn = null;
	PreparedStatement psmt = null;
	
	try{
		conn = DBManager.getConnection();
		
		String sql = "insert into member(midx,memberid,memberpwd,membername,addr,gender,email1,email2,phone1,phone2,phone3,age) "+
		             "values(midx_seq.nextval,?,?,?,?,?,?,?,?,?,?,?)";
		
		psmt = conn.prepareStatement(sql);
		
		psmt.setString(1, memberid);
		psmt.setString(2, memberpwd);
		psmt.setString(3, membername);
		psmt.setString(4, addr);
		psmt.setString(5, gender);
		psmt.setString(6, email1);
		psmt.setString(7, email2);
		psmt.setInt(8, Integer.parseInt(phone1));
		psmt.setInt(9, Integer.parseInt(phone2));
		psmt.setInt(10, Integer.parseInt(phone3));
		psmt.setInt(11, Integer.parseInt(age));
		
		psmt.executeUpdate();
		
		response.sendRedirect("../index.jsp");
	}catch(Exception e){
		e.printStackTrace();
	}finally{
		DBManager.close(psmt,conn);
	}
%>
