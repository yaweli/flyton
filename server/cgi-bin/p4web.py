#e.s.
#
#
import os
import sys
import importlib.util
# globals
# get url 
#
#########
#
# headers
# cancel cache in your f12 browser!
CompanyTitle="Myproj"


print("content-type: text/html")
print("")
print(f"""
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>{CompanyTitle}</title>
    <link rel="stylesheet" href="/lib/styles.css">
    <link rel="stylesheet" href="/lib/font-awesome/all.min.css">
    </head>
<body>
    """)
#
# page
global r
r=0
#
# url 
#
def url(app):
    global r
    r=r+1
    return f"/cgi-bin/p?r={r}&app={app}"
#
#
#
# url string data
# 
env=os.environ
qs=env.get("QUERY_STRING")
if len(sys.argv)>1:
    qs="app="+sys.argv[1]
    print("<!-- argv exist-->")
#qs="app=customers"
global par
par={}
if qs != None:
    qsv=qs.split("&")
    for x in qsv:
        v=x.split("=")
        par[v[0]] = v[1]
print("<!-- p4web(c) :")
print(par)
print("-->")
# bootstrap
#
print("""
<link href="/lib/bootstrap.min.css" rel="stylesheet" crossorigin="anonymous">
<script src="/lib/bootstrap.bundle.min.js" crossorigin="anonymous"></script>

""")
#
# dynamic import 
# /var/www/html/app/ [ app name ]
#
#
if "r" in par:
    r=int(par["r"])
if "ses" in par:
    ses=par["ses"]
    
if "app" in par: 
    spec = importlib.util.spec_from_file_location("*", "/var/www/htmlra/app/"+par["app"]+".py")
    foo = importlib.util.module_from_spec(spec)
    sys.modules["module.name"] = foo
    spec.loader.exec_module(foo)
    foo.main(par)

