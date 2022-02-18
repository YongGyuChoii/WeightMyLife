<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
	String idValue = request.getParameter("idValue");
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Weight My Life</title>
<link rel="stylesheet" href="<%=request.getContextPath() %>/static/login.css" />
<script src="<%=request.getContextPath() %>/js/jquery-3.6.0.min.js"></script>
<script>
	$(document).ready(function(){
		$(".header").click(function(){
			location.href="<%=request.getContextPath() %>/index.jsp";
		});
	});
</script>
</head>
<body>
	<section>
		<form name="frm" action="loginOk.jsp" method="post">
			<div class="header"><span>W</span>eight <span>M</span>y <span>L</span>ife</div>
			<div class="idd">
				<input type="text" class="id" id="id" name="memberid" placeholder="아이디를 입력하세요" value="<%if(idValue!=null && !idValue.equals("찾는 아이디가 없습니다.")){out.print(idValue);}%>"> 
			</div>
			<div class="pwdd">
				<input type="password" class="pwd" id="pwd" name="memberpwd" placeholder="비밀번호를 입력하세요"> 
			</div>
			<input type="button" value="취소" onclick="location.href='<%=request.getContextPath() %>/index.jsp'"/>
			<input type="submit" id="sub" name="sub" alt="sub" value="로그인">
			<div class="loginText">
				<a href="findId.jsp">아이디 찾기</a>  |  <a href="findPwd.jsp">비밀번호 찾기</a>  |  <a href="join.jsp">회원가입</a>
			</div>
		</form>
	</section>
</body>
</html>