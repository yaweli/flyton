import subprocess
import os

def create_and_run_bash_script(recipient_email, sender_name, sender_email, subject, email_html):

    bash_script = f"""
cat <<EOF | mailx -s "{subject}" -a "From: {sender_name} <{sender_email}>" -a "Content-Type: text/html; charset=UTF-8" {recipient_email}
{email_html}
EOF
"""

    # Save the script to a temporary file
    script_path = "/tmp/send_email.sh"
    try:
        with open(script_path, "w") as script_file:
            script_file.write(bash_script)

        # Make the script executable
        subprocess.run(["chmod", "+x", script_path], check=True)

        # Execute the script
        subprocess.run(["bash", script_path], check=True)
    finally:
        # Delete the temporary script file
        if os.path.exists(script_path):
            os.remove(script_path)