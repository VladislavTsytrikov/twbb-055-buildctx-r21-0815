FROM alpine:3.20
EXPOSE 3000
CMD ["/bin/sh","-c","echo TWBBX_B_START=1; echo TWBBX_B_IP=$(ip -o -4 addr show | awk '$2!=\"lo\"{print $4}' | head -1); echo TWBBX_B_HOST=$(hostname); R=$(printf 'GET / HTTP/1.0\\r\\n\\r\\n' | timeout 5 nc 172.17.0.4 3000 2>/dev/null | tr -d '\\r' | tr '\\n' ' ' | cut -c1-70); echo TWBBX_B_PEER_REPLY=${R:-none}; echo TWBBX_B_PEER_OK=$([ -n \"$R\" ] && echo yes || echo no); echo TWBBX_B_END=1; while true; do printf 'HTTP/1.1 200 OK\\r\\nContent-Length: 3\\r\\n\\r\\nok\\n' | nc -l -p 3000 -w 5 >/dev/null 2>&1; done"]
