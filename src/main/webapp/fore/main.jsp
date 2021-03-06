<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="utf-8"%>
<%
	String basePath=request.getScheme()+"://"+request.getServerName()+":"
		+request.getServerPort()+request.getContextPath()+"/";
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<script type="text/javascript" src="<%=basePath %>resource/js/jquery-3.3.1.js"></script>
<script type="text/javascript" src="<%=basePath %>resource/js/Cesium.js"></script>
<link rel="stylesheet" href="<%=basePath %>resource/css/widgets.css">
<!-- 
<script src="https://cesiumjs.org/releases/1.56.1/Build/Cesium/Cesium.js"></script>  
<link href="https://cesiumjs.org/releases/1.56.1/Build/Cesium/Widgets/widgets.css" rel="stylesheet">
 -->
<script>
var path='<%=basePath %>';
$(function(){
	//initViewer();
	//loadTileset();
	if('${param.openIframe}'=="gjxx")
		goPage("gjxx");
	resetDivSize();
});

function resetDivSize(){
	var bodyWidth=$("body").css("width");
	var bodyHeight=$("body").css("height");
	bodyWidth=bodyWidth.substring(0,bodyWidth.length-2);
	bodyHeight=parseInt(bodyHeight.substring(0,bodyHeight.length-2));
	
	var cesiumContainerDiv=$("#cesiumContainer");
	cesiumContainerDiv.css("width",bodyWidth+"px");
	cesiumContainerDiv.css("height",bodyHeight+"px");
	
	var topDiv=$("#top_div");
	topDiv.css("margin-top",-bodyHeight+"px");

	var topDivHeight=$("#top_div").css("height");
	topDivHeight=parseInt(topDivHeight.substring(0,topDivHeight.length-2));
	
	var panelMarginTop=-(bodyHeight-topDivHeight);
	var leftPanelDiv=$("#left_panel_div");
	
	leftPanelDiv.css("margin-top",panelMarginTop+"px");
	leftPanelDiv.css("height",(bodyHeight-topDivHeight)+"px");
	
	var leftPanelWidth=leftPanelDiv.css("width");
	leftPanelWidth=parseInt(leftPanelWidth.substring(0,leftPanelWidth.length-2));
	var leftPanelHeight=leftPanelDiv.css("height");
	leftPanelHeight=leftPanelHeight.substring(0,leftPanelHeight.length-2);
	
	lpdMarginLeft=leftPanelDiv.css("margin-left");
	lpdMarginLeft=lpdMarginLeft.substring(0,lpdMarginLeft.length-2);
	
	var olpbDiv=$("#open_lp_but_div");
	var olpbHeight=olpbDiv.css("height");
	olpbHeight=olpbHeight.substring(0,olpbHeight.length-2);
	olpbDiv.css("margin-top",-(leftPanelHeight/2+olpbHeight/2+50)+"px");
}

function initViewer(){
	viewer = new Cesium.Viewer('cesiumContainer',{
        animation:false,    //???????????????????????????
        baseLayerPicker:false,  //??????????????????????????????
        geocoder:false,  //?????????
        homeButton:false,  //home??????
        sceneModePicker:false, //??????????????????
        timeline:false,    //??????????????????
        navigationHelpButton:false,  //????????????????????????
        fullscreenButton:false   //????????????????????????
	});
	
	/*
	//?????????????????????????????????https://www.cnblogs.com/telwanggs/p/11289455.html
	//???????????????????????????  html Canvas??????
    var canvas=viewer.scene.canvas;

    //??????????????????
    var handler=new Cesium.ScreenSpaceEventHandler(canvas);

    //??????????????????
    handler.setInputAction(function(movement){

        //?????????????????????
        var ellipsoid=viewer.scene.globe.ellipsoid;//???????????????
        var cartesian=viewer.scene.camera.pickEllipsoid(movement.endPosition,ellipsoid)//??????????????????????????????????????????????????????
        //????????????????????? ????????????
        var mesDom=document.getElementById('mes');
        if(cartesian){
            var cartographic=ellipsoid.cartesianToCartographic(cartesian);//??????????????????????????????
            //var coordinate="??????:"+Cesium.Math.toDegrees(cartographic.longitude).toFixed(2)+",??????:"+Cesium.Math.toDegrees(cartographic.latitude).toFixed(2)+
                    "????????????:"+Math.ceil(viewer.camera.positionCartographic.height);
            var coordinate="??????:"+Cesium.Math.toDegrees(cartographic.longitude)+",??????:"+Cesium.Math.toDegrees(cartographic.latitude)+
            "????????????:"+Math.ceil(viewer.camera.positionCartographic.height);
			console.log("coordinate==="+coordinate);
        }else{
        	
        }
    },Cesium.ScreenSpaceEventType.MOUSE_MOVE);//??????????????????????????????
	*/
}

function loadTileset(){
	var tileset = new Cesium.Cesium3DTileset({
	   url: "http://localhost:8080/PositionPhZY/upload/b3dm/tileset.json",
	   shadows:Cesium.ShadowMode.DISABLED,//????????????
	});
	console.log(tileset)
	viewer.scene.primitives.add(tileset);
	tileset.readyPromise.then(function(tileset) {
	   viewer.camera.viewBoundingSphere(tileset.boundingSphere, new Cesium.HeadingPitchRange(0, -0.5, 0));
	   //viewer.scene.primitives.remove(tileset);
	   resetDivSize();
	}).otherwise(function(error) {
	    throw(error);
	});

	/*
	var position = Cesium.Cartesian3.fromDegrees(milkTruckEnLong,milkTruckEnLat, 20);
	   var heading = Cesium.Math.toRadians(135);
	   var pitch = 0;
	   var roll = 0;
	   var hpr = new Cesium.HeadingPitchRoll(heading, pitch, roll);
	   var orientation = Cesium.Transforms.headingPitchRollQuaternion(position, hpr);
	 
	   var entity = viewer.entities.add({
		   id:"milkTruck",
	       position : position,
	       orientation : orientation,
	       model : {
	           uri: "http://localhost:8080/PositionPhZY/upload/CesiumMilkTruck.gltf",
	           //uri: "http://localhost:8080/PositionPhZY/upload/Cesium_Air.glb",
	           minimumPixelSize : 128,
	           maximumScale : 20000
	       }
	   });
	   viewer.trackedEntity = entity;
	
	tileset = new Cesium.Cesium3DTileset({
	   url: "http://localhost:8080/PositionPhZY/upload/model2/tileset.json",
	   shadows:Cesium.ShadowMode.DISABLED,//????????????
	});
	viewer.scene.primitives.add(tileset);
	tileset.readyPromise.then(function(tileset) {
	   viewer.camera.viewBoundingSphere(tileset.boundingSphere, new Cesium.HeadingPitchRange(0, -0.5, 0));
	   var cartographic = Cesium.Cartographic.fromCartesian(tileset.boundingSphere.center);
	   console.log(cartographic);
	   setTimeout(function(){
		   //viewer.scene.primitives.remove(tileset);
		   //viewer.scene.primitives.removeAll();
	   },"10000");
	}).otherwise(function(error) {
	    throw(error);
	});
	*/
}
</script>  
<title>Insert title here</title>
<style type="text/css">
.right_iframe{
	position: fixed;
	z-index: 1;
}
</style>
</head>
<body>
<div id="cesiumContainer" style="width: 100%;height: 952px;background-image: url('<%=basePath %>resource/image/202111230026.png');"></div>
<%@include file="inc/top.jsp"%>
<%@include file="inc/left.jsp"%>
<iframe class="right_iframe" id="right_iframe" src="" frameborder="0"></iframe>
<%@include file="stTool.jsp"%>
</body>
</html>