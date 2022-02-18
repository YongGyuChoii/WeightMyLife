<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
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
		
		$("#sub").click(function(){
			let email1 = $("#email1").val();
			let email2 = $("#email2").val();
			
			$.ajax({
				url: "findIdAjax.jsp",
				type: "post",
				data: {"email1": email1, "email2": email2},
				success: function(data){
					$("#showEamil").val(data);
				},
				error : function(){
					alert("요청실패");
				}
			});
		});
	});
	
	function goLogin(){
		let idValue = $("#showEamil").val();
		location.href = 'login.jsp?idValue='+idValue;
	}	
</script>
</head>
<body>
	<section>
		<form name="frm" action="loginOk.jsp" method="post">
			<div class="header"><span>W</span>eight <span>M</span>y <span>L</span>ife</div>
			<div class="idd">
				<input type="text" class="email1" id="email1" name="email1" placeholder="이메일을 입력하세요"><span id="goal">@</span> 
				<input type="text" class="email2" id="email2" name="email2" placeholder="이메일을 입력하세요">
			</div>
			<div class="pwdd">
				<input type="text" class="showEamil" id="showEamil" name="showEamil" disabled> 
			</div>
			<input type="button" id="sub" name="sub" alt="sub" value="확인">
			<div class="loginText">
				<a href="javascript:goLogin();">로그인</a>  |  <a href="findPwd.jsp">비밀번호 찾기</a>
			</div>
		</form>
	</section>
</body>
</html>