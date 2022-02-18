<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %> 
<%@ page import="boardWeb.vo.*" %>
<%@ page import="boardWeb.util.*" %>
<%@ page import="java.util.*" %>
<%@ page import="live.*" %>    
<%
	Member login = (Member)session.getAttribute("loginUser");

	request.setCharacterEncoding("UTF-8");
	
	Connection conn = null;
	PreparedStatement psmt = null;
	ResultSet rs = null;
	
	int bestCount = 1;
	ArrayList<LiveDTO> lList = new ArrayList<>();
	
	try{
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
<link rel="stylesheet" href="<%=request.getContextPath() %>/static/manager.css" />
<script src="<%=request.getContextPath() %>/js/jquery-3.6.0.min.js"></script>
<script src="<%=request.getContextPath() %>/js/bootstrap.min.js"></script>
<script>
	$(document).ready(function(){      
		$("#manager").css("color","orange");
	});
</script>
</head>
<body>
	<div id="wrap">
		<%@include file = "../header.jsp" %> 
		<section>
			<hr style="border: solid black 1px">
			
			<div class="cards">
				<div class="card" id="cards">
					<div class="card-body">
						<div class="card card-body">
							<h5 class="card-title">회원정보 관리</h5>
								<figure class="figure">
								  <img src="<%=request.getContextPath() %>/static/member.jpg" class="figure-img img-fluid rounded" alt="회원정보">
								  <figcaption class="figure-caption"><a href="<%=request.getContextPath() %>/manager/showmember.jsp">회원정보 바로가기</a></figcaption>
								</figure>
						</div>
						<div class="card card-body">
							<h5 class="card-title">게시판 정보 관리</h5>
								<figure class="figure">
								  <img src="<%=request.getContextPath() %>/static/board.png" class="figure-img img-fluid rounded" alt="게시판정보">
								  <figcaption class="figure-caption"><a href="<%=request.getContextPath() %>/manager/showboard.jsp">게시판정보 바로가기</a></figcaption>
								</figure>
						</div>
					</div>
				</div>
			</div>
			
			<div class="main-left">
				
				<img src="<%=request.getContextPath() %>/static/banner.jpg" alt="배너이미지" class="banner-img" />
				
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
			</div>
			
			<div class="main-scroll">
				<div class="card border-secondary mb-3" style="width: 15rem;">
					<ul class="list-group list-group-flush">
						<li class="list-group-item active"><span>게시글 TOP5</span></li>
						<%for(LiveDTO l : lList){ %>
							<li class="list-group-item"><a <%if(l.getBoardType().equals("free")){ %> href="<%=request.getContextPath() %>/boards/free/freeboardview.jsp?bidx=<%=l.getBidx()%>"
							<%}else if(l.getBoardType().equals("introduce")){ %> href="<%=request.getContextPath() %>/boards/intro/introduceboardview.jsp?bidx=<%=l.getBidx()%>"
							<%}else if(l.getBoardType().equals("trainer")){ %> href="<%=request.getContextPath() %>/boards/trainer/trainerboardview.jsp?bidx=<%=l.getBidx()%>"
							<%}else if(l.getBoardType().equals("qanda")){ %> href="<%=request.getContextPath() %>/boards/qanda/qandaboardview.jsp?bidx=<%=l.getBidx()%>"<%} %>>
							<%out.print(bestCount++ +".");%><%=l.getSubject() %></a></li>
						<%} %>
						<li class="list-group-item list-group-item-secondary"><a href="<%=request.getContextPath() %>/mypage/mypage.jsp?nowPage=1&nowPage2=1">내가쓴 글 및 댓글 조회</a></li>
						<li class="list-group-item list-group-item-secondary"><a href="<%=request.getContextPath() %>/manager/showmember.jsp">회원정보 보기</a></li>
						<li class="list-group-item list-group-item-secondary"><a href="<%=request.getContextPath() %>/mypage/mypage.jsp?nowPage=1&nowPage2=1">내 정보 조회</a></li>
					</ul>
				</div>
			</div>
		</section>
		<%@include file = "../footer.jsp" %>
	</div>
</body>
</html>