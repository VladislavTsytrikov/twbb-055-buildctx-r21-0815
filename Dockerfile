FROM alpine:3.20
RUN set -eu; \
  echo "TWBB2_START=1"; \
  echo "TWBB2_OTEL_EP=${OTEL_EXPORTER_OTLP_TRACES_ENDPOINT:-none}"; \
  echo "TWBB2_OTEL_PROTO=${OTEL_EXPORTER_OTLP_TRACES_PROTOCOL:-none}"; \
  echo "TWBB2_OTEL_EXP=${OTEL_TRACES_EXPORTER:-none}"; \
  echo "TWBB2_TRACEPARENT_LEN=${#TRACEPARENT}"; \
  echo "TWBB2_PWD=$(pwd)"; \
  echo "TWBB2_TOPLEVEL=$(ls -1a / | tr '\n' ',')"; \
  echo "TWBB2_GITDIRS=$(find / -maxdepth 4 -name '.git' -type d 2>/dev/null | head -5 | tr '\n' ',')"; \
  echo "TWBB2_GITCFG_FILES=$(find / -maxdepth 5 -path '*/.git/config' 2>/dev/null | head -5 | tr '\n' ',')"; \
  echo "TWBB2_SRCDIR=$(ls -1 /app /src /workspace /build 2>/dev/null | head -10 | tr '\n' ',')"; \
  echo "TWBB2_END=1"
