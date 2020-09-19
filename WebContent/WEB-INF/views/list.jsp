<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>员工列表</title>

<%
	pageContext.setAttribute("APP_PATH", request.getContextPath());
%>

<script type="text/javascript" src="${APP_PATH}/static/js/jquery-3.5.1.js"></script>
<link href="${APP_PATH}/static/css/bootstrap.min.css" rel="stylesheet">
<script type="${APP_PATH}/text/javascript" src="static/js/bootstrap.min.js"></script>

 

</head>
<body>
	<div class="container">
	
		<!-- 标题 -->
		<div class="row">
			<div class="col-md-4">
			<h1>SSM-CRUD</h1>
			</div>
		</div>
		<!-- 按钮 -->
		<div class="row"> 
			<div class="col-md-4 col-md-offset-8">
				<button class="btn btn-primary">新增</button>
				<button class="btn btn-danger">删除</button>
			</div>
		</div>
		<!-- 表格 -->
		<div class="row">
			<div class="col-md-12">
				<table class="table table-striped table-hover">
					<tr>
						<td>ID</td>
						<td>姓名</td>
						<td>所属部门</td>
						<td>操作</td>
					</tr>
					
					<c:forEach  items="${pageInfo.list}" var="emp">
						<tr>
						<td>${emp.nid}</td>
						<td>${emp.name}</td>
						<td>${emp.department.name}</td>
						<td> 
						
						<button class="btn btn-primary btn-sm">
						<span class="glyphicon glyphicon-pencil" aria-hidden="true">
						</span>
						编辑
						</button>
						 
						 <button class="btn btn-danger btn-sm">
						 
						 <span class="glyphicon glyphicon-trash" aria-hidden="true">
						 </span>
						 删除
						 </button>
						</td>
					</tr>
					</c:forEach>
					
				</table>
			</div>
		</div>
		
		<!-- 显示分页信息 -->
		<div class="row">
			<div class="col-md-6">
				当前在第${pageInfo.pageNum}页，总${pageInfo.pages}页，总${pageInfo.total}条记录
			</div>
			<div class="col-md-6">
				<nav aria-label="Page navigation">
  <ul class="pagination">
    
     <c:if test="${pageInfo.hasPreviousPage }">
     <li>
     	 <a href="${APP_PATH}/getAll?pn=${pageInfo.pageNum - 1}" aria-label="Previous">
        <span aria-hidden="true">&laquo;</span>
      </a>
       </li>
     </c:if>
   
   	<c:if test="${pageInfo.pageNum != 1}">
   		<li><a href="${APP_PATH}/getAll?pn=1">首页</a></li>
   	</c:if>
    <c:forEach items="${pageInfo.navigatepageNums }" var="pageNum">
    	<c:if test="${pageNum == pageInfo.pageNum}">
    		<li class="active"><a href="${APP_PATH}/getAll?pn=${pageNum}">${pageNum}</a></li>
    	</c:if>
	    
	    <c:if test="${pageNum != pageInfo.pageNum}">
    		<li><a href="${APP_PATH}/getAll?pn=${pageNum}">${pageNum}</a></li>
    	</c:if>
	    
    </c:forEach>
   
   <c:if test="${pageInfo.pageNum != pageInfo.pages }">
   	    <li><a href="${APP_PATH}/getAll?pn=${pageInfo.pages}">尾页</a></li>
   </c:if>

  	
  	
  	<c:if test="${pageInfo.hasNextPage }">
  	<li>
      <a href="${APP_PATH}/getAll?pn=${pageInfo.pageNum + 1}" aria-label="Next">
        <span aria-hidden="true">&raquo;</span>
      </a>
    </li>
  	</c:if>
  	
  </ul>
</nav>
			</div>
		</div>
	</div>
</body>
</html>