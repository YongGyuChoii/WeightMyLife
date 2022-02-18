<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.*"%>
<%@ page import="boardWeb.util.*"%>
<%@ page import="boardWeb.vo.*"%>
<%
	request.setCharacterEncoding("UTF-8");

	String memberid = request.getParameter("memberid");
	String memberpwd = request.getParameter("memberpwd");
	
	Connection conn = null;
	PreparedStatement psmt = null;
	ResultSet rs = null;
	
	try{
		
		conn = DBManager.getConnection();
		
		String sql = "select * from member where memberid = ? and memberpwd = ?";
		
		psmt = conn.prepareStatement(sql);
		psmt.setString(1,memberid);
		psmt.setString(2,memberpwd);
		
		rs = psmt.executeQuery();
		
		Member m = null;
		
		if(rs.next()){
			m = new Member();
			m.setMidx(rs.getInt("midx"));
			m.setMemberid(rs.getString("memberid"));
			m.setMembername(rs.getString("membername"));
			m.setEmail1(rs.getString("email1"));
			m.setEmail2(rs.getString("email2"));
			m.setRanking(rs.getString("ranking"));
			m.setPhone1(rs.getInt("phone1"));
			m.setPhone2(rs.getInt("phone2"));
			m.setPhone3(rs.getInt("phone3"));
			m.setAddr(rs.getString("addr"));
			m.setAge(rs.getInt("age"));
			m.setMdate(rs.getString("mdate"));
			m.setRanking(rs.getString("ranking"));
			m.setMemberpwd(rs.getString("memberpwd"));
			
			session.setAttribute("loginUser", m);
		}
		
		if(m != null){
			response.sendRedirect(request.getContextPath());
		}else{
			response.sendRedirect("login.jsp");
		}
		
	}catch(Exception e){
		e.printStackTrace();
	}finally{
		DBManager.close(psmt,conn,rs);
	}
%>