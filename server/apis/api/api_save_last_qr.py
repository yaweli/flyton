# api_save_last_qr.py

from tools.db_ses import *
from tools.kicapi import *

def api_save_last_qr(data):
    input = data["post"]["input"]
    ses=data["post"]["info"]["ses"]


    qr_content = input["qr_content"]

    # Store in session data (json field "data" in ses table)
    add2ses(ses, {"last_qr_raw": qr_content})

    # Return success (you can add more fields if needed)
    api_ok({
        "saved": 1,
        "length": len(qr_content)
    })