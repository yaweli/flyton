#
# new inject Fields to google doc
#
# full google drive connection (c) kicdev
# mut produce key: https://docs.google.com/document/d/1VbcTS66EPXQZH4XSibr-1DPZJwzI454lb6dIht1R9uc/edit?usp=drive_link
# 
# store json key file: f"/data/{im}/server/apis/tools/google_proj_keys.json"
#
#
# generate PDF - ishur payment from Hachshare - via generator read google drive
# username : neeman.kicdev@gmail.com
# sisma:   (eli)
# 
# see kic_gen_pdf2.py via bash
#
# yovel portal 2025
# 
from googleapiclient.discovery import build
from googleapiclient.http import MediaIoBaseDownload
from google.oauth2.service_account import Credentials
import io , os, sys
from datetime import date



def pdf_init(im="Neeman"):
    # התחברות עם Google API
    SCOPES = ['https://www.googleapis.com/auth/drive', 'https://www.googleapis.com/auth/documents']
    base_dir = os.getcwd()
    #filename = os.path.join(base_dir, "yovelproject.json")
    SERVICE_ACCOUNT_FILE = f"/data/{im}/server/apis/tools/google_proj_keys.json"
    
    creds = Credentials.from_service_account_file(SERVICE_ACCOUNT_FILE, scopes=SCOPES)
    docs_service = build('docs', 'v1', credentials=creds)
    drive_service = build('drive', 'v3', credentials=creds)
    
    return docs_service,drive_service



# 1. מילוי משתנים במסמך
def pdf_fill_template(mode , docs_service, drive_service, doc_id, replacements):
    document = docs_service.documents().get(documentId=doc_id).execute()
    requests = []
    
    for key, value in replacements.items():
        requests.append({
            'replaceAllText': {
                'containsText': {
                    'text': f'{{{{{key}}}}}',  # תבנית {{variable_name}}
                    'matchCase': True
                },
                'replaceText': str(value)
            }
        })
    
    if mode=="debug":
        print(f'req = {requests} ')
    
    docs_service.documents().batchUpdate(documentId=doc_id, body={'requests': requests}).execute()

# 2. הורדת המסמך כ-PDF
def download_as_pdf(mode,docs_service, drive_service, file_id, output_path):
    request = drive_service.files().export_media(fileId=file_id, mimeType='application/pdf')
    fh = io.FileIO(output_path, 'wb')
    downloader = MediaIoBaseDownload(fh, request)
    
    done = False
    while not done:
        status, done = downloader.next_chunk()
        if mode=="debug":
            print(f'Download {int(status.progress() * 100)}%.')
    
    if mode=="debug":
        print(f'PDF downloaded to {output_path}')


def pdf_magic(mode, docs_service, drive_service,doc_id,ses,values):
    
    # יצירת עותק של המסמך
    copied_file = drive_service.files().copy(fileId=doc_id, body={'name': f'Copy for {ses}'}).execute()
    copied_doc_id = copied_file['id']

    # מילוי תבנית בעותק
    pdf_fill_template(mode, docs_service, drive_service,copied_doc_id, values)

    # הורדה כ-PDF
    output_path = f'/tmp/y{ses}.pdf'
    download_as_pdf(mode,docs_service, drive_service,copied_doc_id, output_path)

    # מחיקת העותק
    drive_service.files().delete(fileId=copied_doc_id).execute()

    return output_path