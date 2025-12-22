/* kicdev (c) */ 


function glog(t) 
{
    console.log(`%ckic/neeman: ${t}`, "color:green;");
}


glog("check session");
let ses = sessionStorage.getItem("ses")
if (!ses.length) 
{
    glog("session length error");
    document.location="/lib/error.html" ; 
}
glog("session length ok");


let z= document.location
z=z.search
z=z.split("&")
for(i=0 ; i<z.length ; ++i)
{
    let a= z[i]
    let b= a.split("=")
    if (b[0]=="ses")
    {
        urlses = b[1]
        if( urlses !== ses )
        {
            glog("sessions not matched")
            glog(urlses)
            glog(ses)
            alert("wrong access")
            document.location="/pages/err.html"
        }
    }
}
glog("sessions integrity checked")
    
