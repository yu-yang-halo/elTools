//(function(doc,win){
// 
// var docEl=doc.documentElement,
// resizeEvt='orientationchange' in window ? 'orientationchange':'resize',
// 
// recalc=function(){
//     var clientWidth=docEl.clientWidth;
//     if(!clientWidth) return;
// 
//     docEl.style.fontSize=100*(clientWidth/320)+'px';
// 
// };
// 
// if(!doc.addEventListener) return;
// 
// win.addEventListener(resizeEvt,recalc,false);
// doc.addEventListener('DOMContentLoaded',recalc,false);
// 
// 
// })(document,window);

//登录模块
function login(username,password){
    objc_login(username,password);
}
function loginIsOk(isOK){
    if(isOK){
        alert('SUCCESS');
    }else{
        alert('FAIL');
    }
}
//设备列表模块
function hyl_requestDevicesCmd(){
	objc_requestDevices();
}
function hyl_loadDevicesData(devices){
	/*格式【｛objectId ｝，｛｝，｛｝  】
	
	[
	{   objectId:1109,
		classId:1,
		netstate:1,
		cmdField:
		    {fieldId:110,
			fieldValue:1},
		statusField:
		[
		{
		 fieldId:112,
		 fieldValue:0}
		]
	},
	{
		
	}
	]
	
	
	
	*/
	if(devices!=undefined&&devices.length>0){
		for(var i=0;i<devices.length;i++){
			var obj=devices[i];
			var trString="";
			trString+="<tr objid="+obj.objectId+">";
			trString+="<td class='content'><img class='icon' src='img/device_gas.png'></img></td>";
			
			trString+="<td class='content'><div>"+
			"<label class='name'>"+obj.name+"</label>"+
			"<img class='onlineImg' src='img/icon_online.png'></img>"+
			"<label class='onlineText'>在线</label>"+
			"</div></td>";
			
			trString+="<td class='command'><input class='switchButton' type='image'  value='0' src='img/bg_switch_off.png'></input></td></tr>";
			
			$("#deviceTable").append(trString);
			
			
		}
		
	}else{
		
		$("#deviceTable").append("数据为空");
		
	}
	
	
	
}





























