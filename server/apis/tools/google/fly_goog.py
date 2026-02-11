#
# (c) flyton standardngoogle drive access
#
# actions:
# drive_dir
# drive_fileread
#
from google.oauth2.service_account import Credentials
from googleapiclient.discovery import build


def flyg_init(sys_dir, action):
 
    # key file
    SERVICE_ACCOUNT_FILE = f"../google_proj_keys.json"
 
    service_part = action.split("_")[0] # drive/docs 
 
    # התחברות עם Google API
    if action=="drive_dir":
        SCOPES = ['https://www.googleapis.com/auth/drive.readonly']
        
    if action=="docs_fileread":
        SCOPES = ['https://www.googleapis.com/auth/documents.readonly']  
        
    # SCOPES = ['https://www.googleapis.com/auth/drive', 'https://www.googleapis.com/auth/documents']
    # 'https://www.googleapis.com/auth/drive.readonly'
    
    creds = Credentials.from_service_account_file(SERVICE_ACCOUNT_FILE, scopes=SCOPES)
    

    if service_part=="drive":
        service = build('drive', 'v3', credentials=creds)
        
    if service_part=="docs":
        service = build('docs', 'v1', credentials=creds)
        
    return service



    # docs_service = build('docs', 'v1', credentials=creds)
    # drive_service = build('drive', 'v3', credentials=creds)
    
    # return docs_service,drive_service    
    
    
    
def flyg_dir(service, doc_id, opt = {} ):
    pass