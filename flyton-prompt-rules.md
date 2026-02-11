we called the infrastructure "Flyton" , 
Flyton is a methodology of writing code for web projects , 
the Rules:
- using apahce2 on linux ubuntu on EC2 on AWS
- using cloudFront to map a domain with SSL to the ptoject , ex: https://www.myproject.com will point to the ip of the EC2 server
- using mysql database
- apache2 will have a cgi script that will run the python code on server side and generate the HTML output (like php)
- The Flyton core of code will be openSource , it's include a long list (follow up)
- Use AWS cloud9 as the IDE on the dev server , prod server will be accessed only from the "dev" 
- Flyton core of utility are:
-- the cgi script
-- mysql access platform with few functions , write and read from the database
-- some utility in python to generate nice buttons and HTML elements
-- all session management , from the login to the clearing of expired session
-- manage the jump from one page of html to the next page using functions in python
-- manage calling to the server via api , a set of JS code for client and python code for the server which will make it easy to jump from the client directly to the server python code and exchage Objects
-a directory structure , for
-- client
-- server
-- static pages HTMR/CSS/JS/assets 
-Mysql 
-- all acces via one utiity , sql.py with read/write/delete ready made functions
--- read from the source code sql.py the function find_in_sql() for low size tables (return full results)  or sql_order() for heavy size tables which uses yield instead of return the full array
--- for write/update records to table use insert_to_sql()
--- sql_order() have only those parameters, table,id,where note how id works , you need to start from id="" pass it the first time, and the next time you will get the next id , if the table arrivesd to the end , it will return id="" where there you will know on the loop you got to the end
--All tables in the database will have the same structure
---the unique id "id" - most of the time will be integer , autoIncrement , start with 4 digit or 5 digit for convineint , some talbes will strat with 300 , some with 4000 - so id's in the system will be easy to recognize , amount of digits will be design for the amount of maximum records we intesipate
---field "name" - text
---field "is_active" = 1 if active (default) 0 if not - we will not delete records , we will mark the "is_active"=0 , is_active is integer
---field "created_at" - date of creatation (automatically)
---field "updated_at" - date of modify (automatically)
---field "data" - json format - will hold dynamic field of a record 
---other field as needed - But only if all records need it.
--all condition in Database is 0 or 1 , 0 is false , 1 is true
--file contain the create command of SQL : tables.sql - with documentations and exaple of records for each table 
--in this file , the DROP connad will also be documented so you wuill be able to delete a table
--in this file , short example (3 lines top) of each table , so programmers will be learn from example of structure of tales
--mysql shell in linux - we use the shell only - so programmers will be use to use SQL commands - not a web platform 
-writing code
--Simple
---if you have 4 way of writing - do the simp[e way
---avoid "else" or "elif" - when a programmer read a code - it's more easy to read condition with no "else"
--all conditions 0-faluse 1-true -- do not use Tru of python or 'true' of javascript. 
--using an f-string as a main function to embeded a variable into the string of the HTML you generate
--do not put condition inside the f-string - use the condition before generating the HTML
--do not put JS code in python , make it a file.js with your JS code.
--the web page need to be cut into at least 3 parts , header,body,footer
--the "body" part need to be dynamic based on an "rpage" - variable which should redirect the python code to rpage.py ( if rpage="about" the page need to be about.py )
--the directory scturcure
---/client/admin
---/client/weba
---/client/pages
---/client/pages/lib
---/client/pages/files
---/client/pages/im
---/server
---/server/cgi-bin
---/server/apis
---/server/apis/api
---/server/apis/tools
---/server/apis/tools/cron
-- The tools on the server side will be linked to the clien side 
-- server side "tools" 
--- will hold all the open source utility
--- all database access will have a db_table.py name so the table name is "table" , ex: if there is a "prod" table for products the file will be called db_prod.py
--- naming , if there is a user , it's id is user_id , if there is a product with "prod" table , it's id is "prod_id" , the id's are integers
--- use short variables naming
--- use the same table name in all other variante of the naming , 
---- example : product , the id - prod_id , the object is prod["name"]="product name" prod["is_active"]=1 ....
---- table that extend main table will have it's name as prefix , ex: product data , main table "prod" , data of product table name "prod_data" , prod_dat table will include the key "prod_id" which will point the the "prod" table
--Functions naming:
---only lower case
---first function on a .py file will have the same name of the file : dashboard.py will have "def dashbord(data):" function name.
--Do not install any packages !!! 
--if you must install - it's need to be very very low and only of you have no other chices
--each file of page will have a data object : def contact(data):  the data wil have the session saved data and the session id :   ses=data["ses"]
-sessions
-- sessions will be managed on "ses"table on the SQL
-- do not use cookies or localStorage , the session will save the session id on the LocalSession storage of the browser
-- use our login.html example to connect user to the system , use our MFA example as well if needed 
-- save to a session data if you need it in the next pages , the session data will be save in the "ses" table , and will be ready for you at each page in the data["s"] object 
-- use our add2ses function for that 
-- "ses" table is the only table which the id is not integer, it's a token string key 
-archive 
--use our archive engine , so tables that old can be cleaned up , use it for sessions and logs data 
-each records on our mysql have a json format field name "data" , use it for dynamics variable to save , use our get_data() functions and save_to_data functions in the core openSource utility
-use our core find_in_sql() function to scan the database and select a records , it's support a lot of options , with smart join ability.
-Do Not use SQL command at all
-temporary short term variable inside a loop , is as short as posible , but related to the variable you user , example, loop of table of users , use the key as "u" 
-use only lower case variables , or use _ but keep in short as posible 
-Use class rarely - the span life of a web page while it bbeeing generated is a shrt one - no need for classes 
-Write web pages on the fly - you need to know HTML / CSS and Javascrit as an expert 
-Avoide using JS if you don't need , generate all you can in the Python Server side 
-Writing Javascript
--use JS for client side interactive
--do not search you element using class name , add id to each element you need to access 
--define events inline in the element onclick=xxx() do not use afterload event locking , programmesr need to find the events easylly inline on the element 
-api's 
-- use our utility to access server side 
-- it's secure and make the JS code on the client very simple 
-- the tools let you exchange objects , from JS to python and back 
-- api's are used for html pages to be dynamics 
- table "gen" 
-- will contain the general constant of the system 
-- even small tables that not changed in time 
- table "users"
- table "logs" 
- table "ses" - active sessions 
- while writing code in python dont import the internal function one by one , use * from them all , example 
good:
from tools.sql import *
bad:
from sql import find_in_sql, insert_to_sql
- for writing code , you need to know the format of each function before generating code for it , do no guess , it better to reply with "dont have access to function foo" 
- if we use <style> with static instruction , use seperated file.css and put it in /lib/ , do not inject style in the html body
- if we use <script> with static code , use seperated file.js in /lib/ , avoid injecting JS in the html , but for eventing do use the inline , for example onclick=run_my_js() is good , also if the are parameter do pass them via the funtion parameters

More detaied instruction:
example of a project url:
https://www.ra.yaw.red/cgi-bin/p?app=start&r=309012&ses=2a866fc021714b6ab459bb3d03421&rpage=dashboard

explain: 
The domain will be change from project to project , (www.ra.yaw.red)
The (https) achived by installing the CloudFront on AWS and link it to the EC2 server on , the certificate is also from AWS , the DNS is AWS route53 , so out server can work locally with http on port 80
The (/cgi-bin/p) is the main bash script : the bash script is here: (only two lines)

#!/usr/bin/python3 
import p4web

the p4web.py file will be explain later.
The (app=start) - is a fix and save for future 
The r=... is for future
The (ses=...) is the current user session code , each browser and each tab have it's own session code , will be alocated for each user complete the login part , you will see the ses= on ALL pages on the browser
The (rpage=...) is the current page running , the source code for rpage=dashboard is on dashboard.py file 

Next is how the core flyton works:
there is /cgi-bin/p which call to p4web.py which call to /client/app/start.py , this srouce code will run 3 pythons 1.header.py 2.body.pt 3.footer.py the body will call to "dashboard.py" ig the rpage=dashboard
This description is the core of the source flow
The source og the p4web.py is here: https://github.com/yaweli/flyton/blob/main/server/cgi-bin/p4web.py , you need to read it to understand how the core flyton call the other python code of the page

How static pages works:
You can also run an html static pages , exmaple /pages/login/ will load the index.html with no use of flyton core 


Using api from client to server: 
if we want to communicate from the client to the server (exmaple for single page application) we have a core JS code for client side and python code for server side to cummunicate and exchange data , the client will send a method and an Object with data ,
  the python side (server) will run python code abd return answer in the form of JS object , 
  it will also can return error if the process is wrong , the error handling is in the core of the Flyton.
the call_Server js code is here : https://github.com/yaweli/flyton/blob/main/client/lib/kicdev.server.js you need to include it on the client page: <script src="../../lib/kicdev.server.js"></script>
When you need to call to the server , on the client , do this:
  var responseData = await call_server(meth,inp) ; 
 
  the meth is ="api_checklogin"  // each api should have different method name , and start with api_ 
  the inp is = {"user":"foo","email":"foo@foo.com"}  which is an JS object , the python side (/server/api/apis/api_checklogin.py) will recieve this as a Python object

So the python side will be able to react to this like this: (source code is: api_checklogin.py)

def api_checklogin(data):
    i = data["post"]["input"]
    u = i["user"]
    e = i["email"]
	if user_exist(u, e):
	    api_ok()
	else:
		api_err("no such user")

The JS side will chack the answer:
	if(responseData["server"]["allow"]) 
	{
		alert("login ok")
		...
	}


Also this is just an example, this is how ALL api works , meth= for action and inp= for data for this action.
The "allow" answer can hold more data from the server , like this: server side api_ok({"more_data":3}) and the client see it in responseData["server"]["more_data"]

To be able to create new Flyton code , you will need to read the code on https://github.com/yaweli/flyton/tree/main and the examples 


The sql tables:
desc users;
+------------+--------------+------+-----+-------------------+-----------------------------------------------+
| Field      | Type         | Null | Key | Default           | Extra                                         |
+------------+--------------+------+-----+-------------------+-----------------------------------------------+
| id         | int          | NO   | PRI | NULL              | auto_increment                                |
| username   | varchar(255) | YES  | UNI | NULL              |                                               |
| LastName   | text         | YES  |     | NULL              |                                               |
| FirstName  | text         | YES  |     | NULL              |                                               |
| Roles      | json         | YES  |     | NULL              |                                               |
| sis        | text         | YES  |     | NULL              |                                               |
| is_active  | tinyint(1)   | YES  |     | 1                 |                                               |
| created_at | timestamp    | YES  |     | CURRENT_TIMESTAMP | DEFAULT_GENERATED                             |
| update_at  | timestamp    | YES  |     | CURRENT_TIMESTAMP | DEFAULT_GENERATED on update CURRENT_TIMESTAMP |
| data       | json         | YES  |     | NULL              |                                               |
+------------+--------------+------+-----+-------------------+-----------------------------------------------+
10 rows in set (0.00 sec)


 desc ses; -- hold the real time sessions 
+------------+--------------+------+-----+-------------------+-----------------------------------------------+
| Field      | Type         | Null | Key | Default           | Extra                                         |
+------------+--------------+------+-----+-------------------+-----------------------------------------------+
| id         | varchar(255) | NO   | PRI | NULL              |                                               |
| user_id    | int          | YES  |     | NULL              |                                               |
| is_active  | tinyint(1)   | YES  |     | 1                 |                                               |
| created_at | timestamp    | YES  |     | CURRENT_TIMESTAMP | DEFAULT_GENERATED                             |
| update_at  | timestamp    | YES  |     | CURRENT_TIMESTAMP | DEFAULT_GENERATED on update CURRENT_TIMESTAMP |
| data       | json         | YES  |     | NULL              |                                               |
+------------+--------------+------+-----+-------------------+-----------------------------------------------+
6 rows in set (0.00 sec)



> desc gen; -- hold system wide parameters
+------------+--------------+------+-----+-------------------+-----------------------------------------------+
| Field      | Type         | Null | Key | Default           | Extra                                         |
+------------+--------------+------+-----+-------------------+-----------------------------------------------+
| id         | int          | NO   | PRI | NULL              | auto_increment                                |
| key1       | varchar(255) | YES  |     | NULL              |                                               |
| val1       | varchar(255) | YES  |     | NULL              |                                               |
| is_active  | tinyint(1)   | YES  |     | 1                 |                                               |
| created_at | timestamp    | YES  |     | CURRENT_TIMESTAMP | DEFAULT_GENERATED                             |
| update_at  | timestamp    | YES  |     | CURRENT_TIMESTAMP | DEFAULT_GENERATED on update CURRENT_TIMESTAMP |
| data       | json         | YES  |     | NULL              |                                               |
+------------+--------------+------+-----+-------------------+-----------------------------------------------+
7 rows in set (0.00 sec)

> select * from gen;
+----+------+------+-----------+---------------------+---------------------+------+
| id | key1 | val1 | is_active | created_at          | update_at           | data |
+----+------+------+-----------+---------------------+---------------------+------+
| 10 | year | 2024 |         1 | 2024-06-14 10:34:27 | 2024-06-14 10:34:27 | NULL |
+----+------+------+-----------+---------------------+---------------------+------+
1 row in set (0.00 sec)



more code methodology:
example of python code for generating html on the fly:
h = "<div>"
h += f"""  <div id=section2>
              <div>{name}</div>
           </div>
     """
return h
     
so try to use the "h" variable for all html generation content, 
try to ident the html nicely like this example,
if you dont have to don't use quotes in id= in this example id=section2 no have to be id="section2"

example of pulling from the database:

w = find_in_sql({'table': 'cust', 'fld': 'id', 'val': cust_id, 'what': 'username,LastName,FirstName,mobile,email', 'all':1})
if type(w) is bool:
    return "err"
    
-try to use "w" as the main variable from the find_in_sql for all tables,
-check the result for fail attempt

example of card , there is a function kiccard() , which provide this nice card style menu item : 
program: 
kiccard(
            txt("Manage contracts Data"),
            "",
            txt("Edit and manage customer renew contracts"),
            txt("View"),
            ses,
            "insview"
        )
        
result:        
       
![cardexample](fly1.png)


- The txt() function is ability to support multi laguale platform , so every print of a native text need to use txt() if the system is define is multi liguale , to use it you need to import this way:
from tools.kiclang  import *

- the kicbutton() is a button facility, example:

    h +=f"""
            <span>{kicbutton("custactive", ses,"click for new", "btn btn-secondary btn-sm" , {"cont_id": id, "cust_id": cust_id, "ins": ins,"org_id":org ,"act" :"new"})}</span>
    """
    

Try to less explain and be short ,unless the chat reuest was a qution and not action.
Avoide writing code that is less undersstood , dont do tricks , example h += "&nbsp;" * 7 is a trick , avoid it.
if we asked to chnge an existing python source file , and the change is just 1 up to 3 lines , show only those lines.

don't use function or variable names start with just a _ , always use lower case , avoide _ but if you need add _


- assume /lib/ maps to /client/lib/

- in critical pages , where the user is not a guest , make sure to check if the page allwed by it's role of the user. use the is_ses_role() function wich return true if role is in the user permissions:

    ses = data["ses"]
    if not is_ses_role(ses,"admin"):
        return "no alw"
- assume thise files are included:

<link href="/lib/bootstrap.min.css" rel="stylesheet" crossorigin="anonymous">
<script src="/lib/bootstrap.bundle.min.js" crossorigin="anonymous"></script>


-to get the gen table , which hold general data about the project you have function name gen_dat , use it gen = gen_data() ,
for example the roles table are in the gen , the gen array look like this:
    gen = gen_data()
    print(gen)

{
  'year': {
    'id': 10,
    'val': '2024'
  },
  'days2renew': {
    'id': 16,
    'val': '230'
  },
  'inload': {
    'id': 26,
    'val': '0'
  },
  'roles': {
    'id': 106,
    'val': '0',
    'data': {
      'admin': 'Admin',
      'owner': 'Owner',
      'lmanager': 'leads manager'
    }
  }
}

example , if i need all the Roles , the gen_data() return object and i will take the gen["roles"]["data"]
 
- while programming a front with html , use print(f"""    a lot of html """) instead if just print("...html...") , with """ you can ident new line so the html code will look good
- each source of code , put in a windows so the copy will be easy
- combine a lot of html line to one line with """ , for example, this:
    h += "<hr>"
    h += userslist(data, total)
    h += "<hr>"
should be like this:
    h += f"""<hr>
             {userslist(data, total)}
             <hr>
    """


- example how to work with sql_order:
    id = ""
    for obj in sql_order({'table': 'users', 'id': id}):
        id = obj["id"]
        h += f"""
        <tr>
        <td>{obj["id"]}</td>
        <td>{obj["username"]}</td>
        <td>{obj["LastName"]}</td>
        <td>{obj["FirstName"]}</td>
        <td>{obj["Roles"]}</td>
        </tr>
        """

- if you need to jump to other page inside JS , take the url from this function from the server , kicnav()
- example of kicnav : url = kicnav("insview2add1",ses,{"act":"add","cont_id":cont_id,"occ_id":3}) and inject it to the client side like this 
<script>
let next_url = "{url}";
</script>

- in api see example in server/apis/api/api_save_last_qr for how to retur ok answer and err answer , and save parameters in session 