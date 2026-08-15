FROM alpine:3.20
RUN set -u; \
  echo "TWBB9_R_START=1"; \
  echo "TWBB9_R_NONCE=1786812509-reader"; \
  echo "TWBB9_R_CANARY_SEEN=$([ -f /tmp/twbb-canary-3615141c3c4d115be520e060.txt ] && echo yes || echo no)"; \
  echo "TWBB9_R_TMP_LIST=$(ls -1 /tmp 2>/dev/null | head -12 | tr '\n' ',')"; \
  echo "TWBB9_R_TMP_COUNT=$(ls -1 /tmp 2>/dev/null | wc -l)"; \
  echo "TWBB9_R_FOREIGN_CANARIES=$(ls -1 /tmp 2>/dev/null | grep -c 'twbb-canary' || echo 0)"; \
  echo "TWBB9_R_BOOTID=$(cat /proc/sys/kernel/random/boot_id 2>/dev/null | cut -c1-8)"; \
  echo "TWBB9_R_UPTIME=$(cut -d. -f1 /proc/uptime 2>/dev/null)"; \
  echo "TWBB9_R_HOST=$(hostname)"; \
  echo "TWBB9_R_IP=$(ip -o -4 addr show 2>/dev/null | awk '$2!="lo"{print $4}' | head -1)"; \
  echo "TWBB9_R_END=1"
