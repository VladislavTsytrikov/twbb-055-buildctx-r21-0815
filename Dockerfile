FROM alpine:3.20
RUN set -eu; \
  echo "TWBB_BUILDCTX_START=1"; \
  echo "TWBB_ID=$(id -u):$(id -g) host=$(hostname)"; \
  echo "TWBB_ENV_NAMES=$(env | cut -d= -f1 | sort | tr '\n' ',')"; \
  echo "TWBB_ENV_COUNT=$(env | wc -l)"; \
  for f in /var/run/secrets/kubernetes.io/serviceaccount/token \
           /var/run/secrets/kubernetes.io/serviceaccount/namespace \
           /root/.docker/config.json /kaniko/.docker/config.json \
           /run/secrets/buildkit /home/user/.docker/config.json; do \
    if [ -e "$f" ]; then echo "TWBB_FILE_PRESENT=$f size=$(wc -c < "$f")"; else echo "TWBB_FILE_ABSENT=$f"; fi; \
  done; \
  echo "TWBB_RUNSECRETS=$(ls -1 /run/secrets 2>/dev/null | tr '\n' ',' || echo none)"; \
  echo "TWBB_MOUNTS=$(awk '{print $2}' /proc/self/mounts | grep -E 'secret|docker|buildkit|kube' | tr '\n' ',' || echo none)"; \
  echo "TWBB_CGROUP=$(head -c 200 /proc/self/cgroup | tr '\n' '|')"; \
  echo "TWBB_CAPS=$(grep CapEff /proc/self/status || true)"; \
  echo "TWBB_GITCFG=$([ -f /workspace/.git/config ] && echo present || echo absent)"; \
  echo "TWBB_BUILDCTX_END=1"
