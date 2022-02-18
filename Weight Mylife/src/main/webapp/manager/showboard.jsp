<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %> 
<%@ page import="boardWeb.vo.*" %>
<%@ page import="boardWeb.util.*" %>
<%@ page import="live.*" %>  
<%@ page import="java.util.*" %>  
<%
	Member login = (Member)session.getAttribute("loginUser");

	request.setCharacterEncoding("UTF-8");
	
	String searchType = request.getParameter("searchType");
	String searchValue = request.getParameter("searchValue");
	
	String nowPage = request.getParameter("nowPage");
	int nowPageI = 1;
	if(nowPage != null){
		nowPageI = Integer.parseInt(nowPage);
	}
	
	Connection conn = null;
	PreparedStatement psmt = null;
	ResultSet rs = null;
	
	int bestCount = 1;
	ArrayList<LiveDTO> lList = new ArrayList<>();
	
	PagingUtil paging = null;
	
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
		
		sql = "";
		sql = "select count(*) as total from board ";
		if(searchValue != null && !searchValue.equals("") && !searchValue.equals("null")){
			if(searchType.equals("fsubcon")){
				sql += " where subject like '%"+searchValue+"%' or content like '%"+searchValue+"%'";
			}else if(searchType.equals("fwriter")){
				sql += " where writer like '%"+searchValue+"%'";
			}
		}
		
		psmt = conn.prepareStatement(sql);
		rs = psmt.executeQuery();
		
		int total = 0;
		
		if(rs.next()){
			total = rs.getInt("total");
		}
		
		paging = new PagingUtil(total,nowPageI,10);
		
		sql = " select * from ";
		sql += " (select rownum r,b.* from ";
		sql += " (select * from board ";
		
		if(searchValue != null && !searchValue.equals("") && !searchValue.equals("null")){
			if(searchType.equals("fsubcon")){
				sql += " where subject like '%"+searchValue+"%' or content like '%"+searchValue+"%'";
			}else if(searchType.equals("fwriter")){
				sql += " where writer like '%"+searchValue+"%'";
			}
		}
		
		sql += "order by bidx desc) b)";
		sql += " where r >= "+paging.getStart()+" and r <= "+paging.getEnd();
		
		psmt = conn.prepareStatement(sql);
		rs = psmt.executeQuery();
%> 
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Weight My Life</title>
<link rel="stylesheet" href="<%=request.getContextPath() %>/static/bootstrap.min.css" />
<link rel="stylesheet" href="<%=request.getContextPath() %>/static/boardlist.css" />
<script src="<%=request.getContextPath() %>/js/jquery-3.6.0.min.js"></script>
<script src="<%=request.getContextPath() %>/js/bootstrap.min.js"></script>
<script>
	$(document).ready(function(){      
		$("#manager").css("color","orange");
	});
	
	function modifyFn(obj){
		var YN = confirm("수정 페이지로 이동하시겠습니까?");
		if(YN){
			var bidx = $(obj).parent().prev().find("input:hidden").val();
			var boardType = $(obj).parent().prev().prev().find("input:hidden").val();
			if(boardType == "free"){
				location.href = "<%=request.getContextPath() %>/boards/free/freeboardmodify.jsp?bidx="+bidx+"&searchType=<%=searchType%>&searchValue=<%=searchValue%>";
			}else if(boardType == "introduce"){
				location.href = "<%=request.getContextPath() %>/boards/intro/introduceboardmodify.jsp?bidx="+bidx+"&searchType=<%=searchType%>&searchValue=<%=searchValue%>";
			}else if(boardType == "qanda"){
				location.href = "<%=request.getContextPath() %>/boards/qanda/qandaboardmodify.jsp?bidx="+bidx+"&searchType=<%=searchType%>&searchValue=<%=searchValue%>";
			}else if(boardType == "trainer"){
				location.href = "<%=request.getContextPath() %>/boards/trainer/trainerboardmodify.jsp?bidx="+bidx+"&searchType=<%=searchType%>&searchValue=<%=searchValue%>";
			}
		}
	}
	
	function deleteFn(obj){
		var YN = confirm("정말 삭제시키겠습니까?");
		if(YN){
			var bidx = $(obj).parent().prev().find("input:hidden").val();
			$.ajax({
				url: "deleteBoard.jsp",
				type: "post",
				data: "bidx="+bidx,
				success: function(){
					$(obj).parent().parent().remove();
				}
			});
		}
	}
</script>
</head>
<body>
	<div id="wrap">
		<%@include file = "../../header.jsp" %> 
		<section>
			<hr style="border: solid black 1px">
			
			<table class="table">
				<thead>
					<tr class="table-secondary">
						<th scope="col">번호</th>
						<th scope="col">제목</th>
						<th scope="col">작성자</th>
						<th scope="col">추천</th>
						<th scope="col">작성날짜</th>
						<%if(login.getRanking().equals("관리자")){ %>
						<th></th>
						<%} %>
					</tr>
				</thead>
				<tbody>
					<%
						while(rs.next()){
					%>
					<tr class="table-secondary">
						<th scope="row"><%=rs.getInt("bidx") %></th>
						<td><%=rs.getString("subject") %></td>
						<td><%=rs.getString("writer") %></td>
						<td><%=rs.getInt("likey") %><input type="hidden" name="boardType" value="<%=rs.getString("boardType")%>"></td>
						<td><%=rs.getString("bdate") %><input type="hidden" name="bidx" value="<%=rs.getInt("bidx")%>"></td>
						<%if(login.getRanking().equals("관리자")){ %>
						<td><button type="button" class="btn btn-info" onclick="modifyFn(this)">수정</button>&nbsp;<button type="button" class="btn btn-info" onclick="deleteFn(this)">삭제</button></td>
						<%} %>
					</tr>
					<%} %>
				</tbody>
			</table>
			
			<div class="searchArea">
				<form action="showboard.jsp">
					<select name="searchType" class="form-select" aria-label="Default select example">
						<option selected>선택하세요</option>
						<option value="fsubcon" <%if(searchType != null && searchType.equals("fsubcon")){out.print("selected");} %>>제목+내용</option>
						<option value="fwriter" <%if(searchType != null && searchType.equals("fwriter")){out.print("selected");} %>>작성자</option>
					</select>
					<input name="searchValue" type="text" class="form-control" aria-label="Sizing example input" aria-describedby="inputGroup-sizing-default" <%if(searchValue != null && !searchValue.equals("") && !searchValue.equals("null")){out.print("value='"+searchValue+"'");} %>>
					<input type="submit" value="검색" />
				</form>
			</div>
			
			<div class="pagingArea">
				<nav aria-label="Page navigation example">
					<ul class="pagination">
						<li class="page-item"><a class="page-link" <%if(paging.getStartPage() > 1){ %> href="showboard.jsp?nowPage=<%=paging.getStartPage()-1 %>&searchType=<%=searchType %>&searchValue=<%=searchValue %>" <%} %>
							aria-label="Previous"> <span aria-hidden="true">&laquo;</span>
						</a></li>
						
						<%for(int i = paging.getStartPage(); i <= paging.getEndPage(); i++) {%>
							<%if(i == paging.getNowPage()) {%>
								<li class="page-item active" aria-current="page"><a class="page-link" href="#"><%=i %></a></li>
							<%}else { %>
								<li class="page-item"><a class="page-link" href="showboard.jsp?nowPage=<%=i%>&searchType=<%=searchType %>&searchValue=<%=searchValue %>"><%=i %></a></li>
							<%} %>
						<%} %>
						
						<li class="page-item"><a class="page-link" <%if(paging.getEndPage() != paging.getLastPage()) {%> href="showboard.jsp?nowPage=<%=paging.getEndPage()+1 %>&searchType=<%=searchType %>&searchValue=<%=searchValue %>" <%} %>
							aria-label="Next"> <span aria-hidden="true">&raquo;</span>
						</a></li>
					</ul>
				</nav>
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
						<li class="list-group-item active"><span>실시간 게시글 TOP5</span></li>
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
</body>
</html>
<%
	}catch(Exception e){
		e.printStackTrace();
	}finally{
		DBManager.close(psmt, conn, rs);
	}
%>