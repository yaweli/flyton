# 
#
# api from NATIVE --> to our server
# 
# curl -d '{"info":{"os":"a"}}' "http://127.0.0.1/cgi-bin/api?meth=login&u=kic&s=gp3000"
# curl -d '{"info":{"os":"a"},"input":{"p":"aaaa"}}' "http://127.0.0.1/cgi-bin/api?meth=login&u=kic&s=gp3000"
#
# 
# show last log: in case python crash
# tail -f /var/log/apache2/error.log
#################################################

import os, sys, json, base64, uuid, importlib , traceback

sys.path.append(os.path.dirname(__file__))

from tools.sql     import *
from tools.db_ses  import *


def version():
    return "1.11" # server version , 1.11 support localsession clear the old session


def out_data(): # print json server data
    print(',"server_ver":"'+version()+'"')
    return

def islogin(par): # check if user token is valid
    #print(par)
    if par["u"]=="":
        return False
    if par["p"]=="":
        return False
    u=par["u"]
    p=par["p"]
    a=login(u,p)
    print(f'"user":"{u}"')
    if []==a or a==False:
        return False
    return True



    
def logger(par,post):
    return



def do():
    env=os.environ
    qs=env.get("QUERY_STRING") # meth=login&key=ILAAZZZXXXCCC
    #co=env.get("HTTP_COOKIE")    
    par={}
    if qs != None:
        qsv=qs.split("&")
        for x in qsv:
            v=x.split("=")
            par[v[0]] = v[1]
    #print(901)
    post1 = input() # post data string # -d '{"info":{"os":"a","loc":{"latitude":34.34,"longitude":31.31}}}'
    #print(902)
    #print(post1)
    post  = json.loads(post1)
    # print("post:"+post) # post:{info:{os:a,loc:{latitude:34.34,logitde:31.31}}}
    if not "meth" in par:
        print("missing meth")
        return
    meth = par["meth"]
    unsessions = ["api_login","ping","api_start_prv"]    # a list of all no need session api's 
    
    ses=post["info"]["ses"]
    user_id=0

    if not meth in unsessions:
        if not check_ses(ses):
            uses=post["info"]["uses"]
            w=find_in_sql({'table':'ses','fld':'id','val':uses,'what':'id'})
            if type(w) is not bool:
                insert_to_sql({"table":"ses","id":uses,"set":{"is_active":0}})
                add_to_data("ses",uses,"why","local session storage on browser clear the ses mark") # Storage { ses: "5714df988022435b8adc5fc0df15c", length: 1 }
                # we unactive the old session 
            print(f',"err":"mothod need login /{ses}/{uses}","sact":"out","xses":"{ses}","xuses":"{uses}"')
            # nee to tro the user out , see call_server
            return
        user_id = find_in_sql({'table':'ses','fld':'id','val':ses,'what':'user_id',"where":"is_active>0"})[0]
    sobj={}
    if ses!="":
        sobj = get_data('ses',ses)


    match meth:
        #
        # /server/apis/api/api_login.py
        #                  ^^^^^^^^^^^^
        #                  ^^^^^^^^^ = meth
        case s if s.startswith('api_'):
            print(f'"method":"{meth}"')
            add="api."
            mod = f"{add}{meth}"
            module = importlib.import_module(mod)
            foo = getattr(module, meth)
            data={}
            data["par"]=par
            data["post"]=post

            try:
                foo(data)
            except Exception as e:
                print(f"error cgi: ", file=sys.stderr)
                traceback.print_exc(file=sys.stderr)
            return
        
        case "ping":
            logger(par,post)
            return
        case _:
            print('"err":"wrong method"')
            return
#
#
# ***    MAIN      ***
#
#
print('{"server":{')

do()

out_data()

print('}}')



