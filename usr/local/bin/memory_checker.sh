#!/bin/bash

# Thresholds in MB
LOWER_THRESHOLD=2048
UPPER_THRESHOLD=5120

# Loop interval in sec
INTERVAL=30

# Flags for alerting
alerted_upper=false
alerted_lower=false

while :; do
  free=$(free -m | awk '/^Mem:/{print $4}')
  available=$(free -m | awk '/^Mem:/{print $7}')

  message="Free ${free}MB, available ${available}MB"

  if [[ ${available} -lt ${UPPER_THRESHOLD} && ${alerted_upper} == false ]]; then
    echo "Soft alert"
    notify-send "Memory is running out!" "${message}"
    alerted_upper=true
  elif [[ ${available} -ge ${UPPER_THRESHOLD} ]]; then
    alerted_upper=false
  fi

  if [[ ${available} -lt ${LOWER_THRESHOLD} && ${alerted_lower} == false ]]; then
    echo "Hard alert"
    zenity --warning --text "Memory is critically low \n${message}"
    alerted_lower=true
  elif [[ ${available} -ge ${LOWER_THRESHOLD} ]]; then
    alerted_lower=false
  fi

  echo "${message}"

  sleep ${INTERVAL}
done
