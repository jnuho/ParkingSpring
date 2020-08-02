<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%@ include file="/WEB-INF/views/common/header.jsp" %>
<% 
  String snsEmail = (String)request.getAttribute("useremail");
  String snsAccount =(String)request.getAttribute("snsaccount");
%>

  <link rel="stylesheet" href="<%=request.getContextPath() %>/css/signup.css">

 
  <div class="container sns">
    <div class="d-flex justify-content-center h-100">
      <div class="card">
        <div class="card-header">
          <h3>Sign Up</h3>
        </div>
        <div class="card-body">
          <form action="<%=request.getContextPath() %>/memberEnrollEnd" method="post" onsubmit="return validateEnroll();">
            <div class="input-group form-group">
              <input type="text" class="form-control" placeholder="Username" name="userName" id="userName" required>
            </div>

            <div class="input-group form-group">
            
              <input type="email" class="form-control form-group mr-3" placeholder="Email" id="email" name="email" value="<%=snsEmail%>" readonly>
              <input type="button" class="btn btn-secondary form-group form-control" value="check duplication" onclick="checkEmailDuplicate();" disabled>
            </div>

            <div class="input-group form-group">
              <input type="password" class="form-control" placeholder="Password" id="pwEnroll" name="pwEnroll" readonly>
            </div>

            <div class="input-group form-group">
              <input type="password" class="form-control" placeholder="Confirm password" id="pwEnrollChk" name="pwEnrollChk" readonly>
            </div>

            <div class="input-group form-group">
              <input type="text" class="form-control" placeholder="Phone number" id="phone" name="phone" required>
            </div>

            <div class=" input-group form-group">
             <input type="postcode" class="mr-3 col-md-3 form-control" placeholder="Postcode" id="postcode" name="postcode">
              <input type="address" class="form-control" placeholder="roadAddress" id="roadAddress" name="roadAddress" required>
              <input type="hidden" class="form-control" placeholder="jibunAddress" id="jibunAddress" name="jibunAddress">
              <span class="form-control" id="guide" style="color:#999;display:none"></span>
              <input type="hidden" class="form-control" placeholder="extraAddress" id="extraAddress" name="extraAddress">
              <span class="input-group-text" type="button" onclick="execdaumPostcode()"><i class="fa fa-search"></i></span>
            </div>

            <div class="checkbox">
              <label class="privacy">
                <input type="checkbox" id="termsChk" name="termsChk" required> I accept the <a href="#">Terms of Use</a> &<a href="#"> Privacy Policy</a>
              </label>

              <label class="spam_sms">
                <input type="checkbox" id="smsYn" name="smsYn" > By clicking the box, you agree to receive our latest news and special offers by phone!
              </label> 

              <label class="spam_email">
                <input type="checkbox" id="emailYn" name="emailYn" > By clicking the box, you agree to receive our latest news and special offers by email!
              </label>
            </div>

            <div class="form-group">
              <input type="submit" value="submit" class="btn float-right submit_btn">
            </div>

            <!-- snsAccount 'G', 'F' 'K' 'N/A' -->
            <input type="hidden" id="snsAccount" name="snsAccount" value="<%=snsAccount %>" />
          </form>

          <form method="post" name="checkEmailDuplicateHiddenFrm">
            <input type="hidden" name="emailHidden">
          </form>

        </div>

      </div>
    </div>
  </div>
  
  <script>
//본 예제에서는 도로명 주소 표기 방식에 대한 법령에 따라, 내려오는 데이터를 조합하여 올바른 주소를 구성하는 방법을 설명합니다.
  function execdaumPostcode() {
      new daum.Postcode({
          oncomplete: function(data) {
              // 팝업에서 검색결과 항목을 클릭했을때 실행할 코드를 작성하는 부분.

              // 도로명 주소의 노출 규칙에 따라 주소를 표시한다.
              // 내려오는 변수가 값이 없는 경우엔 공백('')값을 가지므로, 이를 참고하여 분기 한다.
              var roadAddr = data.roadAddress; // 도로명 주소 변수
              var extraRoadAddr = ''; // 참고 항목 변수

              // 법정동명이 있을 경우 추가한다. (법정리는 제외)
              // 법정동의 경우 마지막 문자가 "동/로/가"로 끝난다.
              if(data.bname !== '' && /[동|로|가]$/g.test(data.bname)){
                  extraRoadAddr += data.bname;
              }
              // 건물명이 있고, 공동주택일 경우 추가한다.
              if(data.buildingName !== '' && data.apartment === 'Y'){
                 extraRoadAddr += (extraRoadAddr !== '' ? ', ' + data.buildingName : data.buildingName);
              }
              // 표시할 참고항목이 있을 경우, 괄호까지 추가한 최종 문자열을 만든다.
              if(extraRoadAddr !== ''){
                  extraRoadAddr = ' (' + extraRoadAddr + ')';
              }

              // 우편번호와 주소 정보를 해당 필드에 넣는다.
              document.getElementById('postcode').value = data.zonecode;
              document.getElementById("roadAddress").value = roadAddr;
              document.getElementById("jibunAddress").value = data.jibunAddress;
              
              // 참고항목 문자열이 있을 경우 해당 필드에 넣는다.
              if(roadAddr !== ''){               
            	  document.getElementById("extraAddress").value = extraRoadAddr;
            	  document.getElementById("roadAddress").value += extraRoadAddr;
              } else {
                  document.getElementById("roadAddress").value += '';
              }

              var guideTextBox = document.getElementById("guide");
              // 사용자가 '선택 안함'을 클릭한 경우, 예상 주소라는 표시를 해준다.
              if(data.autoRoadAddress) {
                  var expRoadAddr = data.autoRoadAddress + extraRoadAddr;
                  guideTextBox.innerHTML = '(예상 도로명 주소 : ' + expRoadAddr + ')';
                  guideTextBox.style.display = 'block';

              } else if(data.autoJibunAddress) {
                  var expJibunAddr = data.autoJibunAddress;
                  guideTextBox.innerHTML = '(예상 지번 주소 : ' + expJibunAddr + ')';
                  guideTextBox.style.display = 'block';
              } else {
                  guideTextBox.innerHTML = '';
                  guideTextBox.style.display = 'none';
              }
          }
      }).open();
    }
  
    function checkEmailDuplicate(){
      if($("#email").val().trim() == ""){
        alert("Type email!");
        return;
      }

      var title = "checkEmailDuplicate";
      var status = "left=500px, top=100px, width=300px, height=200px, menubar=n, status=no, scrollbars=yes";
      var popup = open("", title, status); //window.open()
      var url = "<%=request.getContextPath() %>/checkEmailDuplicate";

      checkEmailDuplicateHiddenFrm.action = url;
      checkEmailDuplicateHiddenFrm.emailHidden.value = $("#email").val().trim();
      checkEmailDuplicateHiddenFrm.target = title;
      checkEmailDuplicateHiddenFrm.submit();
    }

    //signup form validation
    function validateEnroll(){
      //check username length
      var userName = $("#userName");
      if(userName.val().trim().length < 2){
        alert("User name must contain more than 1 character.")
        userName.focus();
        return false;
      }

      //must agree with our terms of agreement
      if(!$("#termsChk").is(':checked'))
        return false;

  

<%@ include file="/WEB-INF/views/common/footer.jsp" %>