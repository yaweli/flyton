
from fly_goog import *

print("Test t1")


doc_id = "1M4PW_ADGmzxEn5yW_5ROnyHWU2MBzZLv"

service = flyg_init("fly", "drive_dir")

list_files = flyg_dir(service, doc_id, {"view":"name"}) 

print(list_files)

