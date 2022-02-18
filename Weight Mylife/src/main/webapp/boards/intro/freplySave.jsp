<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@page import="boardWeb.util.*"%>
<%@ page import="java.sql.*" %>
<%@ page import="org.json.simple.*"%>
<%
	request.setCharacterEncoding("UTF-8");
	String rcontent = request.getParameter("frcontent");
	String bidx = request.getParameter("fbidx");
	String midx = request.getParameter("midx");
	String memberName = request.getParameter("memberName");
	
	Connection conn = null;
	PreparedStatement psmt = null;
	ResultSet rs = null;
	
	try{
		conn = DBManager.getConnection();
		
		String sql = "insert into reply(ridx,rcontent,midx,bidx,replyType) values(ridx_seq.nextval,?,?,?,'introduce')";
		psmt = conn.prepareStatement(sql);
		psmt.setString(1, rcontent);
		psmt.setInt(2, Integer.parseInt(midx));
		psmt.setInt(3, Integer.parseInt(bidx));
		
		psmt.executeUpdate();
		
		sql = "select * from reply where ridx = (select max(ridx) from reply)";
		
		psmt = null;
		psmt = conn.prepareStatement(sql);
		
		rs = psmt.executeQuery();
		
		JSONArray list = new JSONArray();
		
		if(rs.next()){
			JSONObject obj = new JSONObject();
			obj.put("ridx", rs.getInt("ridx"));
			obj.put("midx", rs.getInt("midx"));
			obj.put("bidx", rs.getInt("bidx"));
			obj.put("rcontent", rs.getString("rcontent"));
			obj.put("rdate", rs.getString("rdate"));
			obj.put("memberName", memberName);
			
			list.add(obj);
		}
		out.print(list.toJSONString());
	}catch(Exception e){
		e.printStackTrace();
	}finally{
		DBManager.close(psmt, conn, rs);
	}
%>