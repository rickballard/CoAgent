(function(){
  try{
    var root = document.createElement("div");
    root.className = "demo-chip";
    root.innerHTML = [
      "<label title=\"Show diagonal SAMPLE watermark\"><input type=\"checkbox\" id=\"demoChipToggle\"> Sample</label>",
      "<label title=\"Show watermark in printouts\"><input type=\"checkbox\" id=\"demoChipPrint\"> Print</label>",
      "<button type=\"button\" id=\"demoChipWm\">Text</button>"
    ].join(" ");
    document.addEventListener("DOMContentLoaded", function(){
      document.body.appendChild(root);
      var t = document.getElementById("demoChipToggle");
      var p = document.getElementById("demoChipPrint");
      var b = document.getElementById("demoChipWm");
      var has = document.body.classList.contains("is-sample");
      t.checked = has;
      p.checked = document.body.getAttribute("data-print")==="1";
      t.addEventListener("change", function(){
        if(t.checked){ document.body.classList.add("is-sample"); }
        else { document.body.classList.remove("is-sample"); document.body.removeAttribute("data-watermark"); }
      });
      p.addEventListener("change", function(){
        if(p.checked){ document.body.setAttribute("data-print","1"); }
        else { document.body.removeAttribute("data-print"); }
      });
      b.addEventListener("click", function(){
        var cur = document.body.getAttribute("data-watermark") || "SAMPLE";
        var next = prompt("Watermark text:", cur);
        if(next===null) return;
        if(next===""){ document.body.removeAttribute("data-watermark"); }
        else { document.body.setAttribute("data-watermark", next); }
        if(!document.body.classList.contains("is-sample")){ document.body.classList.add("is-sample"); }
      });
    });
  }catch(e){}
})();
