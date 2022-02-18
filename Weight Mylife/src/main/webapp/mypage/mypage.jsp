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
	
	String nowPage = request.getParameter("nowPage");
	int nowPageI = 1;
	if(nowPage != null){
		nowPageI = Integer.parseInt(nowPage);
	}
	
	String nowPage2 = request.getParameter("nowPage2");
	int nowPageI2 = 1;
	if(nowPage2 != null){
		nowPageI2 = Integer.parseInt(nowPage2);
	}
	
	Connection conn = null;
	PreparedStatement psmt = null;
	ResultSet rs = null;
	Connection conn2 = null;
	PreparedStatement psmt2 = null;
	ResultSet rs2 = null;
	ResultSet rs3 = null;
	
	String memberid="";
	String membername="";
	String email1="";
	String email2="";
	int phone1=0;
	int phone2=0;
	int phone3=0;
	String addr="";
	String memberpwd="";
	int midx = 0;
	
	int bestCount = 1;
	ArrayList<LiveDTO> lList = new ArrayList<>();
	
	PagingUtil paging = null;
	PagingUtil paging2 = null;
	
	try{
		conn = DBManager.getConnection();
		
		String sql = "select * from member where midx="+login.getMidx();
		psmt = conn.prepareStatement(sql);
		rs3 = psmt.executeQuery();
		if(rs3.next()){
			memberid = rs3.getString("memberid");
			membername = rs3.getString("membername");
			email1 = rs3.getString("email1");
			email2 = rs3.getString("email2");
			phone1 = rs3.getInt("phone1");
			phone2 = rs3.getInt("phone2");
			phone3 = rs3.getInt("phone3");
			addr = rs3.getString("addr");
			memberpwd = rs3.getString("memberpwd");
			midx = rs3.getInt("midx");
		}
		
		sql = "SELECT * FROM (SELECT ROWNUM r,b.* FROM (SELECT * FROM board ORDER BY likey desc) b) WHERE r>=1 AND r<=5";
		psmt = conn.prepareStatement(sql);
		rs = psmt.executeQuery();
		while(rs.next()){
			LiveDTO live = new LiveDTO();
			live.setBidx(rs.getInt("bidx"));
			live.setSubject(rs.getString("subject"));
			live.setBoardType(rs.getString("boardType"));
			lList.add(live);
		}
		
		sql = "select count(*) as total from board where midx="+login.getMidx()+" order by bidx desc";
		
		psmt = conn.prepareStatement(sql);
		rs = psmt.executeQuery();
		
		int total = 0;
		
		if(rs.next()){
			total = rs.getInt("total");
		}
		
		paging = new PagingUtil(total,nowPageI,10);
		
		sql = " select * from ";
		sql += " (select rownum r,b.* from ";
		sql += " (select * from board where midx="+login.getMidx()+" order by bidx desc) b)";
		sql += " where r >= "+paging.getStart()+" and r <= "+paging.getEnd();
		
		psmt = conn.prepareStatement(sql);
		rs = psmt.executeQuery();
		
		conn2 = DBManager.getConnection();
		sql = "select count(*) as total from reply where midx="+login.getMidx()+" order by ridx desc";
		
		psmt2 = conn2.prepareStatement(sql);
		rs2 = psmt2.executeQuery();
		
		int total2 = 0;		
		
		if(rs2.next()){
			total2 = rs2.getInt("total");
		}
		
		paging2 = new PagingUtil(total2,nowPageI2,10);
		
		sql = " select * from ";
		sql += " (select rownum r,b.* from ";
		sql += " (select * from reply where midx="+login.getMidx()+" order by ridx desc) b)";
		sql += " where r >= "+paging2.getStart()+" and r <= "+paging2.getEnd();
		
		psmt2 = conn.prepareStatement(sql);
		rs2 = psmt2.executeQuery();
%> 
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Weight My Life</title>
<link rel="stylesheet" href="<%=request.getContextPath() %>/static/bootstrap.min.css" />
<link rel="stylesheet" href="<%=request.getContextPath() %>/static/mypage.css" />
<script src="<%=request.getContextPath() %>/js/jquery-3.6.0.min.js"></script>
<script src="<%=request.getContextPath() %>/js/bootstrap.min.js"></script>
<script>
	$(document).ready(function(){      
		$("#mypage").css("color","orange");
	});
	
	function modifyId(obj){
		var modifyId = $(obj).parent().prev().find("input[name=modifyId]").val();
		var midx = '<%=midx%>';
		var html = "<input type='text' name='modifyId' value='"+modifyId+"'><input type='hidden' name='midx' value='"+midx+"' />";
		$(obj).parent().prev().html(html);
		
		html = "<button type='button' class='btn btn-info' onclick='updateId(this)'>저장</button>&nbsp;<button type='button' class='btn btn-info' onclick='cancleId(this)'>취소</button>"
		$(obj).parent().html(html);
	}
	function updateId(obj){
		var modifyId = $(obj).parent().prev().find("input[name=modifyId]").val();
		var midx = '<%=midx%>';
		$.ajax({
			url: "modifyId.jsp",
			type: "post",
			data: {"modifyId" : modifyId, "midx" : midx},
			success: function(data){
				var html = "<input type='text' name='modifyId' value='"+modifyId+"' readonly><input type='hidden' name='midx' value='"+midx+"' />";
				$(obj).parent().prev().html(html);
				html = "<button id='modifyId' type='button' class='btn btn-info' onclick='modifyId(this)'>수정</button>";
				$(obj).parent().html(html);
			}
		});
	}
	function cancleId(obj){
		var modifyId = '<%=memberid%>';
		var midx = '<%=midx%>';
		var html = "<input type='text' name='modifyId' value='"+modifyId+"' readonly><input type='hidden' name='midx' value='"+midx+"' />";
		$(obj).parent().prev().html(html);
		html = "<button id='modifyId' type='button' class='btn btn-info' onclick='modifyId(this)'>수정</button>";
		$(obj).parent().html(html);
	}
	
	function modifyName(obj){
		var modifyName = $(obj).parent().prev().find("input[name=modifyName]").val();
		var midx = '<%=midx%>';
		var html = "<input type='text' name='modifyName' value='"+modifyName+"'><input type='hidden' name='midx' value='"+midx+"' />";
		$(obj).parent().prev().html(html);
		
		html = "<button type='button' class='btn btn-info' onclick='updateName(this)'>저장</button>&nbsp;<button type='button' class='btn btn-info' onclick='cancleName(this)'>취소</button>"
		$(obj).parent().html(html);
	}
	function updateName(obj){
		var modifyName = $(obj).parent().prev().find("input[name=modifyName]").val();
		var midx = '<%=midx%>';
		$.ajax({
			url: "modifyName.jsp",
			type: "post",
			data: {"modifyName" : modifyName, "midx" : midx},
			success: function(data){
				var html = "<input type='text' name='modifyName' value='"+modifyName+"' readonly><input type='hidden' name='midx' value='"+midx+"' />";
				$(obj).parent().prev().html(html);
				html = "<button id='modifyName' type='button' class='btn btn-info' onclick='modifyName(this)'>수정</button>";
				$(obj).parent().html(html);
			}
		});
	}
	function cancleName(obj){
		var modifyName = '<%=membername%>';
		var midx = '<%=midx%>';
		var html = "<input type='text' name='modifyName' value='"+modifyName+"' readonly><input type='hidden' name='midx' value='"+midx+"' />";
		$(obj).parent().prev().html(html);
		html = "<button id='modifyName' type='button' class='btn btn-info' onclick='modifyName(this)'>수정</button>";
		$(obj).parent().html(html);
	}
	
	function modifyEmail(obj){
		var modifyEmail1 = $(obj).parent().prev().find("input[name=modifyEmail1]").val();
		var modifyEmail2 = $(obj).parent().prev().find("input[name=modifyEmail2]").val();
		var midx = '<%=midx%>';
		var html = "<input type='text' name='modifyEmail1' value='"+modifyEmail1+"' /> @ <input type='text' name='modifyEmail2' value='"+modifyEmail2+"' /><input type='hidden' name='midx' value='"+midx+"' />";
		$(obj).parent().prev().html(html);
		
		html = "<button type='button' class='btn btn-info' onclick='updateEmail(this)'>저장</button>&nbsp;<button type='button' class='btn btn-info' onclick='cancleEmail(this)'>취소</button>"
		$(obj).parent().html(html);
	}
	function updateEmail(obj){
		var modifyEmail1 = $(obj).parent().prev().find("input[name=modifyEmail1]").val();
		var modifyEmail2 = $(obj).parent().prev().find("input[name=modifyEmail2]").val();
		var midx = '<%=midx%>';
		$.ajax({
			url: "modifyEmail.jsp",
			type: "post",
			data: {"modifyEmail1" : modifyEmail1, "midx" : midx, "modifyEmail2" : modifyEmail2},
			success: function(data){
				var html = "<input type='text' name='modifyEmail1' value='"+modifyEmail1+"' readonly /> @ <input type='text' name='modifyEmail2' value='"+modifyEmail2+"' readonly /><input type='hidden' name='midx' value='"+midx+"' />";
				$(obj).parent().prev().html(html);
				html = "<button id='modifyEmail' type='button' class='btn btn-info' onclick='modifyEmail(this)'>수정</button>";
				$(obj).parent().html(html);
			}
		});
	}
	function cancleEmail(obj){
		var modifyEmail1 = '<%=email1%>';
		var modifyEmail2 = '<%=email2%>';
		var midx = '<%=midx%>';
		var html = "<input type='text' name='modifyEmail1' value='"+modifyEmail1+"' readonly /> @ <input type='text' name='modifyEmail2' value='"+modifyEmail2+"' readonly /><input type='hidden' name='midx' value='"+midx+"' />";
		$(obj).parent().prev().html(html);
		html = "<button id='modifyEmail' type='button' class='btn btn-info' onclick='modifyEmail(this)'>수정</button>";
		$(obj).parent().html(html);
	}
	
	function modifyPhone(obj){
		var modifyPhone1 = $(obj).parent().prev().find("input[name=modifyPhone1]").val();
		var modifyPhone2 = $(obj).parent().prev().find("input[name=modifyPhone2]").val();
		var modifyPhone3 = $(obj).parent().prev().find("input[name=modifyPhone3]").val();
		var midx = '<%=midx%>';
		var html = "<input type='number' name='modifyPhone1' value='"+modifyPhone1+"' /> - <input type='number' name='modifyPhone2' value='"+modifyPhone2+"' /> - <input type='number' name='modifyPhone3' value='"+modifyPhone3+"' /><input type='hidden' name='midx' value='"+midx+"' />";
		$(obj).parent().prev().html(html);
		
		html = "<button type='button' class='btn btn-info' onclick='updatePhone(this)'>저장</button>&nbsp;<button type='button' class='btn btn-info' onclick='canclePhone(this)'>취소</button>"
		$(obj).parent().html(html);
	}
	function updatePhone(obj){
		var modifyPhone1 = $(obj).parent().prev().find("input[name=modifyPhone1]").val();
		var modifyPhone2 = $(obj).parent().prev().find("input[name=modifyPhone2]").val();
		var modifyPhone3 = $(obj).parent().prev().find("input[name=modifyPhone3]").val();
		var midx = '<%=midx%>';
		$.ajax({
			url: "modifyPhone.jsp",
			type: "post",
			data: {"modifyPhone1" : modifyPhone1, "midx" : midx, "modifyPhone2" : modifyPhone2, "modifyPhone3" : modifyPhone3},
			success: function(data){
				var html = "<input type='number' name='modifyPhone1' value='"+modifyPhone1+"' readonly /> - <input type='number' name='modifyPhone2' value='"+modifyPhone2+"' readonly /> - <input type='number' name='modifyPhone3' value='"+modifyPhone3+"' readonly /><input type='hidden' name='midx' value='"+midx+"' />";
				$(obj).parent().prev().html(html);
				html = "<button id='modifyPhone' type='button' class='btn btn-info' onclick='modifyPhone(this)'>수정</button>";
				$(obj).parent().html(html);
			}
		});
	}
	function canclePhone(obj){
		var modifyPhone1 = '<%=phone1%>';
		var modifyPhone2 = '<%=phone2%>';
		var modifyPhone3 = '<%=phone3%>';
		var midx = '<%=midx%>';
		var html = "<input type='number' name='modifyPhone1' value='"+modifyPhone1+"' readonly /> - <input type='number' name='modifyPhone2' value='"+modifyPhone2+"' readonly /> - <input type='number' name='modifyPhone3' value='"+modifyPhone3+"' readonly /><input type='hidden' name='midx' value='"+midx+"' />";
		$(obj).parent().prev().html(html);
		html = "<button id='modifyPhone' type='button' class='btn btn-info' onclick='modifyPhone(this)'>수정</button>";
		$(obj).parent().html(html);
	}
	
	function modifyAddr(obj){
		var modifyAddr = $(obj).parent().prev().find("input[name=modifyAddr]").val();
		var midx = '<%=midx%>';
		var html = "<input type='text' name='modifyAddr' value='"+modifyAddr+"'><input type='hidden' name='midx' value='"+midx+"' />";
		$(obj).parent().prev().html(html);
		
		html = "<button type='button' class='btn btn-info' onclick='updateAddr(this)'>저장</button>&nbsp;<button type='button' class='btn btn-info' onclick='cancleAddr(this)'>취소</button>"
		$(obj).parent().html(html);
	}
	function updateAddr(obj){
		var modifyAddr = $(obj).parent().prev().find("input[name=modifyAddr]").val();
		var midx = '<%=midx%>';
		$.ajax({
			url: "modifyAddr.jsp",
			type: "post",
			data: {"modifyAddr" : modifyAddr, "midx" : midx},
			success: function(data){
				var html = "<input type='text' name='modifyAddr' value='"+modifyAddr+"' readonly><input type='hidden' name='midx' value='"+midx+"' />";
				$(obj).parent().prev().html(html);
				html = "<button id='modifyAddr' type='button' class='btn btn-info' onclick='modifyAddr(this)'>수정</button>";
				$(obj).parent().html(html);
			}
		});
	}
	function cancleAddr(obj){
		var modifyAddr = '<%=addr%>';
		var midx = '<%=midx%>';
		var html = "<input type='text' name='modifyAddr' value='"+modifyAddr+"' readonly><input type='hidden' name='midx' value='"+midx+"' />";
		$(obj).parent().prev().html(html);
		html = "<button id='modifyAddr' type='button' class='btn btn-info' onclick='modifyAddr(this)'>수정</button>";
		$(obj).parent().html(html);
	}
	
	function modifyPwd(obj){
		var modifyPwd = $(obj).parent().prev().find("input[name=modifyPwd]").val();
		var midx = '<%=midx%>';
		var html = "<input type='password' name='modifyPwd' value='"+modifyPwd+"'><input type='hidden' name='midx' value='"+midx+"' />";
		$(obj).parent().prev().html(html);
		
		html = "<button type='button' class='btn btn-info' onclick='updatePwd(this)'>저장</button>&nbsp;<button type='button' class='btn btn-info' onclick='canclePwd(this)'>취소</button>"
		$(obj).parent().html(html);
	}
	function updatePwd(obj){
		var modifyPwd = $(obj).parent().prev().find("input[name=modifyPwd]").val();
		var midx = '<%=midx%>';
		$.ajax({
			url: "modifyPwd.jsp",
			type: "post",
			data: {"modifyPwd" : modifyPwd, "midx" : midx},
			success: function(data){
				var html = "<input type='password' name='modifyPwd' value='"+modifyPwd+"' readonly><input type='hidden' name='midx' value='"+midx+"' />";
				$(obj).parent().prev().html(html);
				html = "<button id='modifyPwd' type='button' class='btn btn-info' onclick='modifyPwd(this)'>수정</button>";
				$(obj).parent().html(html);
			}
		});
	}
	function canclePwd(obj){
		var modifyPwd = '<%=memberpwd%>';
		var midx = '<%=midx%>';
		var html = "<input type='password' name='modifyPwd' value='"+modifyPwd+"' readonly><input type='hidden' name='midx' value='"+midx+"' />";
		$(obj).parent().prev().html(html);
		html = "<button id='modifyPwd' type='button' class='btn btn-info' onclick='modifyPwd(this)'>수정</button>";
		$(obj).parent().html(html);
	}
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
					<h5 class="card-title">내 정보 조회</h5>
					<table border='1' id="memberTable">
						<tr>
							<td>아이디 : </td>
							<td><input type="text" name="modifyId" value="<%=memberid%>" readonly /><input type="hidden" name="midx" value="<%=midx%>" /></td>
							<td><button id="modifyId" type="button" class="btn btn-info" onclick="modifyId(this)">수정</button></td>
						</tr>
						<tr>
							<td>이름 : </td>
							<td><input type="text" name="modifyName" value="<%=membername %>" readonly /><input type="hidden" name="midx" value="<%=midx%>" /></td>
							<td><button id="modifyName" type="button" class="btn btn-info" onclick="modifyName(this)">수정</button></td>
						</tr>
						<tr>
							<td>이메일 : </td>
							<td><input type="text" name="modifyEmail1" value="<%=email1 %>" readonly /> @ <input type="text" name="modifyEmail2" value="<%=email2 %>" readonly /><input type="hidden" name="midx" value="<%=midx%>" /></td>
							<td><button id="modifyEmail" type="button" class="btn btn-info" onclick="modifyEmail(this)">수정</button></td>
						</tr>
						<tr>
							<td>핸드폰 : 0</td>
							<td><input type="number" name="modifyPhone1" value="<%=phone1 %>" readonly /> - <input type="number" name="modifyPhone2" value="<%=phone2 %>" readonly /> - <input type="number" name="modifyPhone3" value="<%=phone3 %>" readonly /><input type="hidden" name="midx" value="<%=midx%>" /></td>
							<td><button id="modifyPhone" type="button" class="btn btn-info" onclick="modifyPhone(this)">수정</button></td>
						</tr>
						<tr>
							<td>주소 : </td>
							<td><input type="text" name="modifyAddr" value="<%=addr %>" readonly /><input type="hidden" name="midx" value="<%=midx%>" /></td>
							<td><button id="modifyAddr" type="button" class="btn btn-info" onclick="modifyAddr(this)">수정</button></td>
						</tr>
						<tr>
							<td>비밀번호 : </td>
							<td><input type="password" name="modifyPwd" value="<%=memberpwd%>" readonly /><input type="hidden" name="midx" value="<%=midx%>" /></td>
							<td><button id="modifyPwd" type="button" class="btn btn-info" onclick="modifyPwd(this)">수정</button></td>
						</tr>
						<tr>
							<td>나이 : </td>
							<td><%=login.getAge() %></td>
						</tr>
						<tr>
							<td>등급 : </td>
							<td><%=login.getRanking() %></td>
						</tr>
						<tr>
							<td>가입일 : </td>
							<td><%=login.getMdate() %></td>
						</tr>
					</table>
				</div>
			</div>
			<div class="card" id="cards">
				<div class="card-body">
					<p>
						<a class="btn btn-primary" data-bs-toggle="collapse"
							href="#multiCollapseExample1" role="button" 
							aria-expanded="true" aria-controls="multiCollapseExample1">내가쓴 글</a>
						<button class="btn btn-primary" type="button"
							data-bs-toggle="collapse"
							data-bs-target="#multiCollapseExample2" aria-expanded="true"
							aria-controls="multiCollapseExample2">내가쓴 댓글</button>
						<button class="btn btn-primary" type="button"
							data-bs-toggle="collapse" data-bs-target=".multi-collapse"
							aria-expanded="false"
							aria-controls="multiCollapseExample1 multiCollapseExample2">둘다 보기</button>
					</p>
					
					<div class="row">
						<div class="col">
							<div class="collapse show multi-collapse" id="multiCollapseExample1">
								<div class="card card-body">
									<table class="table">
										<thead>
											<tr class="table-secondary">
												<th scope="col">글번호</th>
												<th scope="col">제목</th>
												<th scope="col">작성자</th>
												<th scope="col">추천수</th>
												<th scope="col">조회수</th>
											</tr>
										</thead>
										<tbody>
											<%
												while(rs.next()){
											%>
											<tr class="table-secondary">
												<th scope="row"><%=rs.getInt("bidx") %></th>
												<td><a <%if(rs.getString("boardType").equals("free")){ %> href="<%=request.getContextPath() %>/boards/free/freeboardview.jsp?bidx=<%=rs.getInt("bidx")%>"
												<%}else if(rs.getString("boardType").equals("introduce")){ %> href="<%=request.getContextPath() %>/boards/intro/introduceboardview.jsp?bidx=<%=rs.getInt("bidx")%>"
												<%}else if(rs.getString("boardType").equals("qanda")){ %> href="<%=request.getContextPath() %>/boards/qanda/qandaboardview.jsp?bidx=<%=rs.getInt("bidx")%>"
												<%}else if(rs.getString("boardType").equals("trainer")){ %> href="<%=request.getContextPath() %>/boards/trainer/trainerboardview.jsp?bidx=<%=rs.getInt("bidx")%>"<%} %>><%=rs.getString("subject") %></a></td>
												<td><%=rs.getString("writer") %></td>
												<td><%=rs.getInt("likey") %></td>
												<td><%=rs.getInt("viewcnt") %></td>
											</tr>
											<%} %>
										</tbody>
									</table>
									
									<div class="pagingArea">
										<nav aria-label="Page navigation example">
											<ul class="pagination">
												<li class="page-item"><a class="page-link" <%if(paging.getStartPage() > 1){ %> href="mypage.jsp?nowPage=<%=paging.getStartPage()-1 %>&nowPage2=<%=nowPage2 %>" <%} %>
												aria-label="Previous"> <span aria-hidden="true">&laquo;</span>
												</a></li>
									
										<%for(int i = paging.getStartPage(); i <= paging.getEndPage(); i++) {%>
											<%if(i == paging.getNowPage()) {%>
												<li class="page-item active" aria-current="page"><a class="page-link" href="#"><%=i %></a></li>
											<%}else { %>
												<li class="page-item"><a class="page-link" href="mypage.jsp?nowPage=<%=i%>&nowPage2=<%=nowPage2 %>"><%=i %></a></li>
											<%} %>
										<%} %>
									
												<li class="page-item"><a class="page-link" <%if(paging.getEndPage() != paging.getLastPage()) {%> href="mypage.jsp?nowPage=<%=paging.getEndPage()+1 %>&nowPage2=<%=nowPage2 %>" <%} %>
												aria-label="Next"> <span aria-hidden="true">&raquo;</span>
												</a></li>
											</ul>
										</nav>
									</div>
								</div>
							</div>
						</div>
						
						<div class="col">
							<div class="collapse show multi-collapse" id="multiCollapseExample2">
								<div class="card card-body">
									<table class="table">
										<thead>
											<tr class="table-secondary">
												<th scope="col">댓글번호</th>
												<th scope="col">내용</th>
												<th scope="col">작성일자</th>
											</tr>
										</thead>
										<tbody>
											<%
												while(rs2.next()){
											%>
											<tr class="table-secondary">
												<th scope="row"><%=rs2.getInt("ridx") %></th>
												<td><a <%if(rs2.getString("replyType").equals("free")){ %> href="<%=request.getContextPath() %>/boards/free/freeboardview.jsp?bidx=<%=rs2.getInt("bidx")%>"
												<%}else if(rs2.getString("replyType").equals("introduce")){ %> href="<%=request.getContextPath() %>/boards/intro/introduceboardview.jsp?bidx=<%=rs2.getInt("bidx")%>"
												<%}else if(rs2.getString("replyType").equals("qanda")){ %> href="<%=request.getContextPath() %>/boards/qanda/qandaboardview.jsp?bidx=<%=rs2.getInt("bidx")%>" 
												<%}else if(rs2.getString("replyType").equals("trainer")){ %> href="<%=request.getContextPath() %>/boards/trainer/trainerboardview.jsp?bidx=<%=rs2.getInt("bidx")%>"<%}%>><%=rs2.getString("rcontent") %></a></td>
												<td><%=rs2.getString("rdate") %></td>												
											</tr>
											<%} %>
										</tbody>
									</table>
									
									<div class="pagingArea">
										<nav aria-label="Page navigation example">
											<ul class="pagination">
												<li class="page-item"><a class="page-link" <%if(paging2.getStartPage() > 1){ %> href="mypage.jsp?nowPage2=<%=paging2.getStartPage()-1 %>&nowPage=<%=nowPage %>" <%} %>
												aria-label="Previous"> <span aria-hidden="true">&laquo;</span>
												</a></li>
									
										<%for(int i = paging2.getStartPage(); i <= paging2.getEndPage(); i++) {%>
											<%if(i == paging2.getNowPage()) {%>
												<li class="page-item active" aria-current="page"><a class="page-link" href="#"><%=i %></a></li>
											<%}else { %>
												<li class="page-item"><a class="page-link" href="mypage.jsp?nowPage2=<%=i%>&nowPage=<%=nowPage %>"><%=i %></a></li>
											<%} %>
										<%} %>
									
												<li class="page-item"><a class="page-link" <%if(paging2.getEndPage() != paging2.getLastPage()) {%> href="mypage.jsp?nowPage2=<%=paging2.getEndPage()+1 %>&nowPage=<%=nowPage %>" <%} %>
												aria-label="Next"> <span aria-hidden="true">&raquo;</span>
												</a></li>
											</ul>
										</nav>
									</div>
								</div>
							</div>
						</div>
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
<%
	}catch(Exception e){
		e.printStackTrace();
	}finally{
		DBManager.close(psmt, conn, rs);
		if(conn2 != null){conn2.close();}
		if(psmt2 != null){psmt2.close();}
		if(rs2 != null){rs2.close();}
		if(rs3 != null){rs3.close();}
	}
%>