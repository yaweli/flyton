import smtplib  # For sending emails using the SMTP protocol
from email.mime.multipart import MIMEMultipart  # For creating multi-part email messages
from email.mime.text import MIMEText  # For adding text content to the email
from email.mime.base import MIMEBase  # For attaching files
from email import encoders  # For encoding the file attachments
import os  # For file handling

def send_email_outlook(username, password, recipient_email, subject, body, attachments=None):
    """
    Sends an email with optional attachments using Outlook 365 SMTP.

    Parameters:
    username (str): The sender's Outlook 365 email address.
    password (str): The sender's email password or app-specific password.
    recipient_email (str): The recipient's email address.
    subject (str): The subject line of the email.
    body (str): The body content of the email in plain text.
    attachments (list, optional): A list of file paths for attachments. Default is None.

    Returns:
    None: Prints a success or failure message depending on the result.
    """
    # Create a MIME multi-part message object
    msg = MIMEMultipart()
    msg['From'] = username  # Sender's email address
    msg['To'] = recipient_email  # Recipient's email address
    msg['Subject'] = subject  # Subject of the email

    # Attach the email body as plain text
    msg.attach(MIMEText(body, 'plain'))

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
        # Connect to the Outlook 365 SMTP server
        server = smtplib.SMTP('smtp.office365.com', 587)
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
    # Replace with your Outlook 365 email credentials
    USERNAME = "itayitayy@students.kinneret.ac.il"  # Sender's email address
    PASSWORD = "***"  # Sender's password or app-specific password

    # Define the recipient's email address
    RECIPIENT_EMAIL = "yov*"

    # Define the email subject and body
    SUBJECT = "Test Email with Attachments"
    BODY = "זה גוף המייל"

    # Define the list of file paths for attachments
    ATTACHMENTS = ["424-Assignment1-Parking-Design (1).pdf","ssrn-4398884.pdf","עיצוב ללא שם (1).pdf"]  # Replace with the actual path to the file

    # Call the function to send the email
    send_email_outlook(USERNAME, PASSWORD, RECIPIENT_EMAIL, SUBJECT, BODY, ATTACHMENTS)
