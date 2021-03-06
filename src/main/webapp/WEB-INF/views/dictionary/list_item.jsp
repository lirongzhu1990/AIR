<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="tags" tagdir="/WEB-INF/tags" %>
<%@taglib prefix="shiro" uri="http://shiro.apache.org/tags" %>  

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta charset="utf-8" />
<meta name="viewport" content="width=device-width, initial-scale=1.0" />
<title></title>
<jsp:include page="/WEB-INF/views/commons/head.jsp"></jsp:include>

<script type="text/javascript">
	$(document).ready(function () {
	    
	    $("#queryButton").click(function(){
	    	$("#queryForm").submit();
	    })
	    
	    var timer = null; 
	    $("#listTable tbody tr").dblclick(function(){
	    	timer && clearTimeout(timer); 
	    	window.location.href = "./create.do?id=" + $(this).data("id");
	    })
	    
	});

	function enable(enableId){
		
		idgConfirmObj.confirm("确认禁用？", function(){ 
			
			 $.ajax({
			      url: "enableItem.do",
			      type: "GET",
			      data: {
			    	  enableItemId : enableId
			      },
			      success:function (data) {
			      	
			      	if(data == 1){
			      		idgMessageObj.iMSuccessAlert("操作成功", 2000, function(){ $("#queryForm").submit();});
			      	}else if(data.indexOf("gotoLogin") > -1){
			      		idgMessageObj.iMWarnAlert("用户连接超时，请重新登陆！", 2000);
			        }else{
			        	idgMessageObj.iMWarnAlert("操作失败", 2000);
			      	}
			      },
			      error:function(data){
			    	  idgMessageObj.iMWarnAlert("网络异常", 2000);
			      }
			  })
		})
	}
	
	function reset(resetId){
		
		 $.ajax({
		      url: "resetItem.do",
		      type: "GET",
		      data: {
		    	  resetItemId : resetId
		      },
		      success:function (data) {
		      	
		      	if(data == 1){
		      		idgMessageObj.iMSuccessAlert("操作成功", 2000, function(){ $("#queryForm").submit();});
		      	}else if(data.indexOf("gotoLogin") > -1){
		      		idgMessageObj.iMWarnAlert("用户连接超时，请重新登陆！", 2000);
		        }else{
		        	idgMessageObj.iMWarnAlert("操作失败", 2000);
		      	}
		      },
		      error:function(data){
		    	  idgMessageObj.iMWarnAlert("网络异常", 2000);
		      }
		  })
		}
	
</script>
</head>
<body style="background-color: #f3f3f3; overflow-x: hidden; padding-right: 15px;">
<tags:idgMessage warnMessage="${warnMessage}" successMessage="${successMessage}" 
	infoMessage="${infoMessage}" dangerMessage="${dangerMessage}" />
	<form action="./listItem.do?dictionaryId=${dictionary.dictionaryId}" method="post" name="queryForm" id="queryForm">
	<div class="row">
		<div class="col-md-12">
			<h1 class="page-header">
				字典管理 <small>列表</small>
			</h1>
		</div>
	</div>
	<div class="row">
		<div class="col-md-12">
			<!-- Advanced Tables -->
			<div class="panel panel-default">
				<div class="panel-heading">
					<a href="./createItem.do?id=${dictionary.dictionaryId}" class="btn btn-primary">新增子项</a>
					<a href="./list.do" class="btn btn-primary">返回</a>
				</div>
				<div class="panel-body">
					<div class="table-responsive" style="overflow-x: hidden;">
						<div class="row">
							<div class="col-sm-7">
							</div>
							<div class="col-sm-4">
								<input type="input" class="form-control" name="serach_content" placeholder="中文简称/中文全称/英文简称/英文全称" value="${param.serach_content}">
							</div>
							<div class="col-sm-1">
								<button class="btn btn-primary" id="queryButton" name="queryButton">查询</button>
							</div>
						</div>
						<br>
						<table class="table table-striped table-bordered table-hover" id="listTable">
							<thead>
								<tr>
									<th>中文简称</th>
									<th>中文全称</th>
									<th>英文简称</th>
									<th>英文全称</th>
									<th>关键值</th>
									<th>显示顺序</th>
									<th>是否启用</th>
									<th>操作</th>
								</tr>
							</thead>
							<tbody>
								<c:if test="${fn:length(pagedList.content) le 0}">
									<tr>
										<td colspan="11" style="text-align: center;">暂无资料</td>
									</tr>
								</c:if>
								<c:forEach items="${pagedList.content}" var="dictionaryItem" varStatus="status" >
									<tr data-id="${dictionaryItem.itemId}" class="
										<c:if test="${status.index % 2 eq 1}">odd gradeX</c:if>
										<c:if test="${status.index % 2 eq 0}">even gradeX</c:if>
									">
										<td>${dictionaryItem.shortName}</td>
										<td>${dictionaryItem.fullName}</td>
										<td>${dictionaryItem.engShortName}</td>
										<td>${dictionaryItem.engName}</td>
										<td>${dictionaryItem.itemKey}</td>
										<td>${dictionaryItem.itemSort}</td>
										<td>${dictionaryItem.enable}<td>
											<c:if test="${dictionaryItem.enable == '正常'}">
												<a href="./createItem.do?id=${dictionary.dictionaryId}&itemId=${dictionaryItem.itemId}">修改</a>
												<a href="javascript:enable(${dictionaryItem.itemId});">禁用</a>
											</c:if>
											<c:if test="${dictionaryItem.enable == '停用'}">
												<a href="javascript:reset(${dictionaryItem.itemId});">启用</a>
											</c:if>
										</td>
									</tr>
								</c:forEach>
							</tbody>
						</table>
						<tags:idgPage pagedList="${pagedList}"/>
					</div>
				</div>
			</div>
			<!--End Advanced Tables -->
		</div>
	</div>
	</form>
	<footer>
		<p>
		</p>
	</footer>
</body>
</html>

