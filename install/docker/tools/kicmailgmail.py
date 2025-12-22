import smtplib  # For sending emails using the SMTP protocol
from email.mime.multipart import MIMEMultipart  # For creating multi-part email messages
from email.mime.text import MIMEText  # For adding text content to the email
from email.mime.base import MIMEBase  # For attaching files
from email import encoders  # For encoding the file attachments
import os  # For file handling

def send_email_gmail(username, password, recipient_email, subject, body, urls=None, attachments=None):
    """
    Sends an email with optional URLs and attachments using Gmail SMTP.

    Parameters:
    username (str): The sender's Gmail email address.
    password (str): The sender's app-specific password.
    recipient_email (str): The recipient's email address.
    subject (str): The subject line of the email.
    body (str): The body content of the email in plain text or HTML.
    urls (list, optional): A list of URLs to include in the email body. Default is None.
    attachments (list, optional): A list of file paths for attachments. Default is None.

    Returns:
    None: Prints a success or failure message depending on the result.
    """
    # Create a MIME multi-part message object
    msg = MIMEMultipart()
    msg['From'] = username  # Sender's email address
    msg['To'] = recipient_email  # Recipient's email address
    msg['Subject'] = subject  # Subject of the email

    # Create an HTML body with embedded links
    html_body = f"<p>{body}</p>"
    if urls:
        html_body += "<ul>"
        for url in urls:
            html_body += f'<li><a href="{url}">לחץ כאן לצפייה</a></li>'
        html_body += "</ul>"

    # Attach the email body as HTML
    msg.attach(MIMEText(html_body, 'html'))

    # Add attachments if provided
    if attachments:
        for file_path in attachments:
            try:
                # Open the file in binary mode
                with open(file_path, "rb") as file:
                    # Create a MIMEBase object for the attachment
                    part = MIMEBase('application', 'octet-stream')
                    part.set_payload(file.read())  # Read file content
                    encoders.encode_base64(part)  # Encode the file content in base64
                    # Add the header with the filename
                    part.add_header(
                        'Content-Disposition',
                        f'attachment; filename={os.path.basename(file_path)}'
                    )
                    msg.attach(part)  # Attach the file to the message
            except FileNotFoundError:
                print(f"Attachment file not found: {file_path}")
                continue

    try:
        # Connect to the Gmail SMTP server
        server = smtplib.SMTP('smtp.gmail.com', 587)  # Use Gmail's SMTP server
        server.starttls()  # Start a secure TLS connection
        server.login(username, password)  # Log in with the sender's credentials
        server.send_message(msg)  # Send the email
        print("Email sent successfully!")
    except Exception as e:
        # Print an error message if something goes wrong
        print(f"Failed to send email: {str(e)}")
    finally:
        # Ensure the server connection is closed
        server.quit()


if __name__ == "__main__":
    # Replace with your Gmail email credentials
    USERNAME = "yovelp789@gmail.com"  # Sender's email address
    PASSWORD = "edix gsdo ojsz batd"  # App-specific password

    # Define the recipient's email address
    RECIPIENT_EMAIL = "yovelp789@gmail.com"

    # Define the email subject and body
    SUBJECT = "חידוש הפוליסה בוצע בהצלחה"
    BODY = "אנו מצרפים לך לינקים של מסמכי החידוש."

    # Define the URLs to include as links
    URLS = [
        "https://??/cgi-bin/p?app=webapp&r=309012&ses=2fda2bc131014ababccc622af0a8b&rpage=renewpop8",
        "https://??/cgi-bin/p?app=webapp&r=309012&ses=2fda2bc131014ababccc622af0a8b&rpage=renewDoc2",
        "https://??/cgi-bin/p?app=webapp&r=309012&ses=2fda2bc131014ababccc622af0a8b&rpage=renewPolisa2"
    ]

    # Define the list of file paths for attachments
    ATTACHMENTS = []  # Replace with the actual file paths

    # Call the function to send the email
    send_email_gmail(USERNAME, PASSWORD, RECIPIENT_EMAIL, SUBJECT, BODY, URLS, ATTACHMENTS)
