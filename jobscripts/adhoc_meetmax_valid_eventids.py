"""
Ad-hoc script to email MeetMax Valid eventIDs as CSV attachment.
One-time use - sends to the sender (ETL_EMAIL).
"""
import os
import sys
import io
import csv
import smtplib
from email.mime.multipart import MIMEMultipart
from email.mime.text import MIMEText
from email.mime.base import MIMEBase
from email import encoders
from datetime import datetime

import pandas as pd
from sqlalchemy import create_engine, text

sys.path.append('/home/yostfundsadmin/client_etl_workflow')
from systemscripts.db_config import SQLALCHEMY_DATABASE_URL

# Gmail credentials
ETL_EMAIL = os.getenv("ETL_EMAIL")
ETL_EMAIL_PASSWORD = os.getenv("ETL_EMAIL_PASSWORD")

if not ETL_EMAIL or not ETL_EMAIL_PASSWORD:
    print("Error: ETL_EMAIL or ETL_EMAIL_PASSWORD environment variables not set")
    sys.exit(1)

# Query
QUERY = """
SELECT
    t.eventid,
    t.url,
    t.isactivewebpage,
    t.isinvalideventid,
    t.statuscode,
    t.pagestatus,
    t.numcompanies
FROM public.tmeetmaxurlscan t
WHERE datasetid = 2978227
AND t.isinvalideventid = 'False'
AND isactivewebpage = 'True'
ORDER BY eventid
"""

def main():
    # Connect and run query
    engine = create_engine(SQLALCHEMY_DATABASE_URL)
    with engine.connect() as conn:
        df = pd.read_sql(text(QUERY), conn)

    print(f"Query returned {len(df)} rows")

    # Convert to CSV
    csv_buffer = io.StringIO()
    df.to_csv(csv_buffer, index=False, quoting=csv.QUOTE_NONNUMERIC)
    csv_content = csv_buffer.getvalue()
    csv_buffer.close()

    # Build email
    timestamp = datetime.now().strftime('%Y%m%dT%H%M%S')
    filename = f"MeetMax_Valid_EventIDs_{timestamp}.csv"
    subject = "MeetMax Valid eventIDs"
    body = f"""
    <html>
    <body>
        <p>Attached: MeetMax Valid eventIDs from datasetid 2978227</p>
        <p>Row count: {len(df)}</p>
        <p>Generated: {datetime.now().strftime('%Y-%m-%d %H:%M:%S')}</p>
    </body>
    </html>
    """

    # Create message
    msg = MIMEMultipart()
    msg['From'] = ETL_EMAIL
    msg['To'] = ETL_EMAIL  # Send to self
    msg['Subject'] = subject
    msg.attach(MIMEText(body, 'html'))

    # Attach CSV
    part = MIMEBase('application', 'octet-stream')
    part.set_payload(csv_content.encode('utf-8'))
    encoders.encode_base64(part)
    part.add_header('Content-Disposition', f'attachment; filename={filename}')
    msg.attach(part)

    # Send
    with smtplib.SMTP_SSL('smtp.gmail.com', 465) as server:
        server.login(ETL_EMAIL, ETL_EMAIL_PASSWORD)
        server.sendmail(ETL_EMAIL, ETL_EMAIL, msg.as_string())

    print(f"Email sent successfully to {ETL_EMAIL}")

if __name__ == "__main__":
    main()
