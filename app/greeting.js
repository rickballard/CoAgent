(function(){
  try{
    var k="coagent:lastSeenDay";
    var today=(new Date()).toISOString().slice(0,10);
    var last=localStorage.getItem(k);
    if(last!==today){
      localStorage.setItem(k,today);
      var msg='The adventure reborn with CoCivial greetings, because you matter, to carry me as I carry you, into ';
      var link='<a class="co-congruence" href="https://www.CoCivium.org" target="_blank" rel="noopener">congruence</a>.';
      var n=document.createElement('div');
      n.className="co-greeting";
      n.innerHTML = msg+link;
      document.addEventListener("DOMContentLoaded", function(){
        document.body.appendChild(n);
        setTimeout(function(){ n.classList.add("show"); }, 60);
        setTimeout(function(){ n.classList.remove("show"); n.remove(); }, 6000);
      });
    }
  }catch(e){}
})();