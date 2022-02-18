<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.*"%>
<%@ page import="boardWeb.vo.*" %>
<%@ page import="boardWeb.util.*" %>
<%@ page import="java.io.File" %>
<%@ page import="com.oreilly.servlet.multipart.DefaultFileRenamePolicy" %> <!-- 파일 이름이 중복되면 알아서 변경해줌 -->
<%@ page import="com.oreilly.servlet.MultipartRequest" %> <!-- 파일 업로드를 실행할 수 있게 만들어줌 -->
<%
	Member login = (Member)session.getAttribute("loginUser");

	request.setCharacterEncoding("UTF-8");
	
	Connection conn = null;
	PreparedStatement psmt = null;
	
	String directory = application.getRealPath("/upload/"); //파일을 저장할 경로
	int maxSize = 1024 * 1024 * 100;      //사진 최대크기
	String encoding = "UTF-8";
	
	MultipartRequest multipartRequest
	= new MultipartRequest(request, directory, maxSize, encoding,
			new DefaultFileRenamePolicy());
	
	String subject = multipartRequest.getParameter("fsubject");
	String writer = multipartRequest.getParameter("fwriter");
	String content = multipartRequest.getParameter("fcontent");
	String fileName = multipartRequest.getOriginalFileName("file"); //파일 네임값으로 가져옴
	String fileRealName = multipartRequest.getFilesystemName("file"); //실제 파일 이름
	
	try{
		conn = DBManager.getConnection();
		
		String sql = "insert into board(bidx,subject,writer,content,midx,fileName,fileRealName,boardtype) values(bidx_seq.nextval,?,?,?,?,?,?,'free')";
		
		psmt = conn.prepareStatement(sql);
		
		psmt.setString(1,subject);
		psmt.setString(2,writer);
		psmt.setString(3,content);
		psmt.setInt(4,login.getMidx());
		psmt.setString(5,fileName);
		psmt.setString(6,fileRealName);
		
		int result = psmt.executeUpdate();
		
		response.sendRedirect("freeboardlist.jsp");
		
	}catch(Exception e){
		e.printStackTrace();
	}finally{
		DBManager.close(psmt, conn);
	}
%>