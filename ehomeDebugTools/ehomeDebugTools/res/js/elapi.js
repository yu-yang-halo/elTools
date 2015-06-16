//  说明：
//  mobile_  前缀代表移动端调用标识
//  hyl_     前缀代表前端的js函数


//登录模块
function hyl_login(username,password){
    mobile_login(username,password);
}
function hyl_setUsernamePassToView(username,password){
    $(".username").val(username);
    $(".password").val(password);
}

//设备列表模块
function hyl_requestDevicesCmd(){
	mobile_requestDevices();
}
function hyl_loadDevicesData(devices){
   // alert(devices);
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
			trString+="<td class='content'><img class='icon' src='";
            trString+="img/"+obj.classId+".png'></img></td>";
            
			
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





























