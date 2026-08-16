FROM alpine:3.20 AS build
WORKDIR /src
COPY . .
RUN set -u; \
  echo "TWBBC_START=1"; \
  echo "TWBBC_ORIGIN_HAS_USERINFO=$(grep -c 'url = https://[^@]*@' /src/.git/config 2>/dev/null || echo 0)"; \
  echo "TWBBC_CANARY_IN_GITCFG=$(grep -c 'TWBBCANARY' /src/.git/config 2>/dev/null || echo 0)"; \
  echo "TWBBC_CANARY_ANYWHERE=$(grep -rc 'TWBBCANARY' /src 2>/dev/null | awk -F: '{s+=$2} END{print s+0}')"; \
  echo "TWBBC_CRED_SHA=$(sed -n 's#.*url = https\?://\([^@]*\)@.*#\1#p' /src/.git/config 2>/dev/null | head -1 | sha256sum | cut -c1-16)"; \
  echo "TWBBC_END=1"
FROM alpine:3.20
COPY --from=build /src/.git/config /app/.git-config-copy
RUN set -u; \
  echo "TWBBC2_FINAL_CANARY=$(grep -c 'TWBBCANARY' /app/.git-config-copy 2>/dev/null || echo 0)"; \
  echo "TWBBC2_END=1"
CMD ["/bin/sh","-c","echo alive; sleep 200"]
