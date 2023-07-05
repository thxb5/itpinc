<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Insert title here</title>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ include file ="/WEB-INF/include/include-header.jspf" %>
<!-- 주노주노 ㅎㅇㅎㅇ -->
</head>
<body>
	<div style="display: flex; justify-content: center;">
		<select id="choice" name="choice" size="1">
			<option value="">선택하세요</option>
			<option value="idx">글번호</option>
			<option value="title">제목</option>
			<option value="contents">내용</option>
		</select>
		<input id="inputText" type="text" style="margin-left: 10px; margin-right:10px;">
		<input id="scBtn" type="button" value="조회">
	</div>
	<h2>게시판 목록</h2>
	<table class="board_list">
		<colgroup>
			<col width="5%"/>
			<col width="10%"/>
			<col width="10%"/>
			<col width="*"/>
			<col width="15%"/>
			<col width="20%"/>
		</colgroup>
		<thead>
			<tr>
				<th scope="col"><input type="checkbox" id="chkAll"></th>
				<th scope="col">글번호</th>
				<th scope="col">미리보기</th>
				<th scope="col">제목</th>
				<th scope="col">조회수</th>
				<th scope="col">작성일</th>
			</tr>
		</thead>
		<tbody>
			<c:choose>
				<c:when test="${fn:length(list) > 0}">  <!-- boolean -->
					<c:forEach items="${list }" var="row" varStatus="status">
						<tr>
							<td><input type="checkbox" name="chk"></td>
							<td>${row.IDX }</td>
							<td>
								<a name="preview" href="#this">미리보기</a>
								<input style="display:none;" type="hidden" id="contents" value="${row.CONTENTS }">
							</td>
							<td class="title">
								<a href="#this" name="title">${row.TITLE }</a>
								<input type="hidden" id="IDX" value="${row.IDX }">
								
							</td>
							<td>${row.HIT_CNT }</td>
							<td>${row.CREA_DTM }</td>
						</tr>
					</c:forEach>
				</c:when>
				<c:otherwise>
					<tr>
						<td colspan="4">조회된 결과가 없습니다.</td>
					</tr>
				</c:otherwise>
			</c:choose>
		</tbody>
	</table>
	
	<c:if test="${not empty paginationInfo }">
		<ui:pagination paginationInfo = "${paginationInfo }" type="text" jsFunction="fn_search"/>
	</c:if>
	<input type="hidden" id="currentPageNo" name="currentPageNo"/>
	<input type="hidden" id="choicePage" value="${choice}">
	<input type="hidden" id="inputTextPage" value="${inputText}">
	<br/>
	<a href="#this" class="btn" id="write">글쓰기</a>
	<a href="#this" class="btn" id="delete">삭제</a>
	
	<%@ include file="/WEB-INF/include/include-body.jspf" %>
	
	<script type="text/javascript">
		$(document).ready(function(){
			$("#write").on("click", function(e){ //글쓰기 버튼
				e.preventDefault();
				fn_openBoardWrite();
			});	
			
			$("a[name='title']").on("click", function(e){ //제목 
				e.preventDefault();
				fn_openBoardDetail($(this)); //$(this)의미 : jQuery <a 태그의미
			});

			$('#scBtn').on('click', function(e) {
			    var choice = $('#choice').val();
			    if (choice === "") {
			        alert("검색 항목을 선택해주세요!");
			        return;
			    }
			    e.preventDefault();
			    fn_openBoardSerch();
			});

			$("a[name='preview']").on('click', function(e) {
				e.preventDefault();
				fn_openBoardPre($(this));	
			});

			$("input[name=chk]").click(function() 
			{
				var total = $('input[name=chk]').length;
				var checked = $('input[name=chk]:checked').length;

				if(total != checked)
				{
					$("#chkAll").prop("checked", false);
				}else
				{
					$("#chkAll").prop("checked", true);
				}

			});

			$("#chkAll").click(function() 
			{
				if($("#chkAll").is(":checked"))
				{
					$("input[name=chk]").prop("checked", true);
				} else
				{
					$("input[name=chk]").prop("checked", false);
				}
			});

			$('#delete').on('click', function(e) {
			    e.preventDefault();
			    fn_BoardDelete($(this));
			});

		});
		
		
		function fn_openBoardWrite(){
			var comSubmit = new ComSubmit();
			comSubmit.setUrl("<c:url value='/sample/openBoardWrite.do' />");
			comSubmit.submit();
		}
		
		function fn_openBoardDetail(obj){
			var comSubmit = new ComSubmit();
			comSubmit.setUrl("<c:url value='/sample/openBoardDetail.do' />");
			comSubmit.addParam("IDX", obj.parent().find("#IDX").val()); // key와 value값
			comSubmit.addParam("choice", $("#choicePage").val()); 
			comSubmit.addParam("inputText", $("#inputTextPage").val()); 
			comSubmit.submit();
		}
		
		function fn_search(pageNo)
		{
			var comSubmit = new ComSubmit();
			comSubmit.setUrl("<c:url value='/sample/openBoardSearch.do'/>");
			comSubmit.addParam("currentPageNo", pageNo);
			comSubmit.addParam("choice", $("#choicePage").val()); 
			comSubmit.addParam("inputText", $("#inputTextPage").val()); 
			comSubmit.submit();
		}

		function fn_openBoardSerch()
		{
			var comSubmit = new ComSubmit();
			comSubmit.setUrl("<c:url value='/sample/openBoardSearch.do'/>");
			comSubmit.addParam("choice", $("#choice").val()); 
			comSubmit.addParam("inputText", $("#inputText").val()); 
			comSubmit.submit();
		}

		function fn_openBoardPre(obj)
		{
			var row = obj.closest('tr');
			var title = "게시글 미리보기";
			var title_content = row.find("a[name='title']").text();
			var board_content = obj.parent().find("#contents").val();

			var html = "<html><head><title>" + title + "</title></head><body><h2>" + title + "</h2><div>" + '제목' + "</div><div>" + title_content + "</div><div>" + '내용' + "</div><div>" + board_content + "</div></body></html>";

			var leftPosition = 100;  // 새 창의 가로 위치
			var topPosition = 100;   // 새 창의 세로 위치

			var win = window.open('', '게시글 미리보기', 'width=430,height=500,location=no,status=no,scrollbars=yes,left=' + leftPosition + ',top=' + topPosition);

			win.document.open();
			win.document.write(html);
			win.document.close();
		}

		function fn_BoardDelete(obj)
		{
			var chkArr = [];
			if ($("input[name='chk']").is(":checked")) {
			    $("input[name='chk']:checked").each(function() {
			        var idx = $(this).closest('tr').find("#IDX").val();
			        chkArr.push(idx);
			    });
			}
			console.log(chkArr);
			
			if(chkArr == []) {
				alert("삭제 항목을 선택해주세요!");
		        return;
			} else {
				var comSubmit = new ComSubmit();
				comSubmit.setUrl("<c:url value='/sample/selectDeleteBoard.do'/>");
				comSubmit.addParam("chkArr", chkArr); 
				comSubmit.submit();
			}
			
		
		}
		
	</script>	
</body>
</html>