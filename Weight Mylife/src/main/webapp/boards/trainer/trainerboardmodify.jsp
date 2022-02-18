<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %> 
<%@ page import="boardWeb.util.*" %>
<%@ page import="live.*" %>
<%@ page import="java.util.*" %>
<%	
	request.setCharacterEncoding("UTF-8");
	String searchType = request.getParameter("searchType");
	String searchValue = request.getParameter("searchValue");
	
	String bidx = request.getParameter("bidx");
	
	Connection conn = null;
	PreparedStatement psmt = null;
	ResultSet rs = null;
	
	int bestCount = 1;
	ArrayList<LiveDTO> lList = new ArrayList<>();
	
	String subject = "";
	String writer = "";
	String content = "";
	String filerealname = "";
	
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
		
		sql = "select * from board where bidx="+bidx;
		
		psmt = conn.prepareStatement(sql);
		rs = psmt.executeQuery();
		
		if(rs.next()){
			subject = rs.getString("subject");
			writer = rs.getString("writer");
			content = rs.getString("content");
			filerealname = rs.getString("filerealname");
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
<link rel="stylesheet" href="<%=request.getContextPath() %>/static/boardmodify.css" />
<style>
header li:nth-child(3) a:nth-child(1) {
	color: orange;
}
</style>
</head>
<body>
	<div id="wrap">
		<%@include file = "../../header.jsp" %> 
		<section>
			<hr style="border: solid black 1px">
			
			<form class="modify" name="modify" action="trainerboardmodifyOk.jsp" method="post">
				<div class="input-group mb-3">
					<span class="input-group-text" id="basic-addon1">작성자</span> 
					<input type="text" name="fwriter" class="form-control" aria-label="Username" aria-describedby="basic-addon1" value="<%=writer%>" readonly>
				</div>
				<div class="input-group mb-3">
					<span class="input-group-text" id="basic-addon1">제목</span>
					<input type="text" name="fsubject" class="form-control" aria-label="Username" aria-describedby="basic-addon1" value="<%=subject%>">
				</div>
				<%if(filerealname != null){ %>
				<div class="input-group">
					<img src="<%=request.getContextPath() %>/upload/<%=filerealname %>" alt="업로드 이미지" />
				</div>
				<%} %>
				<div class="input-group">
					<span class="input-group-text">내용</span>
					<textarea name="fcontent" class="form-control" aria-label="With textarea"><%=content%></textarea>
				</div>
				<input type="hidden" name="fbidx" value="<%=bidx %>" />
				<div class="btnArea">
					<button type="button" class="btn btn-info" onclick="location.href='trainerboardview.jsp?bidx=<%=bidx%>&searchType=<%=searchType%>&searchValue=<%=searchValue%>'">취소</button>
					<button type="button" class="btn btn-info" onclick="saveFn()">저장</button>				
				</div>
			</form>

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
		<%@include file = "../../footer.jsp" %>
	</div>
	<script src="<%=request.getContextPath() %>/js/jquery-3.6.0.min.js"></script>
	<script src="<%=request.getContextPath() %>/js/bootstrap.min.js"></script>
	<script>
		function saveFn(){
			var YN = confirm("정말 저장하시겠습니까?");
			if(YN){
				document.modify.submit();
			}
		}
	</script>
</body>
</html>