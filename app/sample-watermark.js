(function(){
  try{
    var qp = new URLSearchParams(location.search);
    var qSample = qp.get("sample");           // "1" to enable, "0" to disable
    var byQueryOn  = (qSample === "1");
    var byQueryOff = (qSample === "0");
    var byAttr  = document.body && (document.body.getAttribute("data-sample")==="1");
    var wmText  = qp.get("wm");               // optional custom overlay text
    var printOn = qp.get("printwm")==="1";    // force overlay in print

    function enableSample(text){
      document.body.classList.add("is-sample");
      if(text){ document.body.setAttribute("data-watermark", text); }
    }
    function disableSample(){
      document.body.classList.remove("is-sample");
      document.body.removeAttribute("data-watermark");
      document.body.removeAttribute("data-print");
    }

    if(byQueryOff){ disableSample(); }
    else if(byQueryOn || byAttr){ enableSample(wmText); }

    if(printOn){ document.body.setAttribute("data-print","1"); }

    // Keyboard toggle: Alt+S
    document.addEventListener("keydown", function(e){
      if(e.altKey && (e.key === "s" || e.key === "S")){
        if(document.body.classList.contains("is-sample")){ disableSample(); }
        else { enableSample(wmText || "SAMPLE"); }
      }
    });
  }catch(e){}
})();