/*

Kicdev tools

a means to communication from cliet browser to server side

client javascript browser call to call_server("method",{any object})

server side /server/apis/api/api_method.py

function name "api_method(data)"

api_method.py will print json string to be return to the Javascript client



server side versions:
ver 2 - support file uploads , id must start with "file_"

*/

var gl ; 

async function call_server(meth,inp) {

    var responseData = {} ; 
    // try {

        // make inp["file_1"] to b64_file_1 
        //                       ^^^^^^^^^^ 
        for (const key in inp) {
          if (inp.hasOwnProperty(key) && key.startsWith("file_")) {
            // Do something
            inp[`b64_${key}`] = arrayBufferToBase64(inp[key] ) ; 
            //   b64_file_1
            delete inp[key] ; 
            break; // only one base64 per form submit
          }
        }


        let url=`/cgi-bin/api?meth=${meth}`;
        let ses = sessionStorage.getItem("ses");
        let uses = "";         // let uses = String(document.location?.search).split("ses=")[1].split("&")[0]; // session from url 
        try {
          uses = String(document.location?.search || "")
            .split("ses=")[1]
            ?.split("&")[0] || "";
        } catch (e) {
          uses = "";
        }        
        let inf = {info: { os:"a" , ses , uses}, input:inp}; 
        console.log("You are in call server:");
        console.log({inf});
        gl = inf; 
        /* global fetch */ 
        const response = await fetch(url, {
            method: 'POST', // Specify the request method
            headers: {
                'Content-Type': 'application/json', // Set the content type to JSON
            },
            body: JSON.stringify(inf)  // Convert the data to a JSON string
        });
        // Check if the response is ok (status code 200-299)
        if (!response.ok) {
            throw new Error(`HTTP error! status: ${response.status}`);
        }
        
        console.log("response before");
        // Parse the JSON from the response
        responseData = await response.json();
        console.log("response after");
        if( responseData.server?.sact == "out" )
        {
            alert("Your session is expired , please reconnect to the website, click ok to connect as a guest")
            document.location= "/pages/enter/?via=relog" // cgi-bin/p?app=start&r=309012"
        }


// }
// catch (error) {
//         console.log('server error:', error);
//     }

return responseData ; 

    
}



function arrayBufferToBase64(buffer) {
    var binary = '';
    var bytes = new Uint8Array(buffer);
    var len = bytes.byteLength;
    for (var i = 0; i < len; i++) {
        binary += String.fromCharCode(bytes[i]);
    }
    return window.btoa(binary);
}

async function x_call_server_for_media(meth, inp) {
    try {
        const base64Data = arrayBufferToBase64(inp.arrayBuffer);  // Convert ArrayBuffer to Base64
        const url = `/cgi-bin/api?meth=${meth}`;
        const ses = sessionStorage.getItem("ses");
        const inf = {
            info: { os: "a", ses },
            input: { image: base64Data }  // Send as a string inside the input object
        };

        const response = await fetch(url, {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json'
            },
            body: JSON.stringify(inf)
        });

        if (!response.ok) {
            throw new Error(`HTTP error! Status: ${response.status}`);
        }

        const responseData = await response.json();
        console.log("Response Data:", responseData);
        return responseData;
    } catch (error) {
        console.error('Server error:', error);
    }
}

