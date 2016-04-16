<%@ page language="java" contentType="text/html; charset=utf-8"
	pageEncoding="utf-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>New ProductPart</title>
<jsp:include page="../common/common.jsp" />
<script  type="text/javascript">
	
	$(function() {
		var index = parent.layer.getFrameIndex(window.name); //获取当前窗体索引
		$('#closebtn').on('click', function(){
	    	parent.layer.close(index); //执行关闭
		});
		$('input[name=imageId]').parents('.row').hide();
		$('input[name=imageUrl]').parents('.row').hide();
		
		$.each($('select[name=imageSource]'),function(){
			var l = $(this).parents('.box').find('input[name=lang]').val();
			$.post("<%=request.getContextPath()%>/content/unlimited/getMasterDateByName.action","masterdataTypeName=TYPE_FILE_SOURCE&lang="+l,function(data){
				var opt = '<option value=""></option>';
				$.each(data.result,function(name,value){
					opt += '<option value="'+value.masterdataMetadataId+'">'+value.masterdataName+'</option>';
				});
				$('input[name=lang][value="'+l+'"]').parents('.box').find('select[name=imageSource]').html(opt);
			});
		});
		$('select[name=imageSource]').on('change', function(){
			if($(this).val()=='10030001'){
				$(this).parents('.box').find('input[name=imageId]').parents('.row').show();
				$(this).parents('.box').find('input[name=imageUrl]').parents('.row').hide();
			}else if($(this).val()=='10030002'){
				$(this).parents('.box').find('input[name=imageId]').parents('.row').hide();
				$(this).parents('.box').find('input[name=imageUrl]').parents('.row').show();
			}else{
				$(this).parents('.box').find('input[name=imageId]').parents('.row').hide();
				$(this).parents('.box').find('input[name=imageUrl]').parents('.row').hide();
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
	function addProductPart() {
		var forms = $(".tab_box form");
		var len = forms.length;
		var productParts = '[';
		$.each(forms, function(i, form) {
			if (i == len - 1) {
				productParts += JSON.stringify(formToJson(form));
			} else {
				productParts += JSON.stringify(formToJson(form));
				productParts += ",";
			}
		});
		productParts += "]";
		$.post("saveProductPart.action", $("#addProductPartForm").serialize() + "&productParts=" + productParts , 
			function(data) {
				var result = eval(data);
				alert(result.msg);
				//var index = parent.layer.getFrameIndex(window.name);
				//parent.location.reload();
				//parent.layer.close(index);
				$.get('<%=request.getContextPath()%>/productPart/unlimited/productPartList.action?productMetadataId=${productMetadataId}',function(data){
					var index = parent.layer.getFrameIndex(window.name);
					parent.$("#productPartList").html(data);
					parent.layer.close(index);
				});
			}, "json");
	}
</script>
</head>

<body>
<div class="container queryConditions product_layer partsImages">
    <!--shadow开始-->
    <div class="shadow">
    </div>
    <!--shadow结束-->
    <!--main开始-->
    <div class="main">
    	<div class="search">
    		<form id="addProductPartForm">
    			<input type="hidden" name="productMetadataId" value="${productMetadataId}"/>
    			<%-- <input type="hidden" name="productPartMetadataId" value="${productPartMetadataEntity.productPartMetadataId}"/> --%>
    			<div class="row">
            		<div class="col-md-2">Id</div>
            		<div class="col-md-4">&nbsp;</div> 
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
                 					<div class="row">
                       					<div class="col-md-3 tn_l">Part Name_${language.localeCode}</div>
                      	 				<div class="col-md-9">
                           					<input type="text" name="productPartName"/>
                       					</div> 
                    				</div>
                    				<div class="row">
                        				<div class="col-md-3 tn_l">PDF Source</div>
                        				<div class="col-md-9"> 
                       						<select name="imageSource">
											</select>
                       					</div> 
                   					</div>
                   					<div class="row">
                       					<div class="col-md-3 tn_l">Part PDF URL</div>
                       					<div class="col-md-9">
                           					<input type="text" name="imageUrl"/>
                       					</div> 
                   					</div> 
                   					<div class="row">
										<div class="col-md-3 tn_l">PDF</div>
										<div class="col-md-7">
											<input type="hidden" name="imageId" id="hiddenfileId${language.localeId }"/> 
											<input type="text" id="showfileName${language.localeId }" />
										</div>
										<div class='col-md-2 '>
											<a href='#'  class='choose tn_c' onclick='openDataType("10090001","hiddenfileId${language.localeId }","showfileName${language.localeId }")'>Choose</a>
										</div>
									</div> 
                   				</form>               
               				</div>
               			</c:when>
               			<c:otherwise>
                			<div class="hide box">
                				<form id="lan">
									<input type="hidden" name="lang" value="${language.localeId }" />
                						<div class="row">
                        				<div class="col-md-3 tn_l">Part Name_${language.localeCode}</div>
                       	 				<div class="col-md-9">
                            				<input type="text" name="productPartName"/>
                        				</div> 
                    				</div>
                   					<div class="row">
                       					<div class="col-md-3 tn_l">PDF Source</div>
                       					<div class="col-md-9"> 
                       						<select name="imageSource">
											</select>
                       					</div> 
                    				</div>
                    				<div class="row">
                        				<div class="col-md-3 tn_l">Part PDF URL</div>
                        				<div class="col-md-9">
                           					<input type="text" name="imageUrl"/>
                       					</div> 
                   					</div> 
                   					<div class="row">
										<div class="col-md-3 tn_l">PDF</div>
										<div class="col-md-7">
											<input type="hidden" name="imageId" id="hiddenfileId${language.localeId }"/> 
											<input type="text" id="showfileName${language.localeId }" />
										</div>
										<div class='col-md-2 '>
											<a href='#'  class='choose tn_c' onclick='openDataType("10090001","hiddenfileId${language.localeId }","showfileName${language.localeId }")'>Choose</a>
										</div>
									</div>
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
				<div class="col-md-3"></div>
				<div class="col-md-7">
					Creation Date
				</div>
			</div>
			<div class="row">
				<div class="col-md-2">Modifier</div>
				<div class="col-md-3"></div>
				<div class="col-md-7">
					Modification Date
				</div>
			</div>
		</div>
        <div class="btns">
        	<a href="javascript:void(0);" class="confirm" onclick="addProductPart()">确定</a>
        	<a href="#" class="cancel" id="closebtn">取消</a>
        </div>
    </div>
</div>
</body>
</html>