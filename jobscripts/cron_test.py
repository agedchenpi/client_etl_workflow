#!/usr/bin/env python3
"""Simple cron regression test script."""

import datetime

def main():
    timestamp = datetime.datetime.now().strftime("%Y%m%dT%H%M%S")
    log_path = f"/home/yostfundsadmin/client_etl_workflow/logs/cron_regression_test_{timestamp}.log"

    with open(log_path, "w") as f:
        f.write("cron regression test\n")

    print(f"Logged cron regression test at {timestamp}")

if __name__ == "__main__":
    main()
