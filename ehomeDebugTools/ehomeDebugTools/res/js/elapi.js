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
function login(username,password){
    //alert("username:"+username+" password:"+password);
    objc_login(username,password);
}
function loginIsOk(isOK){
    if(isOK){
        alert('SUCCESS');
    }else{
        alert('FAIL');
    }
}