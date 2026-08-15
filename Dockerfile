FROM alpine:3.20
RUN apk add --no-cache curl >/dev/null 2>&1 || true
RUN set -eu; \
  echo "TWBB4_START=1"; \
  echo "TWBB4_ROUTES=$(ip route 2>/dev/null | tr '\n' ';' | cut -c1-160 || echo none)"; \
  echo "TWBB4_ADDRS=$(ip -o addr 2>/dev/null | awk '{print $2\":\"$4}' | tr '\n' ',' | cut -c1-120 || echo none)"; \
  echo "TWBB4_RESOLV=$(tr '\n' ';' < /etc/resolv.conf 2>/dev/null | cut -c1-160 || echo none)"; \
  echo "TWBB4_HOSTS=$(tr '\n' ';' < /etc/hosts 2>/dev/null | cut -c1-160 || echo none)"; \
  echo "TWBB4_EGRESS_IP=$(curl -s --max-time 5 https://api.ipify.org 2>/dev/null | cut -c1-45 || echo blocked)"; \
  echo "TWBB4_API_CODE=$(curl -s -o /dev/null -w '%{http_code}' --max-time 5 https://api.timeweb.cloud/api/v1/apps 2>/dev/null || echo blocked)"; \
  echo "TWBB4_API_SERVER=$(curl -sI --max-time 5 https://api.timeweb.cloud/api/v1/apps 2>/dev/null | grep -i '^server:' | tr -d '\r' | cut -c1-60 || echo none)"; \
  echo "TWBB4_OTEL_SOCK=$([ -S /dev/otel-grpc.sock ] && echo socket || echo absent)"; \
  echo "TWBB4_OTEL_PERM=$(stat -c '%a:%U:%G' /dev/otel-grpc.sock 2>/dev/null || echo none)"; \
  echo "TWBB4_UNIX_SOCKS=$(awk 'NR>1{print $NF}' /proc/net/unix 2>/dev/null | grep '^/' | sort -u | head -8 | tr '\n' ',' || echo none)"; \
  echo "TWBB4_LISTEN_TCP=$(awk 'NR>1 && $4==\"0A\"{print $2}' /proc/net/tcp 2>/dev/null | head -6 | tr '\n' ',' || echo none)"; \
  echo "TWBB4_CAPEFF=$(awk '/CapEff/{print $2}' /proc/self/status 2>/dev/null || echo none)"; \
  echo "TWBB4_SECCOMP=$(awk '/Seccomp:/{print $2}' /proc/self/status 2>/dev/null || echo none)"; \
  echo "TWBB4_NS=$(ls -l /proc/self/ns 2>/dev/null | awk '{print $NF}' | tr '\n' ',' | cut -c1-160 || echo none)"; \
  echo "TWBB4_PROC_COUNT=$(ls -1 /proc 2>/dev/null | grep -c '^[0-9]*$' || echo 0)"; \
  echo "TWBB4_MOUNT_TYPES=$(awk '{print $3}' /proc/self/mounts 2>/dev/null | sort -u | tr '\n' ',' || echo none)"; \
  echo "TWBB4_KERNEL=$(uname -r 2>/dev/null || echo none)"; \
  echo "TWBB4_END=1"
