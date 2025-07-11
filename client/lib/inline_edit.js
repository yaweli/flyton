
var el_val , old_val, el_td ; 

function inline_edit(id)
{
    el_val = document.getElementById("v" + id) ; 
    old_val = el_val.innerHTML;
    
    el_td = document.getElementById("z" + id) ; 
    
    var a = ""; 
    a += "<span onclick=do_save("+id+")>Save</span> | " ; 
    a += "<span onclick=do_x("+id+")>X</span> | " ; 
    a += "<input type=text id=new value='" + old_val + "' />" ;
    el_td.innerHTML = a; 
}
function do_x(id) {
    var a = ""; 
    a += "<span onclick=inline_edit(" + id + ")> ✎ </span>"; // Use the custom icon
    a += " || <span id=v" + id + ">" + old_val + "</span>"; 
    el_td.innerHTML = a; 
}

async function do_save(id) {
    var new_val = document.getElementById("new").value; 
    console.log({new_val});
    if (new_val.length < 1) {
        alert("Too short");
        return;
    }
    
    let res = await call_server("api_rename_occ", {'id': id, 'new_val': new_val});
    console.log({res})
    if (res["server"]["allow"] == 1) {
        var a = ""; 
        a += "<span onclick=inline_edit(" + id + ")> ✎ </span>"; // Use the custom icon
        a += " (o) <span id=v" + id + ">" + new_val + "</span>"; 
        el_td.innerHTML = a; 
        return;
    }

    alert("Error from server (inline_edit.js)");
}
