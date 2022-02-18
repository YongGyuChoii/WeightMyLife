<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Weight My Life</title>
<link rel="stylesheet" href="<%=request.getContextPath() %>/static/join.css" />
<script src="<%=request.getContextPath() %>/js/jquery-3.6.0.min.js"></script>
<script>
	$(document).ready(function(){
		
		$("#id").click(function(){
			let memberid = $("#memberid").val();
			
			$.ajax({
				url: "joinIdCheck.jsp",
				type: "post",
				data: {memberid: memberid},
				success: function(data){
					console.log(data);
					if(data == 0){
						alert("아이디 중복입니다.");
					}else {
						alert("사용 가능합니다.");
					}
				},
				error : function(){
					alert("요청실패");
				}
			});
		});
		
		$(".header").click(function(){
			location.href="<%=request.getContextPath() %>/index.jsp";
		});
		
		$(".impor").blur(function(){
			var checkId = /^[a-z]+[a-z0-9]{5,15}/g;
			var checkPwd = /^.*(?=^.{8,15}$)(?=.*\d)(?=.*[a-zA-Z])(?=.*[!@#$%^&+=]).*$/;
			var checkName = /^[ㄱ-ㅎ|ㅏ-ㅣ|가-힣]/g;
			var checkEmail1 = /^[0-9a-zA-Z]([-_\.]?[0-9a-zA-Z])*$/i;
			var checkEmail2 = /^[0-9a-zA-Z]([-_\.]?[0-9a-zA-Z])*\.[a-zA-Z]{2,3}$/i;
			var checkPhone1 = /^[0-9]{3,4}/g;
			var checkPhone2 = /^[0-9]{4}/g;
			var checkAge = /^[0-9]{1}/g;
			$(this).siblings(".check").text("").hide();
			var value = $(this).val();
			if(value==""){
				$(this).siblings(".check").text("*필수").css("color","red").show();
			}else{
				var id = $(this).attr("id");
				if(id == "memberid"){
					var test = checkId.test(value);
					if(!test){
						$(this).siblings(".check").text("*형식오류").css("color","red").show();
					}
				}else if(id == "memberpwd"){
					var test = checkPwd.test(value);
					if(!test){
						$(this).siblings(".check").text("*형식오류").css("color","red").show();
					}
				}else if(id == "passwordre"){
					if(value != $("input[id=memberpwd]").val()){
						$(this).siblings(".check").text("*비밀번호 불일치").css("color","red").show();
					}
				}else if(id == "membername"){
					var test = checkName.test(value);
					if(!test){
						$(this).siblings(".check").text("*형식오류").css("color","red").show();
					}
				}else if(id == "email1"){
					var test = checkEmail1.test(value);
					if(!test){
						$(this).siblings(".check").text("*형식오류").css("color","red").show();
					}
				}else if(id == "email2"){
					var test = checkEmail2.test(value);
					if(!test){
						$(this).siblings(".check").text("*형식오류").css("color","red").show();
					}
				}else if(id == "phone2"){
					var test = checkPhone1.test(value);
					console.log(test+"1");
					if(!test){
						$(this).siblings(".check").text("*형식오류").css("color","red").show();
					}
				}else if(id == "phone3" ){
					var test = checkPhone2.test(value);
					console.log(test+"2");
					if(!test){
						$(this).siblings(".check").text("*형식오류").css("color","red").show();
					}
				}else if(id == "age"){
					var test = checkAge.test(value);
					if(!test){
						$(this).siblings(".check").text("*형식오류").css("color","red").show();
					}
				}
			}
		});
		$("form").submit(function(){
			var checkId = /^[a-z]+[a-z0-9]{5,15}/g;
			var checkPwd = /^.*(?=^.{8,15}$)(?=.*\d)(?=.*[a-zA-Z])(?=.*[!@#$%^&+=]).*$/;
			var checkName = /^[ㄱ-ㅎ|ㅏ-ㅣ|가-힣]/g;
			var checkEmail1 = /^[0-9a-zA-Z]([-_\.]?[0-9a-zA-Z])*$/i;
			var checkEmail2 = /^[0-9a-zA-Z]([-_\.]?[0-9a-zA-Z])*\.[a-zA-Z]{2,3}$/i;	
			var checkPhone1 = /^[0-9]{3,4}/g;
			var checkPhone2 = /^[0-9]{4}/g;
			var checkAge = /^[0-9]{1}/g;
			var check=true;
			var first;
			$(".impor").each(function(index){
				var value = $(this).val();
				$(this).siblings(".check").text("").hide();
				if(value==""){
					$(this).siblings(".check").text("*필수").css("color","red").show();
					check = false;
					if(first===undefined){
						first = index;
					}
				}else{
					var id = $(this).attr("id");
					if(id == "memberid"){
						var test = checkId.test(value);
						if(!test){
							$(this).siblings(".check").text("*형식오류").css("color","red").show();
						}
					}else if(id == "memberpwd"){
						var test = checkPwd.test(value);
						if(!test){
							$(this).siblings(".check").text("*형식오류").css("color","red").show();
							check = false;
						}
					}else if(id == "passwordre"){
						if(value != $("input[id=memberpwd]").val()){
							$(this).siblings(".check").text("*비밀번호 불일치").css("color","red").show();
						}
					}else if(id == "membername"){
						var test = checkName.test(value);
						if(!test){
							$(this).siblings(".check").text("*형식오류").css("color","red").show();
							check = false;
						}
					}else if(id == "email1"){
						var test = checkEmail1.test(value);
						if(!test){
							$(this).siblings(".check").text("*형식오류").css("color","red").show();
							check = false;
						}
					}else if(id == "email2"){
						var test = checkEmail2.test(value);
						if(!test){
							$(this).siblings(".check").text("*형식오류").css("color","red").show();
							check = false;
						}
					}else if(id == "phone2"){
						var test = checkPhone1.test(value);
						if(!test){
							$(this).siblings(".check").text("*형식오류").css("color","red").show();
							check = false;
						}
					}else if(id == "phone3" ){
						var test = checkPhone2.test(value);
						if(!test){
							$(this).siblings(".check").text("*형식오류").css("color","red").show();
							check = false;
						}
					}else if(id == "age" ){
						var test = checkAge.test(value);
						if(!test){
							$(this).siblings(".check").text("*형식오류").css("color","red").show();
							check = false;
						}
					}
				}
			});
			$(".impor").eq(first).focus();
			return check;
		});
	});
</script>
</head>
<body>
	<section>
		<form name="frm" action="joinOk.jsp" method="post">
			<div class="header"><span>W</span>eight <span>M</span>y <span>L</span>ife</div>
			<div class="rows h">
				<label for="memberid">아이디<span class="red">*</span></label>
			</div>
			<div class="rows id">
				<input type="text" class="id impor" name="memberid" id="memberid" placeholder="아이디를 입력하세요.">
				<input type="button" class="id" id="id" value="id 중복확인">
				<span class="check"></span>
			</div>
			
			<div class="rows h">
				<label for="memberpwd">비밀번호<span class="red">*</span></label>
			</div>
			<div class="rows">
				<input type="password" class="impor" name="memberpwd" id="memberpwd" placeholder="비밀번호를 입력하세요.">
				<span class="check"></span>
			</div>
			
			<div class="rows h">
				<label for="passwordre">비밀번호 확인<span class="red">*</span></label>
			</div>
			<div class="rows">
				<input type="password" class="impor" name="passwordre" id="passwordre" placeholder="비밀번호를 다시 입력하세요.">
				<span class="check"></span>
			</div>
			
			<div class="rows h">
				<label for="membername">이름<span class="red">*</span></label>
			</div>
			<div class="rows">
				<input type="text" class="impor" name="membername" id="membername" placeholder="이름을 입력하세요.">
				<span class="check"></span>
			</div>
			
			<div class="rows h">
				<label for="addr">주소<span class="red">*</span></label>
			</div>
			<div class="rows">
				<input type="text" class="impor" name="addr" id="addr">
				<span class="check"></span>
			</div>
			
			<div class="rows h">
				<label for="gender">성별</label>
			</div>
			<div class="rows">
				<input type="radio" name="gender" id="gender" value="남">남
				<input type="radio" name="gender" value="여">여
			</div>
			
			<div class="rows h">
				<label for="email">이메일<span class="red">*</span></label>
			</div>
			<div class="rows">
				<input type="text" class="impor" name="email1" id="email1">&nbsp;@&nbsp;
				<input type="text" class="impor" name="email2" id="email2">
				<span class="check"></span>
			</div>
			
			<div class="rows h">
				<label for="phone1">연락처<span class="red">*</span></label>
			</div>
			<div class="rows">
				<select name="phone1" id="phone1">
					<option value="010">010</option>
					<option value="011">011</option>
					<option value="016">016</option>
				</select>&nbsp;
				<input type="text" class="impor" name="phone2" id="phone2" placeholder="연락처2" maxlength="4" onKeyup="this.value=this.value.replace(/[^0-9]/g,'');">&nbsp;
				<input type="text" class="impor" name="phone3" id="phone3" placeholder="연락처3" maxlength="4" onKeyup="this.value=this.value.replace(/[^0-9]/g,'');">
				<span class="check"></span>
			</div>
			
			<div class="rows h">
				<label for="age">나이<span class="red">*</span></label>
			</div>
			<div class="rows">
				<input type="text" class="impor" name="age" id="age" maxlength="3" onKeyup="this.value=this.value.replace(/[^0-9]/g,'');"/>
				<span class="check"></span>
			</div>
			
			<div class="rows">
				<label>
					<input type="button" value="취소" class="cancle" onclick="location.href='<%=request.getContextPath() %>/index.jsp'"/>
					<input type="button" value="로그인" class="cancle" onclick="location.href='<%=request.getContextPath() %>/member/login.jsp'"/>
					<input type="submit" value="회원가입">
				</label>
			</div>
		</form>
	</section>
</body>
</html>