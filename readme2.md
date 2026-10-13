# The Infrastructure "Flyton"

Flyton is a methodology for writing code for web projects.

---

## The Rules

- Use Apache2 on Linux Ubuntu on EC2 on AWS
- Use CloudFront to map a domain with SSL to the project  
  Example: `https://www.myproject.com` will point to the IP of the EC2 server
- Use MySQL database
- Apache2 will have a CGI script that runs Python code on the server side and generates HTML output (like PHP)
- The Flyton core of code will be open source; it includes a long list (follow-up)
- Use AWS Cloud9 as the IDE on the dev server; the prod server will be accessed only from the dev server

---

## Flyton Core Utilities

- The CGI script
- MySQL access platform with a few functions: write and read from the database
- Some utilities in Python to generate nice buttons and HTML elements
- All session management, from login to clearing expired sessions
- Manage the jump from one HTML page to the next using functions in Python
- Manage calling to the server via API: a set of JS code for the client and Python code for the server, making it easy to jump from the client directly to the server Python code and exchange objects
- A directory structure for:
  - client
  - server
  - static pages (HTML/CSS/JS/assets)

---

## MySQL

- All access via one utility: `sql.py` with ready-made read/write/delete functions
  - Read from source code `sql.py` using the `find_in_sql()` function for low-size tables (returns full results) or `sql_order()` for heavy-size tables which uses `yield` instead of returning the full array
  - For write/update records to a table, use `insert_to_sql()`
  - `sql_order()` has only these parameters: table, id, where  
    Note how `id` works: you need to start from `id=""`, pass it the first time, and the next time you will get the next id. If the table reaches the end, it will return `id=""` — where you will know the loop got to the end

- All tables in the database will have the same structure:
  - The unique id `"id"` — most of the time will be integer, auto-increment, start with 4 or 5 digits for convenience. Some tables will start with 300, some with 4000 — so ids in the system will be easy to recognize. The amount of digits will be designed for the maximum records we anticipate.
  - Field `"name"` — text
  - Field `"is_active"` = 1 if active (default), 0 if not. We will not delete records; we will mark `"is_active"=0`. `is_active` is integer.
  - Field `"created_at"` — date of creation (automatic)
  - Field `"updated_at"` — date of modification (automatic)
  - Field `"data"` — JSON format; will hold dynamic fields of a record
  - Other fields as needed — but only if all records need it

- All conditions in the database are 0 or 1. 0 is false, 1 is true.

- File containing the create command of SQL: `tables.sql` — with documentation and examples of records for each table
  - In this file, the DROP command will also be documented so you will be able to delete a table
  - In this file, a short example (3 lines top) of each table, so programmers can learn from the example of the structure of tables

- MySQL shell in Linux — we use the shell only, so programmers will be used to using SQL commands, not a web platform

---

## Writing Code

### Simple

- If you have 4 ways of writing — do the simple way
- Avoid `"else"` or `"elif"` — when a programmer reads code, it's easier to read conditions with no `"else"`
- All conditions: 0 = false, 1 = true — do not use `True` of Python or `'true'` of JavaScript
- Use an f-string as the main function to embed a variable into the string of the HTML you generate
- Do not put conditions inside the f-string — use the condition before generating the HTML
- Do not put JS code in Python — make it a `file.js` with your JS code
- The web page needs to be cut into at least 3 parts: header, body, footer
- The `"body"` part needs to be dynamic based on an `"rpage"` variable which should redirect the Python code to `rpage.py` (if `rpage="about"`, the page needs to be `about.py`)

### Directory Structure
