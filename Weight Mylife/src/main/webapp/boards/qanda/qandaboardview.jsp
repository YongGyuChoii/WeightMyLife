<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.util.*"%>
<%@ page import="boardWeb.util.*" %>
<%@ page import="boardWeb.vo.*" %>
<%@ page import="java.sql.*" %>
<%@ page import="org.json.simple.*"%>
<%@ page import="java.io.File"%>
<%@ page import="live.*" %>
<%	
	Member login = (Member)session.getAttribute("loginUser");
	
	request.setCharacterEncoding("UTF-8");
	
	int visitSwitch = 0;   // 게시글의 조회여부를 결정짓는 변수
	String cookiesql = "";   // 쿠키관련 쿼리문
	String cookieName = "";   // 쿠키이름
	
	String searchType = request.getParameter("searchType");
	String searchValue = request.getParameter("searchValue");
	String bidx = request.getParameter("bidx");
	String boardType = request.getParameter("boardType");
	
	int bestCount = 1;
	ArrayList<LiveDTO> lList = new ArrayList<>();
	
	if(login != null){  
	  	cookieName = boardType + "-" + bidx + "-" +  login.getMidx();   // 게시판타입(boardType) - 게시글번호 - 회원번호(midx)로 쿠키이름만 생성
	}
	
	String directory = application.getRealPath("/upload/");
	String files[] = new File(directory).list();
	
	Connection conn = null;
	PreparedStatement psmt = null;
	ResultSet rs = null;
	
	PreparedStatement psmtReply = null;
	ResultSet rsReply = null;
	
	String subject = "";
	String writer = "";
	String bdate = "";
	int viewcnt = 0;
	int likey = 0;
	int replyCnt = 0;
	String filerealname = "";
	String content = "";
	int midx = 0;
	
	ArrayList<Reply> rList = new ArrayList<>();
	
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
		
		Cookie[] cookies = request.getCookies();
		
		 if(login != null){
	         if(cookies != null){
	            for(Cookie cook : cookies){   // 쿠키객체안의 쿠키물 확인하는 반복문
	               if(cook.getName().equals(cookieName) && cook.getValue().equals("viewed")){   // 쿠키이름과 그에대한 값이 존재하는경우
	                  visitSwitch = 1;   // 게시글을 조회한 이력이 있다.
	                  break;   // 이건 빼도되고 안빼도 됨. 속도 높이려고 break한거.
	               }
	            }
	         }
	         if(visitSwitch == 0){   // 조회한 이력이 없을 경우
	             cookiesql = "UPDATE board SET viewcnt = viewcnt + 1 WHERE bidx = " + bidx;   // 조회수 1 올려줌
	             psmt = conn.prepareStatement(cookiesql);
	             int result = psmt.executeUpdate();
	             if(result == 1){
	                Cookie cookie = new Cookie(cookieName, "viewed");   // 쿠키 이름과 그에대한 값("viewed")을 생성
	                cookie.setMaxAge(60 * 60 * 24);   // 24시간으로 설정
	                response.addCookie(cookie);      // 생성한걸 쿠키객체에 집어 넣음
	             }
	          }
	       }

		sql = "select count(*) as total from reply where bidx="+bidx;
		psmt = conn.prepareStatement(sql);
		rs = psmt.executeQuery();
		if(rs.next()){
			replyCnt = rs.getInt("total");
		}
		
		psmt = null;
		rs = null;
		
		sql = "select * from board where bidx="+bidx;
		psmt = conn.prepareStatement(sql);
		rs = psmt.executeQuery();
		
		if(rs.next()){
			subject = rs.getString("subject");
			writer = rs.getString("writer");
			bdate = rs.getString("bdate");
			viewcnt = rs.getInt("viewcnt");
			likey = rs.getInt("likey");
			filerealname = rs.getString("filerealname");
			content = rs.getString("content");
			midx = rs.getInt("midx");
		}
		
		sql = "select * from reply r, member m where r.midx=m.midx and bidx="+bidx;
		psmtReply = conn.prepareStatement(sql);
		rsReply = psmtReply.executeQuery();
		
		while(rsReply.next()){
			Reply reply = new Reply();
			reply.setBidx(rsReply.getInt("bidx"));
			reply.setMidx(rsReply.getInt("midx"));
			reply.setRidx(rsReply.getInt("ridx"));
			reply.setRcontent(rsReply.getString("rcontent"));
			reply.setRdate(rsReply.getString("rdate"));
			reply.setMemberName(rsReply.getString("memberName"));
			
			rList.add(reply);
		}
		
	}catch(Exception e){
		e.printStackTrace();
	}finally{
		DBManager.close(psmt, conn, rs);
		if(psmtReply != null){psmtReply.close();}
		if(rsReply != null){rsReply.close();}
	}
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Weight My Life</title>
<link rel="stylesheet" href="<%=request.getContextPath() %>/static/bootstrap.min.css" />
<link rel="stylesheet" href="<%=request.getContextPath() %>/static/boardview.css" />
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.7.2/font/bootstrap-icons.css">
<script src="<%=request.getContextPath() %>/js/jquery-3.6.0.min.js"></script>
<script src="<%=request.getContextPath() %>/js/bootstrap.min.js"></script>
<script>
	function replySave(){
		var YN = confirm("정말 등록하시겠습니까?");
		if(YN){
			$.ajax({
				url: "freplySave.jsp",
				type: "post",
				data: $("form[name=freply]").serialize(),
				success: function(data){
					if('<%=login%>' == 'null'){
						alert("로그인 후 작성가능!");
						document.freply.reset();
					}else{
						alert("등록 완료!!");
						var json = JSON.parse(data.trim());
						
						var html = "<div class='replyDate'>"+json[0].rdate+"</div>";
						html += "<div class='fw-bold'>"+json[0].memberName+"<input type='hidden' name='fridx' value='"+json[0].ridx+"'></div>";
						html += "<div class='replyContent'>"+json[0].rcontent+"</div>";
						html += "<div class='replyBtn'><button id='replyModify' type='button' class='btn btn-secondary' onclick='modify(this)'>수정</button>";
						html += "&nbsp;<button id='replyDelete' type='button' class='btn btn-secondary' onclick='deleteReply(this)'>삭제</button></div><hr>";
						
						$(".ms-3").append(html);
						
						document.freply.reset();
					}
				}
			});
		}
	}
	
	function modify(obj){
		var frcontent = $(obj).parent().prev().text();
		var html = "<textarea name='frcontent' class='form-control' rows='3' value='"+frcontent+"'>"+frcontent+"</textarea><input type='hidden' name='origin' value='"+frcontent+"'>";
		$(obj).parent().prev().html(html);
		
		html = "<button id='replyModify' type='button' class='btn btn-secondary' onclick='updateReply(this)'>저장</button>";
		html += "&nbsp;<button id='replyDelete' type='button' class='btn btn-secondary' onclick='cancleReply(this)'>취소</button>";
		$(obj).parent().html(html);
	}
	
	function cancleReply(obj) {
		var originContent = $(obj).parent().prev().find("input[name=origin]").val();
		$(obj).parent().prev().html(originContent);
		
		var html = "<button id='replyModify' type='button' class='btn btn-secondary' onclick='modify(this)'>수정</button>";
		html += "&nbsp;<button id='replyDelete' type='button' class='btn btn-secondary' onclick='deleteReply(this)'>삭제</button>";
		$(obj).parent().html(html);
	}
	
	function updateReply(obj) {
		var YN = confirm("정말 수정하시겠습니까?");
		if(YN){
			var fridx = $(obj).parent().prev().prev().find("input:hidden").val();
			var frcontent = $(obj).parent().prev().find("textarea[name=frcontent]").val();
			
			$.ajax({
				url: "freplyupdate.jsp",
				type: "post",
				data: "fridx="+fridx+"&frcontent="+frcontent,
				success: function(data){
					$(obj).parent().prev().html(frcontent);
					var html = "<button id='replyModify' type='button' class='btn btn-secondary' onclick='modify(this)'>수정</button>";
					html += "&nbsp;<button id='replyDelete' type='button' class='btn btn-secondary' onclick='deleteReply(this)'>삭제</button>";
					$(obj).parent().html(html);
				}
			});
		}
	}
	
	function deleteReply(obj){
		var YN = confirm("정말 삭제하시겠습니까?");
		if(YN){
			var fridx = $(obj).parent().prev().prev().find("input:hidden").val();
			
			$.ajax({
				url: "freplyDelete.jsp",
				type: "post",
				data: "fridx="+fridx,
				success: function(){
					$(obj).parent().prev().prev().prev().remove();
					$(obj).parent().prev().prev().remove();
					$(obj).parent().prev().remove();
					$(obj).parent().remove();
				}
			});
		}
	}
</script>
<style>
header li:nth-child(4) a:nth-child(1) {
	color: orange;
}
</style>
</head>
<body>
	<div id="wrap">
		<%@include file = "../../header.jsp" %> 
		<section>
			<hr style="border: solid black 1px">
			<div class="viewJone">
				<h2><%=subject %></h2>
				<small><%=writer %></small>&nbsp;&nbsp;|&nbsp;&nbsp;<small><%=bdate %></small>&nbsp;&nbsp;<%if(login != null){ %><a href="qandaboardup.jsp?bidx=<%=bidx%>&searchType=<%=searchType%>&searchValue=<%=searchValue%>&midx=<%=login.getMidx()%>"><i class="bi bi-hand-thumbs-up-fill" style="font-size: 2rem; color: cornflowerblue;"></i></a><%} %>
				<div class="viewJoneNumber">
				<small>조회 : <%=viewcnt %> &nbsp; | &nbsp; 추천 : <%=likey %> &nbsp; | &nbsp; 댓글 : <%=replyCnt %></small>
				</div>
				<hr style="border: solid black 1px">
				<%if(filerealname != null){ %>
				<div class="viewJoneImg">
					<img src="<%=request.getContextPath() %>/upload/<%=filerealname %>" alt="업로드 이미지" />
				</div>
				<%} %>
				<div class="viewJoneCon">
					<%=content %>
				</div>
				<div class="viewJoneBtn">
				<%if(login != null && login.getMidx() == midx) {%> 
					<button type="button" class="btn btn-secondary" onclick="location.href='qandaboardmodify.jsp?bidx=<%=bidx%>&searchType=<%=searchType%>&searchValue=<%=searchValue%>'">수정</button>
					<button onclick="deleteFn()" type="button" class="btn btn-secondary">삭제</button>
				<%} %>
					<button type="button" class="btn btn-secondary" onclick="location.href='qandaboardlist.jsp?searchType=<%=searchType%>&searchValue=<%=searchValue%>'">목록</button>
				</div>
				
				<%if(filerealname != null){ %>
				<div class="viewDown">
					<div class="card">
						<div class="card-body">
						첨부된 사진 다운 :
						<%
						for(String file : files){
							if(file.equals(filerealname)){
							out.write("<a href=\"" + request.getContextPath() + "/downloadAction?file=" +
							java.net.URLEncoder.encode(filerealname, "UTF-8") + "\">" + filerealname + "</a><br>");
							}
						}
						%>
						</div>
					</div>
				</div>
				<%} %>

				<form name="frm" action="qandaboarddelete.jsp" method="post">
					<input type="hidden" name="fbidx" value="<%=bidx %>" />
				</form>
				
				<hr style="border: solid black 1px">
				
				<section class="mb-5">
                      <div class="card bg-light">
                           <div class="card-body">
                               <form class="mb-4" name="freply">
	                               <input type="hidden" name="fbidx" value="<%=bidx %>" />
	                               <%if(login != null){ %>
	                               <input type="hidden" name="midx"  value="<%=login.getMidx() %>" />
	                               <input type="hidden" name="memberName"  value="<%=login.getMembername() %>" />
	                               <%} %>
                               	   <textarea name="frcontent" class="form-control" rows="3" placeholder="로그인 후 이용해주세요!"></textarea>
                               	   <button id="replyInsert" type="button" class="btn btn-secondary" onclick="replySave()">등록</button>
                               </form>
                               <!-- Comment with nested comments-->
                               <div class="d-flex mb-4">
                                   <!-- Parent comment-->                                   
                                   <div class="ms-3">
                                   <%for(Reply r : rList) {%>	
                                       <div class="replyDate"><%=r.getRdate() %></div>
                                       <div class="fw-bold"><%=r.getMemberName()%><input type="hidden" name="fridx" value="<%=r.getRidx() %>" /></div>                                       
                                       <div class="replyContent"><%=r.getRcontent() %></div>
                                       <%if(login != null && login.getMidx() == r.getMidx()) {%>
                                       <div class="replyBtn">
                                       	<button id="replyModify" type="button" class="btn btn-secondary" onclick="modify(this)">수정</button>
                                       	<button id="replyDelete" type="button" class="btn btn-secondary" onclick="deleteReply(this)">삭제</button>
                                       </div>
                                       <%} %>
                                       <hr>                                                                                                                                                  
                                   <%} %>
                                   </div>                                 
                               </div>
                           </div>
                       </div>
                   </section>
				
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
						<%if(login != null){%>
						<li class="list-group-item list-group-item-secondary"><a href="<%=request.getContextPath() %>/mypage/mypage.jsp?nowPage=1&nowPage2=1">내가쓴 글 및 댓글 조회</a></li>
						<li class="list-group-item list-group-item-secondary"><a href="<%=request.getContextPath() %>/manager/showmember.jsp">회원정보 보기</a></li>
						<li class="list-group-item list-group-item-secondary"><a href="<%=request.getContextPath() %>/mypage/mypage.jsp?nowPage=1&nowPage2=1">내 정보 조회</a></li>
						<%} %>
					</ul>
				</div>
			</div>
		</section>
		<%@include file = "../../footer.jsp" %>
	</div>
	<script>
		function deleteFn(){
			var YN = confirm("정말 삭제하시겠습니까?");
			if(YN){
				document.frm.submit();
			}
		}
	</script>
</body>
</html>