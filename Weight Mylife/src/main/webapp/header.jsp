<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="boardWeb.vo.*" %>
<%
	Member m = (Member)session.getAttribute("loginUser");
%>    
<header>
	<h1><a href="<%=request.getContextPath() %>/index.jsp"><span id="f">W</span>eight <span id="c">M</span>y <span id="l">L</span>ife</a></h1>
	<a href="<%=request.getContextPath() %>/index.jsp"><img src="<%=request.getContextPath() %>/static/logo.png" alt="메인로고" class="main-logo" /></a>
	<%
		if(m == null){
	%>
	<div class="main-join">
		<a href="<%=request.getContextPath() %>/member/login.jsp">로그인</a> | 
		<a href="<%=request.getContextPath() %>/member/join.jsp">회원가입</a>
	</div>
	<%
		} else {
	%>
	<div class="main-join">
		<%
			if(m.getRanking().equals("관리자")){
		%>
		<a id="manager" href="<%=request.getContextPath() %>/manager/manager.jsp">관리자</a> | 
		<%} %>
		<a id="mypage" href="<%=request.getContextPath() %>/mypage/mypage.jsp?nowPage=1&nowPage2=1">마이페이지</a> | 
		<a href="<%=request.getContextPath() %>/member/logout.jsp">로그아웃</a>
		<h5><%=m.getMembername() %>님 환영합니다.</h5>
	</div>
	<%} %>
	<ul id="nav5" class="nav justify-content-around bg-light"> 
		<li class="nav-item"> 
			<a class="nav-link active" href="<%=request.getContextPath() %>/boards/free/freeboardlist.jsp">자유게시판</a> 
		</li>
		<li class="nav-item"> 
			<a class="nav-link" href="<%=request.getContextPath() %>/boards/intro/introduceboardlist.jsp">우리동네 헬스장</a> 
		</li>
		<li class="nav-item"> 
			<a class="nav-link" href="<%=request.getContextPath() %>/boards/trainer/trainerboardlist.jsp">트레이너 게시판</a> 
		</li>
		<li class="nav-item"> 
			<a class="nav-link" href="<%=request.getContextPath() %>/boards/qanda/qandaboardlist.jsp">Q&A 게시판</a> 
		</li>
		<li class="nav-item"> 
			<a class="nav-link" href="<%=request.getContextPath() %>/boards/equipment/equipmentboardlist.jsp">기구 & 장비</a> 
		</li>
	</ul>
</header>