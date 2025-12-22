#
#
#
# get google sheet
# must be public
# keep the doc id privet
#
#

    
import requests,json

def add(col,i,head):
    h = head[i]
    t = h["type"] 
    # {'id': 'F', 'label': 'ת. תחילה', 'type': 'date', 'pattern': 'M/D/YYYY'} 
    #      {'id': 'H', 'label': 'רטרו', 'type': 'string'} 
    # {'id': 'D', 'label': 'טלפון', 'type': 'string'} 
    #               {'id': 'K', 'label': 'בסיס', 'type': 'number', 'pattern': '#,##0'} 
    # {'id': 'C', 'label': 'ת.ז.', 'type': 'number', 'pattern': 'General'}
    #print(col)
    id = h["id"]
    val=""
    if "v" in col:
        val=col["v"]
    if "f" in col:
        val=col["f"]
    return id , val


def kicdev_get_sheet(doc,sheet):
    url=f"https://docs.google.com/spreadsheets/d/{doc}/gviz/tq?tqx=out:json&sheet={sheet}"
    response = requests.get(url)

    if response.status_code == 200:
        a = response.text
        b = a.split("setResponse(")[1]
        c = b[:-2]
        d = c.replace("null", '""')
        # print(d)
        res = json.loads(d)
        head = res["table"]["cols"] # "id": "J",        "label": "עיסוקים",        "type": "string"      },
        all=[]
        for rows in res["table"]["rows"]:
            i = 0
            line = {}
            for col in rows["c"]:
                id,val = add(col,i,head)
                line[id]=val
                i=i+1
            all.append(line)
        return all
    else:
        print("Error fetching data. Status code:", response.status_code)
        return {}
    
    
