<%@ page language="java" contentType="text/html; charset=UTF-8"
	import="java.util.Date" pageEncoding="UTF-8"%>
<%@ taglib prefix="pageTag" uri="/WEB-INF/taglib/pageTag.tld"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title></title>
<jsp:include page="../common/common.jsp" />
<script type="text/javascript">
$(function(){
	var $tab_li = $('#tab ul li');
	$tab_li.click(function(){
		$(this).addClass('active').siblings().removeClass('active');
		var index = $tab_li.index(this);
		$('div.tab_box > .box').eq(index).show().siblings().hide();
	});	
	$("#txt span").click(function(){
		var boxClass=$(this).attr("class");
		if(boxClass=="check"){
			$(this).attr("class","checked");
			}else{
			$(this).attr("class","check");}
		});		

});
</script>
</head>

<body>
	<div class="container queryConditions section_lay_one">
		<!--shadow开始-->
		<div class="shadow"></div>
		<!--shadow结束-->
		<!--main开始-->
		<div class="main">
			<form id="addPageForm" name="addPageForm">
				<input type="hidden" name="sectionId" value="${sectionId}">
				<input type="hidden" name="datatypeId" value="${typeId}">
				<div class="search">
					<div class="row">
						<div class="col-md-2">Id</div>
						<div class="col-md-4"></div>
						<div class="col-md-2">Parent</div>
						<div class="col-md-4"></div>
					</div>
					<div class="row">
						<div class="col-md-2">Name</div>
						<div class="col-md-4">
							<input type="text" name="pageName" required="required" />
						</div>
						<div class="col-md-2">Physical Name</div>
						<div class="col-md-4">
							<input type="text" name="physicalName" value="@Name" />
						</div>
					</div>
					<div class="row">	
						<div class="col-md-2">Template</div>
						<div class="col-md-4">
							<select name="templateId">
								<c:forEach items="${templateList}" var="template">
									<option value="${template.templateId}">${template.templateName}</option>
								</c:forEach>
							</select>
						</div>
					</div>
				</div>
				</form>
				
				<div class="search pagefieldvalues">
		       		<pageTag:page-edit datatypeId="${typeId}"/>
		        </div>
				<form id="SeoPageForm">
				<table class="big" border="0" cellspacing="0" cellpadding="0">
					<tr class="head">
						<th class="head_l">SEO</th>
					</tr>
					<tr class="inside_border">
						<td colspan="2">
							<div class="row">
								<div class="col-md-2">Title</div>
								<div class="col-md-4">
									<input type="text" name="seoTitle" />
								</div>
								<div class="col-md-2 tn_c">H1 Tag</div>
								<div class="col-md-4">
									<input type="text" name="seoH1tag" />
								</div>
							</div>
							<div class="row">
								<div class="col-md-2">Keywords</div>
								<div class="col-md-10 long">
									<input type="text" name="seoKeywords" />
								</div>
							</div>
							<div class="row larger">
								<div class="col-md-2">Description</div>
								<div class="col-md-10">
									<textarea name="seoDescription">
                             </textarea>
								</div>
							</div>
						</td>
					</tr>
				</table>
				<div class="text">
					<div class="row">
						<div class="col-md-2">Creator</div>
						<div class="col-md-4">${userName}</div>
						<div class="col-md-3">Creation Date</div>
						<div class="col-md-3">
							<fmt:formatDate value="<%=new Date()%>"
								pattern="yyyy-MM-dd HH:mm" />
						</div>
					</div>
					<div class="row">
						<div class="col-md-2">Modifier</div>
						<div class="col-md-4">#</div>
						<div class="col-md-3">Modification Date</div>
						<div class="col-md-3">#</div>
					</div>
				</div>
				<div class="btns">
					<a href="#" class="confirm" onclick="addPage();">Save</a> <a
						href="#" class="cancel">Cancel</a>
					<div id="errorMessage" style="display: none"></div>
				</div>
			</form>
		</div>
		<!--main结束-->
		<script type="text/javascript">
        //关闭frame
        $(function(){

				var index = parent.layer.getFrameIndex(window.name); //获取当前窗体索引
				$('.cancel').on('click', function() {
					parent.layer.close(index); //执行关闭
				});
		});

        	function openDataType(id,elementId,elementName){
        		$.layer({
    		        type: 2,
    		        title: 'Please Select a DataType',
    		        maxmin: false,
    		        shadeClose: true, //开启点击遮罩关闭层
    		        area : ['780px' , '650px'],
    				shadeClose: false,
    				move: false,
    				offset : [($(window).height() - 600)/2+'px', ''],
    		        iframe: {src: '<%=request.getContextPath()%>/section/unlimited/dataTypePicker.action?dataTypeId='+id+'&elementId='+elementId+'&elementName='+elementName}
    		    
				});
        	}

			function addPage() {
				$("#errorMessage").html("");
				
				var sel = "";
				$('.pagefieldvalues').each(function(){
					$(this).find('input[type=hidden]').each(function(){
						var thisvalue = encodeURIComponent($(this).val());
						sel += $(this).attr('name') +"="+thisvalue + "&";
					});
				});
				sel=sel.substring(0,sel.length-1);
				
				if ($("#addPageForm").valid()) {
					$.post("createPageSave.action", $("#addPageForm").serialize()+"&"+$("#SeoPageForm").serialize()+"&selStr="+encodeURIComponent(sel),
							function(data) {
								var result = eval(data);
								alert(result.msg);
								var index = parent.layer
										.getFrameIndex(window.name);
								parent.location.reload();
								parent.layer.close(index);
							}, "json");
				} else {
					alert($("#errorMessage").html());
				}
			}
		</script>
	</div>
</body>
</html>
