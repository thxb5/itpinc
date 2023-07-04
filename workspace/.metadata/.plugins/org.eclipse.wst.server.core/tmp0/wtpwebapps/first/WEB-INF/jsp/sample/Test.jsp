<%@ page language="java" contentType="text/html; charset=EUC-KR"
    pageEncoding="EUC-KR"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=EUC-KR">
<title>Insert title here</title>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ include file ="/WEB-INF/include/include-header.jspf" %>

</head>
<body>
  <h2>�Խ��� ���</h2>
	<table class="board_list">
		<colgroup>
			<col width="10%"/>
			<col width="50"/>

		</colgroup>
		<thead>
			<tr>
				<th scope="col">�۹�ȣ</th>
				<th scope="col">����</th>
			</tr>
		</thead>
		<tbody>
			<c:choose>
				<c:when test="${fn:length(list) > 0}">  <!-- boolean -->
					<c:forEach items="${list }" var="row" varStatus="status">
						<tr>
							<td>${row.IDX }</td>
							<td class="title">
								<a href="#this" name="title">${row.TITLE }</a>
								<input type="hidden" id="IDX" value="${row.IDX }">
							</td>
						</tr>
					</c:forEach>
				</c:when>
				<c:otherwise>
					<tr>
						<td colspan="4">��ȸ�� ����� �����ϴ�.</td>
					</tr>
				</c:otherwise>
			</c:choose>
		</tbody>
	</table>
	<c:if test="${not empty paginationInfo }">
		<ui:pagination paginationInfo = "${paginationInfo }" type="text" jsFunction="fn_search"/>
	</c:if>
	<input type="hidden" id="currentPageNo" name="currentPageNo"/>
	
	<br/>
	<a href="#this" class="btn" id="write">�۾���</a>
	
	<%@ include file="/WEB-INF/include/include-body.jspf" %>
	
	<script type="text/javascript">
		$(document).ready(function(){
			$("#write").on("click", function(e){ //�۾��� ��ư
				e.preventDefault();
				fn_openBoardWrite();
			});	
			
			$("a[name='title']").on("click", function(e){ //���� 
				e.preventDefault();
				fn_openBoardDetail($(this)); //$(this)�ǹ� : jQuery <a �±��ǹ�
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
			comSubmit.addParam("IDX", obj.parent().find("#IDX").val()); // key�� value��
			comSubmit.submit();
		}
		
		function fn_search(pageNo)
		{
			var comSubmit = new ComSubmit();
			comSubmit.setUrl("<c:url value='/sample/openBoardList.do'/>");
			comSubmit.addParam("currentPageNo", pageNo);
			comSubmit.submit();
		}
	</script>
</body>
</html>