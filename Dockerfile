FROM alpine:3.20
RUN set -u; \
  echo "TWBB8_W_START=1"; \
  echo "twbb-canary-3615141c3c4d115be520e060" > /tmp/twbb-canary-3615141c3c4d115be520e060.txt; \
  echo "TWBB8_W_WROTE=twbb-canary-3615141c3c4d115be520e060"; \
  echo "TWBB8_W_TMP_BEFORE=$(ls -1 /tmp 2>/dev/null | head -10 | tr '\n' ',')"; \
  echo "TWBB8_W_HOST=$(hostname)"; \
  echo "TWBB8_W_UPTIME=$(cut -d. -f1 /proc/uptime 2>/dev/null)"; \
  echo "TWBB8_W_BOOTID=$(cat /proc/sys/kernel/random/boot_id 2>/dev/null | cut -c1-8)"; \
  echo "TWBB8_W_END=1"
