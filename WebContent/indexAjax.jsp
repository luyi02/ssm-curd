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
<script type="text/javascript" src="${APP_PATH}/static/js/bootstrap.min.js"></script>

 

</head>
<body>

<!--新增员工数据的模态对话框 -->
<div class="modal fade" id="myModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel">
  <div class="modal-dialog" role="document">
    <div class="modal-content">
      <div class="modal-header">
        <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
        <h4 class="modal-title" id="myModalLabel">添加员工</h4>
      </div>
      <div class="modal-body">
       	<form class="form-horizontal">
  <div class="form-group">
    <label for="emptName_input" class="col-sm-2 control-label">员工姓名</label>
    <div class="col-sm-10">
      <input name = "name" type="text" class="form-control" id="emptName_input"  placeholder="员工姓名">
      <span  class="help-block"></span>
    </div>
  </div>
  <div class="form-group">
    <label for="deptId_input" class="col-sm-2 control-label">部门</label>
    <div class="col-sm-5">
    	<!-- 部门提交部门id即可 -->  
    	<select name="dId" class="form-control" id="dept_add_select">
		 
		</select>
    </div>
  </div>

</form>
      </div>
      <div class="modal-footer">
        <button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
        <button type="button" class="btn btn-primary" id="empl_save_btn">保存</button>
      </div>
    </div>
  </div>
</div>

<!-- 修改员工信息的模态对话框 -->

<div class="modal fade" id="myModal_update" tabindex="-1" role="dialog" aria-labelledby="myModalLabel">
  <div class="modal-dialog" role="document">
    <div class="modal-content">
      <div class="modal-header">
        <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
        <h4 class="modal-title" id="myModalLabel">修改员工数据</h4>
      </div>
      <div class="modal-body">
       	<form class="form-horizontal">
  <div class="form-group">
    <label for="emptName_update_input" class="col-sm-2 control-label">员工姓名</label>
    <div class="col-sm-10">
       <p class="form-control-static" id = "empName_update_static"></p>
      <span  class="help-block"></span>
    </div>
  </div>
  <div class="form-group">
    <label for="deptId_update_input" class="col-sm-2 control-label">部门</label>
    <div class="col-sm-5">
    	<!-- 部门提交部门id即可 -->  
    	<select name="dId" class="form-control" id="dept_update_select">
		 
		</select>
    </div>
  </div>

</form>
      </div>
      <div class="modal-footer">
        <button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
        <button type="button" class="btn btn-primary" id="empl_update_btn">更新</button>
      </div>
    </div>
  </div>
</div>

<!-- 删除员工信息时的弹框 -->



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
				<button class="btn btn-primary" id = "modal_btn" >新增</button>
				<button class="btn btn-danger" id="emp_delete_all_btn">删除</button>
			</div>
		</div>
		<!-- 表格 -->
		<div class="row">
			<div class="col-md-12">
				<table class="table table-striped table-hover" id="emps_table">
					<thead>
						<tr>
							<td>
								<input type="checkbox" id = "check_all">
							</td>
							<td>ID</td>
							<td>姓名</td>
							<td>所属部门</td>
							<td>操作</td>
						</tr>
					</thead>
					<tbody>
						
					</tbody>
				</table>
			</div>
		</div>
		
		<!-- 显示分页信息 -->
		<div class="row">
			<div id = "page_info_area" class="col-md-6">
				
			</div>
			<div id = "page_nav_area" class="col-md-6">

			</div>
		</div>
	</div>
	
<script type="text/javascript">
	var currentPage;
	//默认去到第一页
	$(function(){
		to_page(1);
	});
	
	//跳转到指定的页码的方法
	function to_page(pn){
		$.ajax({
			url:"${APP_PATH}/getEmpl",
			data:"pn=" + pn,
			type:"GET",
			success:function(result){
				//1.解析并显示员工数据
				build_emps_table(result);
				//2.解析显示分页信息
				build_page_info(result);
				//3.解析显示分页条信息
				build_page_nav(result);
			}
		});
	}
	
	//构建一个员工表格出来
	function build_emps_table(result){
		//清空数据
		$("#emps_table tbody").empty();
		var emps = result.extend.pageInfo.list;
		
		$.each(emps, function(index, item){
			var checkBox = $("<td><input type='checkbox' class='check_item'/></td>");
			var empNid  = $("<td></td>").append(item.nid);
			var empName = $("<td></td>").append(item.name);
			var deptName = $("<td></td>").append(item.dId);
			var editBtn = $("<Button></Button>").addClass("btn btn-primary btn-sm edit_btn")
			.append($("<span></span>")
			.addClass("glyphicon glyphicon-pencil"))
			.append("编辑");
			
			//为编辑按钮添加一个值为nid的属性
			editBtn.attr("edit_nid", item.nid);
			
			
			
			
			var delBtn = $("<Button></Button>").addClass("btn btn-danger btn-sm delete_btn")
			.append($("<span></span>")
			.addClass("glyphicon glyphicon-trash"))
			.append("删除");
			
			//为删除按钮添加一个值为nid的属性
			delBtn.attr("del_nid", item.nid);
			
			var btnTd = $("<td></td>").append(editBtn).append("  ").append(delBtn);
			
			//append方法执行后还是返回原来的元素
			$("<tr></tr>").append(checkBox)
			.append(empNid)
			.append(empName)
			.append(deptName)
			.append(btnTd)
			.appendTo("#emps_table tbody");
			
			currentPage = result.extend.pageInfo.pageNum;
		})
	}
	
	//构建分页信息出来
	function build_page_info(result){
		$("#page_info_area").empty();
		$("#page_info_area").append("当前"+result.extend.pageInfo.pageNum+"页，总"+result.extend.pageInfo.pages+"页，总"+result.extend.pageInfo.total+"条记录")
	}
	
	//构建分页条出来
	function build_page_nav(result){
		$("#page_nav_area").empty();
		
		var ul = $("<ul></ul>").addClass("pagination")
		
		var firstPageLi = $("<li></li>").append($("<a></a>").append("首页").attr("href", "#"));
		var prePageLi = $("<li></li>").append($("<a></a>").append($("<span></span>").append("&laquo;")).attr("href", "#"));
		if(result.extend.pageInfo.hasPreviousPage == false){
			firstPageLi.addClass("disabled");
			prePageLi.addClass("disabled");
		}else{
			firstPageLi.click(function(){
				to_page(1);
			})
			
			prePageLi.click(function(){
				to_page(result.extend.pageInfo.pageNum - 1);
			})
		}
		
		ul.append(firstPageLi).append(prePageLi);
		
		$.each(result.extend.pageInfo.navigatepageNums, function(index, item){
			var numLi = $("<li></li>").append($("<a></a>").append(item).attr("href", "#"));
			if(result.extend.pageInfo.pageNum == item){
				numLi.addClass("active");
			}
			
			numLi.click(function(){
				to_page(item);
			});
			
			ul.append(numLi);
		})
		
		var nextPageLi = $("<li></li>").append($("<a></a>").append($("<span></span>").append("&raquo;")).attr("href", "#"));
		var lastPageLi =  $("<li></li>").append($("<a></a>").append("尾页").attr("href", "#"));
		
		if(result.extend.pageInfo.hasNextPage == false){
			nextPageLi.addClass("disabled");
			lastPageLi.addClass("disabled");
		}else{
			nextPageLi.click(function(){
				to_page(result.extend.pageInfo.pageNum + 1);
			})
			
			lastPageLi.click(function(){
				to_page(result.extend.pageInfo.pages);
			})
		}
		
		ul.append(nextPageLi).append(lastPageLi)
		
		
		$("#page_nav_area").append($("<nav></nav>")).append(ul);
	}
	
		//清除表单样式及内容的方法
		function reset_form(ele){
			$(ele)[0].reset();
			$(ele).find("*").removeClass("has-error has-success");
			$(ele).find(".help-block").text("");
		}
	
		//点击弹出模态对话框
		$("#modal_btn").click(function(){
			//清除表单数据和样式
			reset_form($('#myModal form'));
			
			
			//发送ajax请求，查出部门信息，显示在下拉列表中
			getDepts("#myModal select");
			
			//弹出模态框
			$('#myModal').modal({
				  keyboard: false
			});
		}); 
		
		//获取部门的名称，用于下拉列表选择
		function getDepts(ele){
			$(ele).empty();
			$.ajax({
				url:"${APP_PATH}/depts",
				type:"GET",
				success:function(result){
					console.log(result.extend.depts);
					$.each(result.extend.depts, function(index, item){
						var optionEle = $("<option></option>").append(item.name).attr("value", item.nid);
						$(ele).append(optionEle);
					})
				}
			})
		}
	
	//校验表单数据
	function validate_add_form(){
		//拿到要校验的数据，使用正则表达式
		var empName = $("#emptName_input").val();
		var regName = /(^[A-Za-z0-9]{6,16}$)|(^[\u4e00-\u9fa5]{2,6}$)/;
		
		$("#emptName_input").parent().removeClass("has-error", "has-success");
		$("#emptName_input").next("span").text("");
		
		if(!regName.test(empName)){
			$("#emptName_input").parent().addClass("has-error");
			$("#emptName_input").next("span").text("姓名只能是6-16位英文字母和数字或者2-6位的中文组成");
			return false;
		}else{
			$("#emptName_input").parent().addClass("has-success");
			$("#emptName_input").next("span").text("添加成功");
		};
		
		return true;
		
	}
	
	
	//校验用户名是否可用
	$("#emptName_input").change(function(){
		//发送ajax校验用户名是否重复
		$.ajax({
			url:"${APP_PATH}/checkuser",
			type:"GET",
			data: "empName=" + this.value,
			success:(function(result){
				$("#emptName_input").parent().removeClass("has-error", "has-success");
				$("#emptName_input").next("span").text("");
				if(result.code == 100){
					$("#emptName_input").parent().addClass("has-success");
					$("#emptName_input").next("span").text("名字可用");
					$("#empl_save_btn").attr("ajax-val", "success");
				}else{
					$("#emptName_input").parent().addClass("has-error");
					$("#emptName_input").next("span").text(result.extend.va_msg);
					$("#empl_save_btn").attr("ajax-val", "error");
				}
			})
		})
		
	})
	//添加员工数据
	$("#empl_save_btn").click(function(){
			//校验员工姓名是否可用
			if($(this).attr("ajax-val") == "error"){
				return false;
			}
			//校验数据是否合法
			/* if(!validate_add_form()){
				return false;
			} */
			
			
			$.ajax({
				url:"${APP_PATH}/empl",
				type:"POST",
				data:$("#myModal form").serialize(),
				
				success:function(result){
					if(result.code == 100){
						//员工保存成功后：
						//1.关闭模态框
						$('#myModal').modal('hide');
						//2.来到最后一页，显示刚才的数据(mybatis配置文件中已经限制了页数的合理性)
						to_page(9999);
					}else{
						//显示失败信息
						if(undefined != result.extend.errorFields.name){
							$("#emptName_input").parent().addClass("has-error");
							$("#emptName_input").next("span").text(result.extend.errorFields.name);
						}
					}
				}
			});	
		
	});

	//我们是按钮创建之前就绑定了click，所以是绑定不上的
	/* $(".edit_btn").click(function(){
		alert("点击了");
		$('#myModal_update').modal({
			  keyboard: false
		});
	}) */
	//使用jquery的on方法即可为这类创建出来的元素绑定事件了
	$(document).on("click", ".edit_btn", function(){
		//发送ajax请求，查出部门信息，显示在下拉列表中
		getDepts('#myModal_update select');
		
		//查出员工信息，显示员工信息
		getEmp($(this).attr("edit_nid"));
		
		$("#empl_update_btn").attr("edit_nid", $(this).attr("edit_nid"));
		
		//弹出模态框
		$('#myModal_update').modal({
			  keyboard: false
		});

	})
	
	//根据id获取员工数据
	function getEmp(nid){
		$.ajax({
			url: "${APP_PATH}/empl/" + nid,
			type: "GET",
			success:function(result){
				console.log(result);
				var empData= result.extend.emp;
				$("#empName_update_static").text(empData.name);
				$("#dept_update_select").val([empData.dId]);
				
			}
		})
	}
	
	//点击更新，更新员工信息
	$("#empl_update_btn").click(function updateEmp(nid){
		//发送ajax请求保存更新的员工数据
		$.ajax({
			url:"${APP_PATH}/empl/" + $(this).attr("edit_nid"),
			type:"PUT",
			data: $("#myModal_update form").serialize(),
			success: function(result){
				//alert(result.msg);
				//1.关闭对话框
				$('#myModal_update').modal("hide");
				//2.回到本页面
				to_page(currentPage);
			}
		});
		
	})
	
	//点击删除，删除员工信息
	$(document).on("click", ".delete_btn",function(){
		//弹出是否确认删除对话框
		var empName = $(this).parents("tr").find("td:eq(2)").text();
		var empId = $(this).attr("del_nid");
		if(confirm("确认删除【" + empName + "】吗？")){
			//确认，发送ajax请求删除
			$.ajax({
				url:"${APP_PATH}/empl/" + empId,
				type:"DELETE",
				success:function(result){
					//回到本页
					to_page(currentPage);
				}
				
			})
		}
	})
	
	//全选，全不选功能
	$("#check_all").click(function(){
		//attr获取checked是undfined；
		//可以通过prop修改和读取原生属性的值
		$(".check_item").prop("checked", $(this).prop("checked"));
	});
	
	$(document).on("click", ".check_item",function(){
		//判断当前选中的元素的个数是否为5
		var flag = $(".check_item:checked").length == $(".check_item").length;
		$("#check_all").prop("checked", flag);
		
	})
	
	//点击删除，全部删除
	$("#emp_delete_all_btn").click(function(){
		var empNames = "";
		var del_nidstr = "";
		$.each($(".check_item:checked"), function(){
			empNames += $(this).parents("tr").find("td:eq(2)").text() + ",";
			del_nidstr += $(this).parents("tr").find("td:eq(1)").text() + "-";
		});
		//去除empNames多余的逗号
		empNames = empNames.substring(0, empNames.length - 1);
		//去除del_nidstr多余的"-"
		del_nidstr = del_nidstr.substring(0, del_nidstr.length - 1);
		if(confirm("确认删除【" + empNames + "】")){
			//发送ajax请求删除
			 $.ajax({
				 url:"${APP_PATH}/empl/" + del_nidstr,
				 type:"DELETE",
				 success:function(result){
					 to_page(currentPage);
					 $("#check_all").prop("checked", false);
				 }
			 })
		}
	})
</script>
</body>
</html>