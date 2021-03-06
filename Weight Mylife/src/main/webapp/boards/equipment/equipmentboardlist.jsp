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
		sql = "select count(*) as total from equipmentboard ";
		
		psmt = conn.prepareStatement(sql);
		rs = psmt.executeQuery();
		
		int total = 0;
		
		if(rs.next()){
			total = rs.getInt("total");
		}
		
		paging = new PagingUtil(total,nowPageI,10);
		
		sql = " select * from ";
		sql += " (select rownum r,b.* from ";
		sql += " (select * from equipmentboard ";
		
		sql += "order by ebidx desc) b)";
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
<link rel="stylesheet" href="<%=request.getContextPath() %>/static/equipboardlist.css" />
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.7.2/font/bootstrap-icons.css">
<script src="<%=request.getContextPath() %>/js/jquery-3.6.0.min.js"></script>
<script src="<%=request.getContextPath() %>/js/bootstrap.min.js"></script>
<script>
	function openClose() {
	    if ($("#post-box").css("display") == "block") {
	        $("#post-box").hide();
	        $("#btn-post-box").text("????????????");
	    } else {
	        $("#post-box").show();
	        $("#btn-post-box").text("??????");
	    }
	}
	
	function modifyFn(obj){
		var esubject = $(obj).parent().parent().find('h5').text();
		var econtent = $(obj).parent().parent().find('.card-text').text();
		var ebidx = $(obj).parent().parent().find('input:hidden').val();
		var html = "<input type='text' name='esubject' value='"+esubject+"'><input type='hidden' name='origin' value='"+esubject+"'>";
		var html2 = "<textarea name='econtent' rows='5' id='econtent' class='form-control' style='overflow-y:scroll'>"+econtent+"</textarea><input type='hidden' name='origin2' value='"+econtent+"'>"
		$(obj).parent().parent().find('h5').html(html);
		$(obj).parent().parent().find('.card-text').html(html2);
		var html3 = "<button type='button' class='btn btn-info' onclick='saveFn(this)'>??????</button>&nbsp;<button type='button' class='btn btn-info' onclick='cancleFn(this)'>??????</button>";
		$(obj).parent().html(html3);
	}
	
	function cancleFn(obj){
		var esubject = $(obj).parent().parent().find("input[name=origin]").val();
		var html = esubject;
		$(obj).parent().parent().find('.card-title').html(html);
		var econtent = $(obj).parent().parent().find("input[name=origin2]").val();
		html = "<p>"+econtent+"</p>";
		$(obj).parent().parent().find('.card-text').html(html);
		html = "<button name='modify' type='button' class='btn btn-info' onclick='modifyFn(this)'>??????</button>&nbsp;<button name='delete' type='button' class='btn btn-info' onclick='deleteFn(this)'>??????</button>";
		$(obj).parent().html(html);
	}
	
	function saveFn(obj){
		var YN = confirm("?????? ?????????????????????????");
		if(YN) {
		var esubject = $(obj).parent().parent().find("input[name=esubject]").val();
		var econtent = $(obj).parent().parent().find("textarea[name=econtent]").val();
		var ebidx = $(obj).parent().parent().find('input[name=ebidx]').val();
		
		$.ajax({
			url: "equipmentboardmodify.jsp",
			type: "post",
			data: "esubject="+esubject+"&econtent="+econtent+"&ebidx="+ebidx,
			success: function(data){
				window.location.reload();
			}
		});
		
		}
	}
	
	function deleteFn(obj){
		var YN = confirm("?????? ?????????????????????????");
		if(YN) {
			var ebidx = $(obj).parent().parent().find('input[name=ebidx]').val();
			
			$.ajax({
				url: "equipmentboarddelete.jsp",
				type: "post",
				data: "ebidx="+ebidx,
				success: function(data){
					window.location.reload();
				}
			});
			
		}
	}
</script>
<style>
header li:nth-child(5) a:nth-child(1) {
	color: orange;
}
</style>
</head>
<body>
	<div id="wrap">
		<%@include file = "../../header.jsp" %> 
		<section>
			<hr style="border: solid black 1px">
			
			<div class="post-box">
	            <p class="lead">
	                <button onclick="openClose()" id="btn-post-box" type="button" class="btn btn-outline-dark">????????????</button> 
	            </p>
        	</div>
        	
        	<form name="insert" action="insert.jsp" method="post" enctype="multipart/form-data">
	        <div id="post-box" class="form-post" style="display:none">    		
	            <div>
	                <div class="form-group">
	                    <label for="user">??????</label>
	                    <input name="esubject" id="esubject" class="form-control" placeholder="">
	                </div>
	
	                <div class="form-group" width="600px">
	                    <label for="title">url</label>
	                    <input name="url" id="url" class="form-control" placeholder=""> 
	                </div>
	
	                    <div class="input-group mb-3">
							<label class="input-group-text" for="inputGroupFile01">Upload</label>
							<input type="file" name="file" class="form-control" id="inputGroupFile01">
						</div>
	
	                <div class="form-group">
	                    <label for="comment">?????? ?????????</label>
	                    <textarea name="econtent" rows="10" id="econtent" class="form-control" placeholder="????????? ????????? ????????????." style="overflow-y:scroll"></textarea>
	                </div>
	
	                <button type="button" class="btn btn-success" onclick="insertFn()">??????</button>
	            </div>
	        </div>
	        </form>

			<div class="row row-cols-1 row-cols-md-3 g-4">
				<%while(rs.next()){ %>
				<div class="col">
					<div class="card">
						<%if(rs.getString("EFileRealName") != null){ %>						
						<img src="<%=request.getContextPath() %>/upload/<%=rs.getString("EFileRealName") %>" class="card-img-top" alt="????????????">
						<%} else{%>
						<img src="<%=request.getContextPath() %>/static/no_image.gif" class="card-img-top" alt="????????????">
						<%} %>
						<div class="card-body">
							<h5 class="card-title"><%=rs.getString("Esubject") %></h5>
							<%if(login != null){ %><a href="equipmentboardup.jsp?ebidx=<%=rs.getInt("ebidx")%>&midx=<%=login.getMidx()%>"><i class="bi bi-hand-thumbs-up-fill" style="font-size: 2rem; color: cornflowerblue;"></i></a><%} %>
							<p>????????? : <%=rs.getInt("elikey") %> | ???????????? : <%=rs.getString("edate") %></p>
							<p>????????? : <%=rs.getString("ewriter") %></p>
							<p class="card-text"><%=rs.getString("Econtent") %></p>
							<a href="<%=rs.getString("url") %>" target="_blank" class="btn btn-primary">????????????</a>
							<input type="hidden" name="ebidx" value="<%=rs.getInt("ebidx") %>" />
							<%if(login != null && login.getMidx() == rs.getInt("midx")){ %>
							<div class="btn-jone">
							<button name="modify" type="button" class="btn btn-info" onclick="modifyFn(this)">??????</button>
							<button name="delete" type="button" class="btn btn-info" onclick="deleteFn(this)">??????</button>
							</div>
							<%} %>
						</div>
					</div>
				</div>
				<%} %>
			</div>

			<div class="pagingArea">
					<nav aria-label="Page navigation example">
						<ul class="pagination">
							<li class="page-item"><a class="page-link"
								<%if(paging.getStartPage() > 1){ %>
								href="equipmentboardlist.jsp?nowPage=<%=paging.getStartPage()-1 %>"
								<%} %> aria-label="Previous"> <span aria-hidden="true">&laquo;</span>
							</a></li>

							<%for(int i = paging.getStartPage(); i <= paging.getEndPage(); i++) {%>
							<%if(i == paging.getNowPage()) {%>
							<li class="page-item active" aria-current="page"><a
								class="page-link" href="#"><%=i %></a></li>
							<%}else { %>
							<li class="page-item"><a class="page-link"
								href="equipmentboardlist.jsp?nowPage=<%=i%>"><%=i %></a></li>
							<%} %>
							<%} %>

							<li class="page-item"><a class="page-link"
								<%if(paging.getEndPage() != paging.getLastPage()) {%>
								href="equipmentboardlist.jsp?nowPage=<%=paging.getEndPage()+1 %>"
								<%} %> aria-label="Next"> <span aria-hidden="true">&raquo;</span>
							</a></li>
						</ul>
					</nav>
				</div>

				<div class="main-left">

					<img src="<%=request.getContextPath() %>/static/banner.jpg"
						alt="???????????????" class="banner-img" />

					<div class="main-ques">
						<div class="card text-white bg-secondary mb-3"
							style="max-width: 18rem;">
							<div class="card-header">???????????? ????????????</div>
							<div class="card-body">
								<h5 class="card-title">TEL: 010-4334-1293</h5>
								<p class="card-text">FAX: 1111-1111</p>
								<p class="card-text">?????????: dydrb219@naver.com</p>
							</div>
						</div>
					</div>
				</div>

				<div class="main-scroll">
					<div class="card border-secondary mb-3" style="width: 15rem;">
						<ul class="list-group list-group-flush">
							<li class="list-group-item active"><span>????????? ????????? TOP5</span></li>
							<%for(LiveDTO l : lList){ %>
							<li class="list-group-item"><a
								<%if(l.getBoardType().equals("free")){ %>
								href="<%=request.getContextPath() %>/boards/free/freeboardview.jsp?bidx=<%=l.getBidx()%>"
								<%}else if(l.getBoardType().equals("introduce")){ %>
								href="<%=request.getContextPath() %>/boards/intro/introduceboardview.jsp?bidx=<%=l.getBidx()%>"
								<%}else if(l.getBoardType().equals("trainer")){ %>
								href="<%=request.getContextPath() %>/boards/trainer/trainerboardview.jsp?bidx=<%=l.getBidx()%>"
								<%}else if(l.getBoardType().equals("qanda")){ %>
								href="<%=request.getContextPath() %>/boards/qanda/qandaboardview.jsp?bidx=<%=l.getBidx()%>"
								<%} %>> <%out.print(bestCount++ +".");%><%=l.getSubject() %></a></li>
							<%} %>
							<%if(login != null){%>
							<li class="list-group-item list-group-item-secondary"><a
								href="<%=request.getContextPath() %>/mypage/mypage.jsp?nowPage=1&nowPage2=1">?????????
									??? ??? ?????? ??????</a></li>
							<li class="list-group-item list-group-item-secondary"><a
								href="<%=request.getContextPath() %>/manager/showmember.jsp">????????????
									??????</a></li>
							<li class="list-group-item list-group-item-secondary"><a
								href="<%=request.getContextPath() %>/mypage/mypage.jsp?nowPage=1&nowPage2=1">???
									?????? ??????</a></li>
							<%} %>
						</ul>
					</div>
				</div>
		</section>
		<%@include file = "../../footer.jsp" %>
	</div>
	<script>
		function insertFn() {
			var login = '<%=login%>';
			var YN = confirm("?????? ?????????????????????????");
			if(YN){
				if(login == 'null'){
					alert("????????? ??? ?????? ???????????????.");
				}else {
					document.insert.submit();
				}
			}
		}
	</script>
</body>
</html>
<%
	}catch(Exception e){
		e.printStackTrace();
	}finally{
		DBManager.close(psmt, conn, rs);
	}
%>