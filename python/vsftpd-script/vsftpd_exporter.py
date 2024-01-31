from flask import Flask
from prometheus_client import Counter
import re

app = Flask(__name__)

successful_logins = Counter('vsftpd_successful_logins', 'Number of successful VSFTPD logins')
failed_logins = Counter('vsftpd_failed_logins', 'Number of failed VSFTPD logins')

vsftpd_log_path = '/var/log/vsftpd.log'  # Update with the correct path to your VSFTPD log file

def parse_vsftpd_logs():
    with open(vsftpd_log_path, 'r') as file:
        logs = file.readlines()

    for log in logs:
        if "OK LOGIN" in log:
            successful_logins.inc()
        elif "FAILED LOGIN" in log:
            failed_logins.inc()

@app.route('/metrics')
def metrics():
    parse_vsftpd_logs()
    return str(successful_logins) + '\n' + str(failed_logins)

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=9100)
