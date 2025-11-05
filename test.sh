#!/bin/bash

PROCESS="test"
STATE_FILE="/var/tmp/test_last_pid"
LOG="/var/log/monitoring.log"
URL="https://test.com/monitoring/test/api"

# ищем pid процесса
PID=$(pgrep -x "$PROCESS" | head -n1)

# если процесса нет то выход
if [ -z "$PID" ]; then
  exit 0
fi

# проверяем если пид процесса поменялся значит был перезапуск
if [ -f "$STATE_FILE" ]; then
  LAST_PID=$(cat "$STATE_FILE")
  if [ "$LAST_PID" != "$PID" ]; then
    echo "$(date '+%Y-%m-%d %H:%M:%S') [monitor] process '$PROCESS' restarted: old_pid=$LAST_PID new_pid=$PID" >> "$LOG"
  fi
fi

# сохраняем текущий PID
echo "$PID" > "$STATE_FILE"

# стучимся на URL
curl -sS -m 10 -f "$URL" > /dev/null
if [ $? -ne 0 ]; then
  echo "$(date '+%Y-%m-%d %H:%M:%S') [monitor] monitoring endpoint unavailable: $URL" >> "$LOG"
fi
