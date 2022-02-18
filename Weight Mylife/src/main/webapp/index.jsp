<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="boardWeb.util.*" %>
<%@ page import="boardWeb.vo.*" %>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.*" %>
<%@ page import="live.*" %>
<%
	Member login = (Member)session.getAttribute("loginUser");

	Connection conn = null;
	PreparedStatement psmt = null;
	ResultSet rs = null;
	int bestCount = 1;
	ArrayList<LiveDTO> lList = new ArrayList<>();
	
	try {
		conn = DBManager.getConnection();
		String sql = "SELECT * FROM (SELECT ROWNUM r,b.* FROM (SELECT * FROM board ORDER BY likey desc) b) WHERE r>=1 AND r<=5";
		psmt = conn.prepareStatement(sql);
		rs = psmt.executeQuery();
		while(rs.next()){
			LiveDTO live = new LiveDTO();
			live.setBidx(rs.getInt("bidx"));
			live.setSubject(rs.getString("subject"));
			live.setBoardType(rs.getString("boardType"));
			lList.add(live);
		}
	}catch(Exception e){
		e.printStackTrace();
	}finally{
		DBManager.close(psmt, conn, rs);
	}
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Weight My Life</title>
<link rel="stylesheet" href="<%=request.getContextPath() %>/static/bootstrap.min.css" />
<link rel="stylesheet" href="<%=request.getContextPath() %>/static/index.css" />
</head>
<body>
	<div id="wrap">
		<%@include file = "header.jsp" %> 
		<section>
			<hr style="border: solid black 1px">
			<div class="main-img2">
				<img src="<%=request.getContextPath() %>/static/main.jpg" alt="메인이미지" class="main-img" />
			</div>
			<div class="main-text">
				<p><span>자</span>신과 타협하지 말라.</p>
				<p><span>타</span>협하는 순간</p>
				<p><span>끝</span>이다.</p>
			</div>
			<div class="main-ques">
				<div class="card text-white bg-secondary mb-3"
					style="max-width: 18rem;">
					<div class="card-header">트레이너 등록문의</div>
					<div class="card-body">
						<h5 class="card-title">TEL: 010-4334-1293</h5>
						<p class="card-text">
							FAX: 1111-1111 
						</p>
						<p class="card-text">
							이메일: dydrb219@naver.com
						</p>
					</div>
				</div>
			</div>
			<div class="main-scroll">
				<div class="card border-secondary mb-3" style="width: 15rem;">
					<ul class="list-group list-group-flush">
						<li class="list-group-item active"><span>실시간 게시글 TOP5</span></li>
						<%for(LiveDTO l : lList){ %>
							<li class="list-group-item"><a <%if(l.getBoardType().equals("free")){ %> href="<%=request.getContextPath() %>/boards/free/freeboardview.jsp?bidx=<%=l.getBidx()%>"
							<%}else if(l.getBoardType().equals("introduce")){ %> href="<%=request.getContextPath() %>/boards/intro/introduceboardview.jsp?bidx=<%=l.getBidx()%>"
							<%}else if(l.getBoardType().equals("trainer")){ %> href="<%=request.getContextPath() %>/boards/trainer/trainerboardview.jsp?bidx=<%=l.getBidx()%>"
							<%}else if(l.getBoardType().equals("qanda")){ %> href="<%=request.getContextPath() %>/boards/qanda/qandaboardview.jsp?bidx=<%=l.getBidx()%>"<%} %>>
							<%out.print(bestCount++ +".");%><%=l.getSubject() %></a></li>
						<%} %>
						<%if(login != null){%>
						<li class="list-group-item list-group-item-secondary"><a href="<%=request.getContextPath() %>/mypage/mypage.jsp?nowPage=1&nowPage2=1">내가쓴 글 및 댓글 조회</a></li>
						<li class="list-group-item list-group-item-secondary"><a href="<%=request.getContextPath() %>/manager/showmember.jsp">회원정보 보기</a></li>
						<li class="list-group-item list-group-item-secondary"><a href="<%=request.getContextPath() %>/mypage/mypage.jsp?nowPage=1&nowPage2=1">내 정보 조회</a></li>
						<%} %>
					</ul>
				</div>
			</div>
		</section>
		<%@include file = "footer.jsp" %>
	</div>
	<script src="<%=request.getContextPath() %>/js/jquery-3.6.0.min.js"></script>
	<script src="<%=request.getContextPath() %>/js/bootstrap.min.js"></script>
</body>
</html>