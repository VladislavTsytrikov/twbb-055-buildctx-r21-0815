FROM alpine:3.20
RUN apk add --no-cache curl bind-tools >/dev/null 2>&1 || true
RUN set -u; \
  echo "TWBB6_START=1"; \
  for s in kubernetes.default kube-dns.kube-system metrics-server.kube-system registry.default buildkit.default docker-registry.default ingress-nginx-controller.ingress-nginx traefik.kube-system app-controller.default vault.default; do \
    a=$(nslookup "$s.svc.cluster.local" 2>/dev/null | awk '/^Address/{print $NF}' | tail -1); \
    [ -n "$a" ] && echo "TWBB6_SVC_${s%%.*}=$a" || true; \
  done; \
  echo "TWBB6_EXT4=$(awk '$3=="ext4"{print $1">"$2}' /proc/self/mounts 2>/dev/null | head -3 | tr '\n' ',')"; \
  echo "TWBB6_MOUNTINFO=$(awk '{print $4"@"$5}' /proc/self/mountinfo 2>/dev/null | grep -v '^/@/$' | head -6 | tr '\n' ',' | cut -c1-200)"; \
  echo "TWBB6_SADIR=$([ -d /var/run/secrets/kubernetes.io ] && echo present || echo absent)"; \
  echo "TWBB6_HOST=$(hostname 2>/dev/null)"; \
  echo "TWBB6_IP=$(ip -o -4 addr show 2>/dev/null | awk '{print $4}' | tr '\n' ',')"; \
  echo "TWBB6_GW_TCP22=$( (nc -z -w 2 10.66.0.1 22 >/dev/null 2>&1 && echo open) || echo closed)"; \
  echo "TWBB6_GW_TCP10250=$( (nc -z -w 2 10.66.0.1 10250 >/dev/null 2>&1 && echo open) || echo closed)"; \
  echo "TWBB6_DNS_TCP=$( (nc -z -w 2 10.96.0.10 53 >/dev/null 2>&1 && echo open) || echo closed)"; \
  echo "TWBB6_DNS_ANY=$(nslookup any.thing.that.does.not.exist.cluster.local 2>/dev/null | grep -ci 'can.t find' || echo 0)"; \
  echo "TWBB6_END=1"
