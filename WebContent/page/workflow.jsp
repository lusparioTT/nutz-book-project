<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="shiro"  uri="http://shiro.apache.org/tags"%>
<c:set var="ctx" value="${pageContext.request.contextPath}"/>

<!-- 用bootstrap先应付一下 -->
<!-- Latest compiled and minified CSS -->
<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.4/css/bootstrap.min.css">
<!-- Optional theme -->
<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.4/css/bootstrap-theme.min.css">
<!-- Latest compiled and minified JavaScript -->
<script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.4/js/bootstrap.min.js"></script>

<!-- 弹出层layer -->
<script src="${ctx}/rs/layer/layer.min.js" type="text/javascript"></script>

<div class="alert">
    <button type="button" class="close" data-dismiss="alert">&times;</button>
    <strong>提醒:</strong> 关联动态表单后流程才能启动流程!!
</div>
<h2>流程管理</h2>
	<h4 id="wf_count"></h4>
	<div class="panel panel-default">
		<form action="#" id="wf_query_form">
			过滤<input type="text" name="name" class="form-contrl" onchange="wf_reload();">
			页数<input type="number" name="pageNumber" class="form-contrl" value="1" onchange="wf_reload();">
			每页<input type="number" name="pageSize" class="form-contrl" value="10" onchange="wf_reload();">
		</form>
	</div>
<div class="panel panel-default">
	<div class="panel-heading">流程一览</div>
	<table class="table">
		<thead>
			<tr>
				<th>#</th>
				<th>定义名词</th>
				<th>显示名称</th>
				<th>版本号</th>
				<th>关联表单</th>
				<th>最后修改者</th>
				<td>最后修改时间</td>
				<th>状态</th>
				<th>操作</th>
			</tr>
		</thead>
		<tbody id="wf_tbody">
		</tbody>
	</table>
</div>
	<div class="panel panel-default" id="wf_update_div">
		<form action="#" id="wf_update_form">
			<input hidden="true" name="processId" id="wf_update_processId">
			请选择需要关联的表单<select id="wf_form_select" name="formId">
			
			</select>
		</form>
		<button type="button" onclick="wf_update_submit();">提交</button>
		<button type="button" onclick="$('#wf_update_div').hide();">取消</button>
	</div>
<script type="text/javascript">
function wf_reload(){
	$.ajax({
		url : home_base + "/admin/process/list",
		data : $("#wf_query_form").serialize(),
		dataType : "json",
		success : function(re) {
			if (re && re.ok) {
				var data = re.data;
				//console.log(data);
				$("#wf_count").html("共" + data.pager.recordCount + "个流程定义, 总计" + data.pager.pageCount + "页");
				var list_html = "";
				//console.log(data.list);
				for (var i = 0; i < data.ps.length; i++) {
					var wf = data.ps[i];
					//console.log(wf);
					var tmp = "<tr>";
					tmp += "<td>" + wf.id + "</td>";
					tmp += "<td>" + wf.name + "</td>";
					tmp += "<td>" + wf.displayName + "</td>";
					tmp += "<td>" + wf.version + "</td>";
					// 关联的动态表单
					if (data.es[i] && data.es[i].form && data.es[i].form.name) {
						tmp += "<td>" + data.es[i].form.name + "</td>";
					} else {
						tmp += "<td>" + "无" + "</td>";
					}
					// 用户信息
					if (data.es[i] && data.es[i].user && data.es[i].user.name) {
						tmp += "<td>" + data.es[i].user.name + "</td>";
					} else {
						tmp += "<td>" + "未知" + "</td>";
					}
					tmp += "<td>" + wf.createTime + "</td>";
					if (wf.state == 0) {
						tmp += "<td style=\"color: red;\">" + "已删除" + "</td>";
					} else {
						tmp += "<td>" + "有效" + "</td>";
					}
					
					tmp += "<td>";
					tmp	+= " <button onclick='wf_preview(\"" + wf.id + "\");' class='btn btn-default'>预览</button> ";
					if (wf.state == 0) {
						tmp	+= " <button onclick='wf_resume(\"" + wf.id + "\");' class='btn btn-default'>恢复</button> ";
					} else {
						if (data.es[i] && data.es[i].form && data.es[i].form.name) {
							tmp	+= " <button onclick='wf_start(\"" + wf.id + "\");' class='btn btn-default'>启动</button> ";
						} else {
							tmp += " <button onclick='wf_start(\"" + wf.id + "\");' class='btn btn-default' disabled='disabled'>启动</button> ";
						}
						
						tmp	+= " <button onclick='wf_update(\"" + wf.id + "\");' class='btn btn-default'>修改定义</button> ";
						tmp	+= " <button onclick='wf_update_other(\"" + wf.id + "\");' class='btn btn-default'>修改其他属性</button> ";
						tmp	+= " <button onclick='wf_delete(\"" + wf.id + "\");' class='btn btn-default'>删除</button> ";
					}
					tmp += "</td>";
					tmp += "</tr>";
					list_html += tmp;
				}
				$("#wf_tbody").html(list_html);
			}
		}
	});
};
function wf_delete(wf_id) {
	var s = prompt("请输入y确认删除");
	if (s == "y") {
		$.ajax({
			url : home_base + "/admin/process/delete",
			data : {id:wf_id},
			success : wf_reload
		});
	}
};
function wf_resume(wf_id) {
	alert("尚未实现");
	return;
	var s = prompt("请输入y确认删除");
	if (s == "y") {
		$.ajax({
			url : home_base + "/admin/process/resume",
			data : {id:wf_id},
			success : wf_reload
		});
	}
};
function wf_update(wf_id) {
	window.location.href = home_base + "/admin/process/design/" + wf_id;
};
function wf_update_other(wf_id) {
	$.ajax({
		url : home_base + "/admin/form/list",
		data : {pageNumber:-1},
		dataType : "json",
		success : function(re) {
			if (re && re.ok) {
				var data = re.data.list;
				var tmp = "";
				for (var int = 0; int < data.length; int++) {
					var form = data[int];
					tmp += "<option value=\"" + form.id + "\">" + form.name +"</option>\n";
				}
				$("#wf_form_select").html(tmp);
				$("#wf_update_processId").attr("value", wf_id);
				$("#wf_update_div").show();
			} else {
				alert(re.msg);
			}
		}
	});
};
function wf_update_submit() {
	$.ajax({
		url : home_base + "/admin/process/ext/update",
		data : $("#wf_update_form").serialize(),
		success : function(){
			$("#wf_update_div").hide();
			wf_reload();
		}
	});
};
function wf_preview(form_id) {
	$.ajax({
		url : home_base + "/admin/process/svg/" + form_id,
		dataType : "xml",
		success : function(re) {
			//alert("...");
			layer.alert('怎样显示SVG啊');
		}
	});
};

function myInit(args) {
	$("#wf_update_div").hide();
	wf_reload();
};
</script>