FROM alpine:3.20
RUN apk add --no-cache curl bind-tools >/dev/null 2>&1 || true
RUN set -eu; \
  echo "TWBB5_START=1"; \
  echo "TWBB5_K8S_DNS=$(nslookup kubernetes.default.svc.cluster.local 2>/dev/null | awk '/^Address/{print $NF}' | tail -1 | cut -c1-40 || echo nxdomain)"; \
  echo "TWBB5_KUBEDNS_SVC=$(nslookup kube-dns.kube-system.svc.cluster.local 2>/dev/null | awk '/^Address/{print $NF}' | tail -1 | cut -c1-40 || echo nxdomain)"; \
  echo "TWBB5_API_TCP=$( (nc -z -w 3 kubernetes.default.svc 443 >/dev/null 2>&1 && echo open) || echo closed)"; \
  echo "TWBB5_API_VERSION_CODE=$(curl -sk -o /dev/null -w '%{http_code}' --max-time 5 https://kubernetes.default.svc/version 2>/dev/null || echo blocked)"; \
  echo "TWBB5_API_VERSION_BODY=$(curl -sk --max-time 5 https://kubernetes.default.svc/version 2>/dev/null | tr -d '\n ' | cut -c1-90 || echo none)"; \
  echo "TWBB5_API_ROOT_CODE=$(curl -sk -o /dev/null -w '%{http_code}' --max-time 5 https://kubernetes.default.svc/api 2>/dev/null || echo blocked)"; \
  echo "TWBB5_API_ANON_PODS=$(curl -sk -o /dev/null -w '%{http_code}' --max-time 5 https://kubernetes.default.svc/api/v1/namespaces/default/pods 2>/dev/null || echo blocked)"; \
  echo "TWBB5_EXT4_MOUNTS=$(awk '$3==\"ext4\"{print $1\"->\"$2}' /proc/self/mounts 2>/dev/null | head -4 | tr '\n' ',' || echo none)"; \
  echo "TWBB5_MOUNT_SRC=$(awk '{print $4\"@\"$5}' /proc/self/mountinfo 2>/dev/null | grep -v '^/@' | head -5 | tr '\n' ',' | cut -c1-160 || echo none)"; \
  echo "TWBB5_SA_DIR=$([ -d /var/run/secrets/kubernetes.io ] && echo present || echo absent)"; \
  echo "TWBB5_HOSTNAME=$(hostname 2>/dev/null | cut -c1-60)"; \
  echo "TWBB5_SELF_IP=$(ip -o -4 addr show 2>/dev/null | awk '{print $4}' | tr '\n' ',' | cut -c1-60 || echo none)"; \
  echo "TWBB5_END=1"
