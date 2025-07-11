/*

kicdev
bootstrap5 tools

*/ 


function go_clean(el) {el.classList.remove("is-valid");el.classList.remove("is-invalid");}
function go_green(el) {go_clean(el);el.classList.add("is-valid");}
function go_red(el)   {go_clean(el);el.classList.add("is-invalid");}
function go_el(id)   {return document.getElementById(id);}
