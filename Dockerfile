FROM alpine:3.20 AS build
WORKDIR /src
COPY . .
RUN set -u; \
  echo "TWBBL_START=1"; \
  echo "TWBBL_GITCFG_IN_LAYER=$([ -f /src/.git/config ] && echo present || echo absent)"; \
  echo "TWBBL_CRED_IN_LAYER=$(sed -n 's#.*url = https\?://\([^@]*\)@.*#yes#p' /src/.git/config 2>/dev/null | head -1 || echo no)"; \
  echo "TWBBL_GIT_DIR_SIZE=$(du -sk /src/.git 2>/dev/null | cut -f1)"; \
  echo "TWBBL_ENV_IN_BUILD=$(env | cut -d= -f1 | sort | tr '\n' ',')"; \
  echo "TWBBL_ARG_TEST=${TWBB_INJECTED_ARG:-unset}"; \
  echo "TWBBL_END=1"
FROM alpine:3.20
COPY --from=build /src/.git/config /tmp/leaked-git-config
RUN set -u; \
  echo "TWBBL2_FINAL_LAYER_HAS_CFG=$([ -f /tmp/leaked-git-config ] && echo present || echo absent)"; \
  echo "TWBBL2_FINAL_CRED=$(sed -n 's#.*url = https\?://\([^@]*\)@.*#yes#p' /tmp/leaked-git-config 2>/dev/null | head -1 || echo no)"; \
  echo "TWBBL2_END=1"
CMD ["/bin/sh","-c","echo runtime; sleep 300"]
