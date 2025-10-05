(function(){
  try{
    var qp = new URLSearchParams(location.search);
    var byQuery = qp.get("sample")==="1";
    var byAttr  = document.body && (document.body.getAttribute("data-sample")==="1");
    var wmText  = qp.get("wm");           // optional: ?wm=DEMO or ?wm=PREVIEW
    if(byQuery || byAttr){
      document.body.classList.add("is-sample");
      if(wmText){ document.body.setAttribute("data-watermark", wmText); }
    }
  }catch(e){}
})();
