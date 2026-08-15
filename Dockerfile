FROM alpine:3.20
EXPOSE 3000
CMD ["/bin/sh","-c","echo TWBB_RT_START=1; echo TWBB_RT_IP=$(ip -o -4 addr show | awk '$2!=\"lo\"{print $4}' | head -1); echo TWBB_RT_HOST=$(hostname); while true; do printf 'HTTP/1.1 200 OK\\r\\nContent-Length: 14\\r\\n\\r\\nTWBB_RT_ALIVE\\n' | nc -l -p 3000 -w 5 >/dev/null 2>&1; echo TWBB_RT_HIT=$(date -u +%s); done"]
