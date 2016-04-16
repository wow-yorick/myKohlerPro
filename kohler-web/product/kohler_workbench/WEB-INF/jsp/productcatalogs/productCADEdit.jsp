<%@ page language="java" contentType="text/html; charset=utf-8"
	pageEncoding="utf-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>New ProductCAD</title>
<jsp:include page="../common/common.jsp" />
<script type="text/javascript">
	
	$(function() {
		var index = parent.layer.getFrameIndex(window.name); //获取当前窗体索引
		$('#closebtn').on('click', function() {
			parent.layer.close(index); //执行关闭
		});
		$('input[name=fileId]').parents('.row').hide();
		$('input[name=fileUrl]').parents('.row').hide();
		<c:forEach items="${productCADlist}" var="cad">
			
			$.post("<%=request.getContextPath()%>/content/unlimited/getMasterDateByName.action","masterdataTypeName=TYPE_FILE_SOURCE&lang=${cad.lang}",function(data){
				var opt = '<option value=""></option>';
				$.each(data.result,function(name,value){
					if(value.masterdataMetadataId == '${cad.fileSource}'){
						opt += '<option selected="selected" value="'+value.masterdataMetadataId+'">'+value.masterdataName+'</option>';
					}else{
						opt += '<option value="'+value.masterdataMetadataId+'">'+value.masterdataName+'</option>';
					}
				});
				var fileSourceVal = '${cad.fileSource}';
				if(fileSourceVal=='10030001'){
					$('input[name=lang][value="${cad.lang}"]').parents('.box').find('input[name=fileId]').parents('.row').show();
					$('input[name=lang][value="${cad.lang}"]').parents('.box').find('input[name=fileUrl]').parents('.row').hide();
				}
				if(fileSourceVal=='10030002'){
					$('input[name=lang][value="${cad.lang}"]').parents('.box').find('input[name=fileId]').parents('.row').hide();
					$('input[name=lang][value="${cad.lang}"]').parents('.box').find('input[name=fileUrl]').parents('.row').show();
				}
				$('input[name=lang][value="${cad.lang}"]').parents('.box').find('select[name=fileSource]').html(opt);
			});
		</c:forEach>
		
		$('select[name=fileSource]').on('change', function(){
			if($(this).val()=='10030001'){
				$(this).parents('.box').find('input[name=fileId]').parents('.row').show();
				$(this).parents('.box').find('input[name=fileUrl]').parents('.row').hide();
			}else if($(this).val()=='10030002'){
				$(this).parents('.box').find('input[name=fileId]').parents('.row').hide();
				$(this).parents('.box').find('input[name=fileUrl]').parents('.row').show();
			}else{
				$(this).parents('.box').find('input[name=fileId]').parents('.row').hide();
				$(this).parents('.box').find('input[name=fileUrl]').parents('.row').hide();
			}
		});
	});
	
	function openDataType(masterdataId,elementId,elementName){
	    $.layer({
	        type: 2,
	        title: 'PDF Select',
	        maxmin: false,
	        shadeClose: true, //开启点击遮罩关闭层
	        area : ['680px' , '480px'],
			shadeClose: false,
	        offset : ['10px', ''],
	        iframe: {src: '<%=request.getContextPath()%>/image/unlimited/imagepicker.action?isMulti=1&fileType='+masterdataId+'&elementId='+elementId+'&elementName='+elementName}
	    
		});
	}
	
	
	function formToJson(form) {
		var o = {};
		var a = $(form).serializeArray();
		$.each(a, function() {
			if (o[this.name]) {
				if (!o[this.name].push) {
					o[this.name] = [ o[this.name] ];
				}
				o[this.name].push(this.value || '');
			} else {
				o[this.name] = this.value || '';
			}
		});
		return o;
	};
	function editProductCAD() {
		var forms = $(".tab_box form");
		var len = forms.length;
		var productCADs = '[';
		$.each(forms, function(i, form) {
			if (i == len - 1) {
				productCADs += JSON.stringify(formToJson(form));
			} else {
				productCADs += JSON.stringify(formToJson(form));
				productCADs += ",";
			}
		});
		productCADs += "]";
		$.post("updateProductCAD.action", $("#editProductCADForm").serialize()
				+ "&productCADs=" + productCADs, function(data) {
			var result = eval(data);
			alert(result.msg);
			$.get('<%=request.getContextPath()%>/productCAD/unlimited/productCADList.action?productMetadataId=${productMetadataId}',function(data){
				var index = parent.layer.getFrameIndex(window.name);
				parent.$("#productCADList").html(data);
				parent.layer.close(index);
			});
		}, "json");
	}
</script>
</head>
<body>
	<div class="container queryConditions product_layer">
		<!--shadow开始-->
		<div class="shadow"></div>
		<!--shadow结束-->
		<!--main开始-->
		<div class="main">
			<div class="search">
				<form id="editProductCADForm">
					<input type="hidden" name="productMetadataId" value="${productMetadataId}" /> 
					<input type="hidden" name="productCADMetadataId" value="${productCADMetadataEntity.productCADMetadataId}" />
					<div class="row">
						<div class="col-md-2">Id</div>
						<div class="col-md-4">${productCADMetadataEntity.productCADMetadataId}</div>
						<div class="col-md-2 tn_c">Type</div>
						<div class="col-md-4">
							<select name="cadType">
								<option></option>
								<option value="0"
									<c:if test="${productCADMetadataEntity.cadType eq 0}">selected</c:if>>2D
									CAD文件</option>
								<option value="1"
									<c:if test="${productCADMetadataEntity.cadType eq 1}">selected</c:if>>3D
									CAD文件</option>
							</select>
						</div>
					</div>
					<div class="row">
						<div class="col-md-2">Suffix</div>
						<div class="col-md-4">
							<input type="text" name="suffix"
								value="${productCADMetadataEntity.suffix}" />
						</div>
					</div>
				</form>
			</div>
			<div class="tab" id="tab">
				<ul class="tab_menu">
					<c:forEach items="${languages}" var="language" varStatus="status">
						<c:choose>
							<c:when test="${status.index == 0 }">
								<li class="active tn_c">${language.localeName }</li>
							</c:when>
							<c:otherwise>
								<li class="tn_c">${language.localeName }</li>
							</c:otherwise>
						</c:choose>
					</c:forEach>
				</ul>
				<div class="tab_box">
					<c:forEach items="${languages}" var="language" varStatus="status">
						<c:choose>
							<c:when test="${status.index == 0 }">
								<div class="box">
									<form id="lan">
										<input type="hidden" name="lang" value="${language.localeId }" />
										<c:forEach items="${productCADlist}" var="cad">
											<c:if test="${cad.lang eq language.localeId}">
												<input type="hidden" name="productCADId"
													value="${cad.productCADId}" />
												<div class="row">
													<div class="col-md-3 tn_l">CAD
														Name_${language.localeCode}</div>
													<div class="col-md-9">
														<input type="text" name="productCADName" value="${cad.productCADName}" />
													</div>
												</div>
												<div class="row">
													<div class="col-md-3 tn_l">File Source</div>
													<div class="col-md-9">
														<select name="fileSource">
															<option></option>
															<option value="0"
																<c:if test="${cad.fileSource eq 0}">selected</c:if>>Internal</option>
															<option value="1"
																<c:if test="${cad.fileSource eq 1}">selected</c:if>>External</option>
														</select>
													</div>
												</div>
												<div class="row">
													<div class="col-md-3 tn_l">File URL</div>
													<div class="col-md-9">
														<input type="text" name="fileUrl" value="${cad.fileUrl}" />
													</div>
												</div>
												<div class="row">
													<div class="col-md-3 tn_l">File Id</div>
													<div class="col-md-7">
														<input type="hidden" name="fileId" id="hiddenfileId${language.localeId }" value="${cad.fileId }"/> 
														<c:forEach items="${fileNameMap}" var="fnm" >
															<c:if test="${fnm.key eq language.localeId}">
																<input type="text" id="showfileName${language.localeId }" value="${fnm.value }"/>
															</c:if>
														</c:forEach>
													</div>
													<div class='col-md-2 '>
														<a href='#'  class='choose tn_c' onclick='openDataType("10090003","hiddenfileId${language.localeId }","showfileName${language.localeId }")'>Choose</a>
													</div>
												</div>
												<div class="row large">
													<div class="col-md-3 tn_l">
														Description_${language.localeCode}</div>
													<div class="col-md-9">
														<textarea rows="2" name="description">${cad.description}</textarea>
													</div>
												</div>
											</c:if>
										</c:forEach>
									</form>
								</div>
							</c:when>
							<c:otherwise>
								<div class="hide box">
									<form id="lan">
										<input type="hidden" name="lang" value="${language.localeId }" />
										<c:forEach items="${productCADlist}" var="cad">
											<c:if test="${cad.lang eq language.localeId}">
												<input type="hidden" name="productCADId"
													value="${cad.productCADId}" />
												<div class="row">
													<div class="col-md-3 tn_l">CAD
														Name_${language.localeCode}</div>
													<div class="col-md-9">
														<input type="text" name="productCADName" value="${cad.productCADName}" />
													</div>
												</div>
												<div class="row">
													<div class="col-md-3 tn_l">File Source</div>
													<div class="col-md-9">
														<select name="fileSource">
															<option></option>
															<option value="0"
																<c:if test="${cad.fileSource eq 0}">selected</c:if>>Internal</option>
															<option value="1"
																<c:if test="${cad.fileSource eq 1}">selected</c:if>>External</option>
														</select>
													</div>
												</div>
												<div class="row">
													<div class="col-md-3 tn_l">File URL</div>
													<div class="col-md-9">
														<input type="text" name="fileUrl" value="${cad.fileUrl}" />
													</div>
												</div>
												<div class="row">
													<div class="col-md-3 tn_l">File Id</div>
													<div class="col-md-7">
														<input type="hidden" name="fileId" id="hiddenfileId${language.localeId }" value="${cad.fileId }"/> 
														<c:forEach items="${fileNameMap}" var="fnm" >
															<c:if test="${fnm.key eq language.localeId}">
																<input type="text" id="showfileName${language.localeId }" value="${fnm.value }"/>
															</c:if>
														</c:forEach>
													</div>
													<div class='col-md-2 '>
														<a href='#'  class='choose tn_c' onclick='openDataType("10090003","hiddenfileId${language.localeId }","showfileName${language.localeId }")'>Choose</a>
													</div>
												</div>
												<div class="row large">
													<div class="col-md-3 tn_l">
														Description_${language.localeCode}</div>
													<div class="col-md-9">
														<textarea rows="2" name="description">${cad.description}</textarea>
													</div>
												</div>
											</c:if>
										</c:forEach>
									</form>
								</div>
							</c:otherwise>
						</c:choose>
					</c:forEach>
				</div>
			</div>
			<div class="text">
				<div class="row">
					<div class="col-md-2">Creator</div>
					<div class="col-md-3">${productCADMetadataEntity.createUser}</div>
					<div class="col-md-3">
						Creation Date
					</div>
					<div class="col-md-4">
						<fmt:formatDate value="${productCADMetadataEntity.createTime}"
							pattern="yyyy-MM-dd HH:mm:ss" />
					</div>
				</div>
				<div class="row">
					<div class="col-md-2">Modifier</div>
					<div class="col-md-3">${productCADMetadataEntity.modifyUser}</div>
					<div class="col-md-3">
						Modification Date
					</div>
					<div class="col-md-4">
						<fmt:formatDate value="${productCADMetadataEntity.modifyTime}"
							pattern="yyyy-MM-dd HH:mm:ss" />
					</div>
				</div>
			</div>
			<div class="btns">
				<a href="javascript:void(0);" class="confirm" onclick="editProductCAD()">确定</a> 
				<a href="#" class="cancel" id="closebtn">取消</a>
			</div>
		</div>
		<!--main结束-->
	</div>
</body>
</html>