# The Infrastructure "Flyton"

Flyton is a methodology for writing code for web projects.

> **For AI code agents:** these are your working rules for any Flyton project. Read this file fully before writing code, and follow it over your general habits. When a function is not described here, read its source instead of guessing.

---

## The Rules

- Use Apache2 on Ubuntu Linux on AWS EC2
- Use CloudFront to map a domain with SSL to the project. Example: https://www.myproject.com will point to the IP of the EC2 server
- Use a MySQL database
- Apache2 will have a CGI script that runs Python code on the server side and generates HTML output (like PHP)
- The Flyton core code will be open source; it includes a long list of utilities (see below)
- Use AWS Cloud9 as the IDE on the dev server; the prod server will be accessed only from the dev server

---

## Flyton Core Utilities

- The CGI script
- A MySQL access layer with a few functions to read from and write to the database
- Some Python utilities to generate nice buttons and HTML elements
- All session management, from login to clearing expired sessions
- Managing the jump from one HTML page to the next using Python functions
- Managing calls to the server via API: a set of JS code for the client and Python code for the server, making it easy to jump from the client directly to the server Python code and exchange objects
- A directory structure for the client, the server and static pages (HTML/CSS/JS/assets)

---

## MySQL

- All access goes through one utility: sql.py, with ready-made read/write/delete functions
  - To read, use find_in_sql() from sql.py for small tables (returns the full results) or sql_order() for large tables (uses yield instead of returning the full array)
  - To write or update records in a table, use insert_to_sql()
  - sql_order() has only these parameters: table, id, where. Note how id works: pass id="" the first time, and each time you will get the next id. When the table reaches the end, it returns id="" — that is how you know the loop is done

- All tables in the database will have the same structure:
  - The unique id "id" — most of the time an integer, auto-increment, starting with 4 or 5 digits for convenience. Some tables will start at 300, some at 4000 — so ids in the system are easy to recognize. The number of digits is designed for the maximum number of records we anticipate.
  - Field "name" — text
  - Field "is_active" = 1 if active (default), 0 if not. We do not delete records; we mark them "is_active"=0. is_active is an integer.
  - Field "created_at" — date of creation (automatic)
  - Field "updated_at" — date of modification (automatic)
  - Field "data" — JSON format; holds the dynamic fields of a record
  - Other fields as needed — but only if all records need them

- All conditions in the database are 0 or 1: 0 is false, 1 is true.

- tables.sql — a file containing the SQL CREATE commands, with documentation and example records for each table
  - In this file, the DROP command is also documented, so you will be able to delete a table
  - In this file, a short example (top 3 lines) of each table, so programmers can learn the table structure from examples

- MySQL shell in Linux — we use the shell only, so programmers get used to SQL commands, not a web platform

---

## Writing Code

### Simple

- If there are 4 ways to write something — choose the simplest
- Avoid "else" or "elif" — when a programmer reads code, it's easier to read conditions without "else"
- All conditions: 0 = false, 1 = true — do not use Python's True or JavaScript's true
- Use an f-string as the main way to embed variables into the HTML string you generate
- Do not put conditions inside the f-string — evaluate the condition before generating the HTML
- Do not put JS code in Python — put your JS code in a file.js
- The web page needs to be split into at least 3 parts: header, body, footer
- The "body" part needs to be dynamic, based on an "rpage" variable that routes the Python code to rpage.py (if rpage="about", the page is about.py)

### Directory Structure

```text
/client/admin
/client/weba
/client/pages
/client/pages/lib
/client/pages/files
/client/pages/im
/server
/server/cgi-bin
/server/apis
/server/apis/api
/server/apis/tools
/server/apis/tools/cron
```

- The tools on the server side will be linked to the client side
- Server-side "tools":
  - Will hold all the open-source utilities
  - Each database table will have a db_table.py access file, where "table" is the table name. Example: if there is a "prod" table for products, the file will be called db_prod.py
  - Naming: a user's id is user_id; a product in the "prod" table has the id "prod_id". The ids are integers.
  - Use short variable names
  - Use the same table name in all other variants of the naming
    - Example: product — the id is prod_id, the object is prod["name"]="product name", prod["is_active"]=1, etc.
    - Tables that extend a main table use its name as a prefix. Example: product data — main table "prod", product data table "prod_data". The prod_data table includes the key "prod_id", which points to the "prod" table

### Function Naming

- Only lowercase
- The first function in a .py file has the same name as the file: dashboard.py will have the function def dashboard(data):

### General Rules

- Do not install any packages!
- If you must install — keep it to a minimum, and only if you have no other choice
- Each page file will have a data object: def contact(data): — data holds the saved session data and the session id: ses=data["ses"]

---

## Sessions

- Sessions are managed in the "ses" table in SQL
- Do not use cookies or localStorage — the session id is saved in the browser's sessionStorage
- Use our login.html example to connect a user to the system; use our MFA example as well if needed
- Save data to the session if you need it in the next pages. The session data is saved in the "ses" table and will be ready for you on each page in the data["s"] object
- Use our add2ses function for that
- The "ses" table is the only table where the id is not an integer — it's a string token key

---

## Archive

- Use our archive engine so old tables can be cleaned up. Use it for sessions and logs data.

---

## Data Field

- Each record in our MySQL has a JSON field named "data". Use it to save dynamic variables. Use our get_data() and add_to_data() functions in the core open-source utilities.
- Use our core find_in_sql() function to scan the database and select records. It supports a lot of options, including smart joins.
- Do not use SQL commands at all.
- Temporary short-term variables inside a loop should be as short as possible, but related to what they hold. Example: in a loop over the users table, use "u" as the key.
- Use only lowercase variables; you may use _, but keep names as short as possible.
- Use classes rarely — a web page lives only a short time while it is generated; there is no need for classes.
- Write web pages on the fly — you need to know HTML/CSS/JavaScript like an expert.
- Avoid using JS if you don't need it; generate all you can on the Python server side.

---

## Writing JavaScript

- Use JS for client-side interactivity
- Do not search for elements by class name; add an id to each element you need to access
- Define events inline on the element: onclick=xxx(). Do not attach events after the page loads; programmers need to find the events easily, inline on the element.

### APIs

- Use our utility to access the server side
- It's secure and makes the JS code on the client very simple
- The tools let you exchange objects, from JS to Python and back
- APIs are used to make HTML pages dynamic

---

## Tables

### Table "gen"

- Contains the general constants of the system
- Even small tables that do not change over time

### Table "users"

### Table "logs"

### Table "ses" — active sessions

---

## Python Imports

While writing code in Python, do not import the internal functions one by one. Use * to import them all.

Example (good):

```python
from tools.sql import *
```

Not this way (bad):

```python
from sql import find_in_sql, insert_to_sql
```

- When writing code, you need to know the format of each function before generating code for it. Do not guess. It is better to reply with "I don't have access to function foo".
- If we use <style> with static rules, use a separate file.css and put it in /lib/. Do not inject styles into the HTML body.
- If we use <script> with static code, use a separate file.js in /lib/. Avoid injecting JS into the HTML, but for events do use inline handlers. For example, onclick=run_my_js() is good. Also, if there are parameters, pass them as function arguments.

---

## More Detailed Instructions

### Example of a Project URL

```text
https://www.ra.yaw.red/cgi-bin/p?app=start&r=309012&ses=2a866fc021714b6ab459bb3d03421&rpage=dashboard
```

Explanation:

- The domain will change from project to project: www.ra.yaw.red
- HTTPS is achieved by installing CloudFront on AWS and linking it to the EC2 server. The certificate is also from AWS, and the DNS is AWS Route 53, so our server can work locally with HTTP on port 80.
- /cgi-bin/p is the main CGI script. Here it is (only two lines):

```python
#!/usr/bin/python3
import p4web
```

- The p4web.py file will be explained later.
- app=start is fixed and reserved for the future.
- r=... is for the future.
- ses=... is the current user session code. Each browser and each tab has its own session code. It is allocated to the user after completing the login. You will see ses= on ALL pages in the browser.
- rpage=... is the page currently running. The source code for rpage=dashboard is in the dashboard.py file.

### How the Flyton Core Works

/cgi-bin/p calls p4web.py, which calls /client/app/start.py. This code runs 3 Python files:

1. header.py
2. body.py
3. footer.py

The body will call dashboard.py if rpage=dashboard.

This description is the core of the source flow.

The source of p4web.py is here:
https://github.com/yaweli/flyton/blob/main/server/cgi-bin/p4web.py

You need to read it to understand how the Flyton core calls the other Python code of the page.

### How Static Pages Work

You can also serve static HTML pages. Example: /pages/login/ will load index.html without using the Flyton core.

---

## Using the API from Client to Server

If we want to communicate from the client to the server (for example, in a single-page application), we have core JS code for the client side and Python code for the server side to communicate and exchange data.

The client sends a method and an object with data.
The Python side (server) runs Python code and returns an answer in the form of a JS object.
It can also return an error if the process fails. The error handling is in the Flyton core.

The call_server JS code is here:
https://github.com/yaweli/flyton/blob/main/client/lib/kicdev.server.js

You need to include it on the client page:

```html
<script src="../../lib/kicdev.server.js"></script>
```

When you need to call the server from the client, do this:

```javascript
var responseData = await call_server(meth, inp);
```

- meth is "api_checklogin" — each API should have a different method name and start with api_
- inp is {"user":"foo","email":"foo@foo.com"}, which is a JS object. The Python side (/server/apis/api/api_checklogin.py) receives it as a Python object.

The Python side can then react like this (source code in api_checklogin.py):

```python
def api_checklogin(data):
    i = data["post"]["input"]
    u = i["user"]
    e = i["email"]
    if user_exist(u, e):
        api_ok()
    else:
        api_err("no such user")
```

The JS side checks the answer:

```javascript
if (responseData["server"]["allow"]) {
    alert("login ok");
    ...
}
```

This is just an example, but this is how ALL APIs work: meth= for the action and inp= for the data of this action.

The "allow" answer can hold more data from the server. For example, the server side calls api_ok({"more_data":3}) and the client sees it in responseData["server"]["more_data"].

To create new Flyton code, you will need to read the code at https://github.com/yaweli/flyton/tree/main and the examples.

---

## SQL Tables

### desc users;

```text
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
```

### desc ses; -- holds the real-time sessions

```text
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
```

### desc gen; -- holds system-wide parameters

```text
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
```

### select * from gen;

```text
+----+------+------+-----------+---------------------+---------------------+------+
| id | key1 | val1 | is_active | created_at          | update_at           | data |
+----+------+------+-----------+---------------------+---------------------+------+
| 10 | year | 2024 |         1 | 2024-06-14 10:34:27 | 2024-06-14 10:34:27 | NULL |
+----+------+------+-----------+---------------------+---------------------+------+
1 row in set (0.00 sec)
```

---

## More Code Methodology

### Example of Python Code for Generating HTML on the Fly

```python
h = "<div>"
h += f"""  <div id=section2>
              <div>{name}</div>
           </div>
     """
return h
```

Try to use the "h" variable for all generated HTML content.
Try to indent the HTML nicely, as in this example.
If you don't have to, don't use quotes in id=. In this example, id=section2 does not need to be id="section2".

### Example of Pulling from the Database

```python
w = find_in_sql({'table': 'cust', 'fld': 'id', 'val': cust_id, 'what': 'username,LastName,FirstName,mobile,email', 'all':1})
if type(w) is bool:
    return "err"
```

- Try to use "w" as the main variable for find_in_sql results, for all tables
- Check the result for a failed query

### Example of a Card

The kiccard() function provides this nice card-style menu item:

```python
kiccard(
    txt("Manage contracts Data"),
    "",
    txt("Edit and manage customer renew contracts"),
    txt("View"),
    ses,
    "insview"
)
```

Result:

![cardexample](fly1.png)

- The txt() function provides multi-language support, so every native text you print needs to use txt() if the system is defined as multilingual. To use it, import it this way:

```python
from tools.kiclang import *
```

- kicbutton() is a button utility. Example:

```python
h += f"""
        <span>{kicbutton("custactive", ses, "click for new", "btn btn-secondary btn-sm", {"cont_id": id, "cust_id": cust_id, "ins": ins, "org_id": org, "act": "new"})}</span>
"""
```

- When kicbutton is used as a Save button, you will want to get the values of the other FORM <input> elements. Tell kicbutton to load them by adding "use":"username/mobile/Firstname/Lastname", which are all ids of <input> tags. Example: <input id="username" name="username" value="default">

---

## General Style Rules

- Explain less and be short, unless the chat request was a question and not an action.
- Avoid writing code that is hard to understand. Do not use tricks. Example: h += "&nbsp;" * 7 is a trick — avoid it.
- If we ask you to change an existing Python source file, and the change is just 1 to 3 lines, show only those lines.
- Do not use function or variable names that start with _. Always use lowercase. Avoid _, but use it if you need to.
- Assume /lib/ maps to /client/lib/.
- In critical pages, where the user is not a guest, make sure the page is allowed for the user's role. Use the is_ses_role() function, which returns true if the role is in the user's permissions:

```python
ses = data["ses"]
if not is_ses_role(ses, "admin"):
    return "no alw"
```

- Assume these files are included:

```html
<link href="/lib/bootstrap.min.css" rel="stylesheet" crossorigin="anonymous">
<script src="/lib/bootstrap.bundle.min.js" crossorigin="anonymous"></script>
```

- To get the gen table, which holds general data about the project, use the gen_data() function: gen = gen_data().

For example, the roles table is in gen. The gen object looks like this:

```python
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
```

Example: if I need all the roles, gen_data() returns an object and I take gen["roles"]["data"].

- When writing front-end HTML, use print(f"""    a lot of html """) instead of just print("...html..."). With """ you can indent new lines so the HTML code looks good.

- Put each piece of source code in its own code block so it is easy to copy.

- Combine many HTML lines into one with """. For example, this:

```python
h += "<hr>"
h += userslist(data, total)
h += "<hr>"
```

should be like this:

```python
h += f"""<hr>
         {userslist(data, total)}
         <hr>
"""
```

- Example of how to work with sql_order:

```python
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
```

- If you need to jump to another page from JS, get the URL from the server with kicnav().

Example of kicnav:

```python
url = kicnav("insview2add1", ses, {"act":"add","cont_id":cont_id,"occ_id":3})
```

And inject it into the client side like this:

```html
<script>
var next_url = "{url}";
</script>
```

- For APIs, see the example in server/apis/api/api_save_last_qr.py for how to return an ok answer and an err answer, and how to save parameters in the session.

---

## Gen Table Methodology

In the gen table we store small general tables, and we use some naming suffixes, which should be kept as the standard:

- _type — small list — the types of something
- _dict — small object — maps the codes of a field to their names. See the examples. Most of the time it explains the "is_active" field of a table, but it can explain any field of a table.
- _prov — small list — providers (suppliers)

See db_tab.py: use list_gen_tab() and list_tab_dict() to get the table as a list or an object.

Examples:

```text
+----+-------------+------+-----------+--------------------------------------------------------------------------------------------------------------------------+
| id | key1        | val1 | is_active | data                                                                                                                     |
+----+-------------+------+-----------+--------------------------------------------------------------------------------------------------------------------------+
| 41 | ast_type    | 0    |         1 | ["email", "vm", "license", "phone", "persona", "card", "vps", "vpn"]                                                     |
| 45 | enc_type    | 0    |         1 | ["base64", "AESGCM128bit"]                                                                                               |
| 47 | os_type     | 0    |         1 | ["linux", "windows", "android"]                                                                                          |
| 49 | route_type  | 0    |         1 | ["vpn", "residential_proxy"]                                                                                             |
| 50 | status_type | 0    |         1 | ["draft", "ready", "provisioning", "connected", "error", "archived"]                                                     |
| 55 | sens_type   | 0    |         1 | ["white", "grey", "green", "black"]                                                                                      |
| 76 | sim_type    | 0    |         1 | ["physical", "esim", "virtual-sim-account"]                                                                              |
| 51 | worksp_dict | 0    |         1 | {"is_active": {"0": "archived", "1": "ready", "3": "draft", "10": "connected", "13": "in progress"}}                     |
| 52 | ast_dict    | 0    |         1 | {"is_active": {"0": "pending", "1": "free", "2": "active", "12": "rotating", "13": "suspended", "15": "decommissioned"}} |
| 53 | proj_dict   | 0    |         1 | {"is_active": {"0": "archived", "1": "active", "2": "planning"}}                                                         |
| 61 | email_prov  | 0    |         1 | ["gmail", "outlook", "others"]                                                                                           |
| 65 | vps_prov    | 0    |         1 | ["AWS", "hetzner", "DigitalOcean", "Vultr", "proxmox"]                                                                   |
| 85 | social_prov | 0    |         1 | ["twitter", "linkedin", "telegram", "instagram", "facebook", "other"]                                                    |
+----+-------------+------+-----------+--------------------------------------------------------------------------------------------------------------------------+
18 rows in set (0.00 sec)
```

- Each SQL table, for example "part", will have a db_part.py that handles reading and writing the table. It will have part_list(), part_get(), and for adding a new part, part_chk() to check before adding and part_add(). part_chk() returns a fixed version of the input fields, so if a record has the phone number "052-3232323", it may return the clean version "0523232323", which is what gets saved to SQL.

---

## Writing JS Style

- Write simple lines, so the code is readable
- var foo = "something" — don't use const or let. This way we all use flexible variables, so they are easy to change in the future. It is the programmer's responsibility to keep a variable constant if they want to.
- Don't do tricks. Don't use _foo; prefer "foo". Avoid .map and .reduce; use a loop so it is easy to read.
- Don't chain foo1.foo2.foo3...; access it line by line so it stays simple.
- To declare a new function, use function foo() ... and not const foo = function() {}
- Variables: no uppercase, just abc or abc_efg, all lowercase
- In a loop, try to use short variable names. Example: custs[] and not customers[]. The loop item can be cust1, or even c.
