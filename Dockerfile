FROM alpine:3.20 AS build
WORKDIR /src
COPY . .
RUN set -u; \
  echo "TWBBF_START=1"; \
  echo "TWBBF_FILES=$(grep -rl 'TWBBCANARY' /src 2>/dev/null | sed 's#^/src/##' | tr '\n' ',')"; \
  echo "TWBBF_COUNT=$(grep -rl 'TWBBCANARY' /src 2>/dev/null | wc -l)"; \
  echo "TWBBF_END=1"
FROM alpine:3.20
COPY --from=build /src /app
RUN set -u; \
  echo "TWBBF2_RUNTIME_FILES=$(grep -rl 'TWBBCANARY' /app 2>/dev/null | sed 's#^/app/##' | tr '\n' ',')"; \
  echo "TWBBF2_RUNTIME_COUNT=$(grep -rl 'TWBBCANARY' /app 2>/dev/null | wc -l)"; \
  echo "TWBBF2_END=1"
CMD ["/bin/sh","-c","echo TWBBF3_RUNTIME_ALIVE=1; echo TWBBF3_RUNTIME_CANARY=$(grep -rl TWBBCANARY /app 2>/dev/null | wc -l); sleep 240"]
