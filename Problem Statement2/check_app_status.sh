#!/bin/bash


URL="http://huzaif-shah.live.com"


LOG_FILE="/var/log/application_uptime.log"


check_application_status() {

    HTTP_STATUS=$(curl -o /dev/null -s -w "%{http_code}" $URL)

    if [[ "$HTTP_STATUS" =~ ^[23] ]]; then
        echo "$(date): Application is UP. HTTP Status: $HTTP_STATUS" | tee -a $LOG_FILE
    else
        echo "$(date): ALERT: Application is DOWN. HTTP Status: $HTTP_STATUS" | tee -a $LOG_FILE
    fi
}

check_application_status
