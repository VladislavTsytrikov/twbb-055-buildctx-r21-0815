FROM alpine:3.20
RUN set -u; \
  echo "TWBB7_A_START=1"; \
  echo "TWBB7_A_IP=$(ip -o -4 addr show 2>/dev/null | awk '$2!="lo"{print $4}' | head -1)"; \
  echo "TWBB7_A_HOST=$(hostname)"; \
  echo "TWBB7_A_LISTENING=1"; \
  (timeout 200 nc -l -p 8080 > /tmp/hit.txt 2>/dev/null || true); \
  echo "TWBB7_A_PEER_BYTES=$(wc -c < /tmp/hit.txt 2>/dev/null || echo 0)"; \
  echo "TWBB7_A_PEER_DATA=$(head -c 40 /tmp/hit.txt 2>/dev/null | tr -d '\n' || echo none)"; \
  echo "TWBB7_A_END=1"
