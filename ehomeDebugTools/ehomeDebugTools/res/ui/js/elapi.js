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
//发送设备命令
function hyl_setFieldCmd(fieldValue,fieldId,objectId){
    mobile_setFieldCmd(fieldValue,fieldId,objectId);
}

function hyl_updateDeviceName(name,objectId){
    mobile_updateDeviceName(name,objectId);
}


//跳转到设备详细界面
function hyl_toDetailPage(objectId){
    mobile_toDetailPage(objectId);
}
function hyl_loadDevicesData(devices,classTable,classIcon){
    $("#deviceTable").empty();
	/*
      device :
     
     [
     
     {"bindVmId":0,"fieldMap":{"72":"35","71":"1","74":"bedroom"},"accessYN":0,"connType":0,"objectId":120,"clientSn":"BFF0006101418","locId":0,"name":"红外移动传感器","gatewayId":0,"classId":7,"netState":0,"ccsClientId":193}
     ]
     
      class  :
     
---------->{"classId1":[fields],"classId2":[fields]}
     
     
	{"3":[{"fieldName":"battery","deviceCmdYN":0,"displayName":"剩余电量","aggrMethod":0,"dataType":1,"presistYN":1,"tsYN":0,"deviceStateYN":1,"fieldId":23},{"fieldName":"location","deviceCmdYN":0,"displayName":"安装位置","aggrMethod":0,"dataType":1,"presistYN":1,"tsYN":0,"deviceStateYN":0,"fieldId":24},{"fieldName":"alert","deviceCmdYN":0,"displayName":"警报","aggrMethod":0,"dataType":1,"presistYN":0,"tsYN":0,"deviceStateYN":1,"fieldId":21},{"fieldName":"status","deviceCmdYN":0,"displayName":"开关状态","aggrMethod":0,"dataType":1,"presistYN":0,"tsYN":0,"deviceStateYN":1,"fieldId":22},{"fieldName":"test","deviceCmdYN":0,"displayName":"test","aggrMethod":0,"dataType":1,"presistYN":1,"tsYN":1,"deviceStateYN":0,"fieldId":260}]
     ,
     
    }
	
	
	*/
    
	if(devices!=undefined&&devices.length>0){
		for(var i=0;i<devices.length;i++){
            
			var obj=devices[i];
			var trString="";
			trString+="<tr objectId="+obj.objectId+">";
			trString+="<td class='content'><img class='icon' src='";
            trString+="../cls/"+classIcon[obj.classId]+"'></img></td>";
            
			
			trString+="<td class='content'><div>"+
			"<label class='name'>"+obj.name+"</label>"
            
            var tmp_online_icon="img/icon_online.png";
            var tmp_online_content="在线";
            if(obj.netState==0){
                tmp_online_icon="img/icon_offline.png";
                tmp_online_content="离线";
            }
            
            trString+="<img class='onlineImg' src='"+tmp_online_icon+
            "'></img><label class='onlineText'>"+tmp_online_content+"</label>"+
            "</div></td><td class='command'>";
            
            var fieldValues=obj.fieldMap;
            
            var fields=classTable[obj.classId];
            for(var j=0;j<fields.length;j++){
                var field=fields[j];
                var key=field.fieldId;
                var isExist=fieldIsExistInFieldMap(field,fieldValues);
                if(isExist){
                    if(field.deviceCmdYN==1&&field.deviceStateYN==1){
                        var pngString;
                        if(fieldValues[key]==0){
                            pngString="img/bg_switch_off.png";
                        }else{
                            pngString="img/bg_switch_on.png";
                        }
                        var inputHtmlString="<input class='switchButton' type='image' fieldId='"+key+"'  value='"+fieldValues[key]+"' objectId='"+obj.objectId+"' src='"+pngString+"'></input>"
                        
                        trString+=inputHtmlString;
                        break;
                    }
                }
                
            }
            
			trString+="</td></tr>";
			
			
			$("#deviceTable").append(trString);
			
			
		}
        load();
		
	}else{
		
		$("#deviceTable").append("<center><span style='width:100%;height:100%;color:#ff0000'>数据为空<span></center>");
		
	}
	
	
	
}
function fieldIsExistInFieldMap(field,fieldMap){
    var isExist=false;
    if(fieldMap==undefined){
        isExist=false;
    }else{
        for(var value in fieldMap){
            if(value==field.fieldId){
                isExist=true;
                break;
            }
        }
    }
    
    return isExist;
}

//从属性列表中找到属性对象值
function findFieldByFieldId(fieldId,fields){
  
    var _field;
    for(var i=0;i<fields.length;i++){
        if(fieldId==fields[i].fieldId){
            _field=fields[i];
            break;
        }
    }
    return _field;
}
function load(){
    $(".switchButton").click(function(){
                             
                             if($(this).attr("value")==0){
                             $(this).attr("src",'img/bg_switch_on.png');
                             $(this).attr("value",1);
                             }else{
                             $(this).attr("src",'img/bg_switch_off.png');
                             $(this).attr("value",0);
                             }
                             
                             hyl_setFieldCmd($(this).attr("value"),$(this).attr("fieldId"),$(this).attr("objectId"));
                             
                             
                             event.cancelBubble=true;

    });
    
    $("#deviceTable tr").click(function(){
                        
                        $(this).addClass("on").siblings("tr").removeClass("on");
                        
                        
                        hyl_toDetailPage($(this).attr('objectId'));
                        
                        });
    

    

}




//详细设备界面


function hyl_requestDeviceInfo(){
    mobile_requestDeviceInfo();
}


















