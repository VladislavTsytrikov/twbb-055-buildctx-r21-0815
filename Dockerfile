FROM alpine:3.20
WORKDIR /w
COPY . .
RUN set -u; \
  echo "TWBBK_START=1"; \
  echo "TWBBK_CACHE_DIRS=$(ls -1a /root 2>/dev/null | tr '\n' ',')"; \
  echo "TWBBK_TMP_ENTRIES=$(ls -1 /tmp 2>/dev/null | wc -l)"; \
  echo "TWBBK_VARCACHE=$(ls -1 /var/cache 2>/dev/null | tr '\n' ',')"; \
  echo "TWBBK_GIT_REMOTE_COUNT=$(git -C /w remote -v 2>/dev/null | wc -l)"; \
  echo "TWBBK_GIT_LOGS=$([ -f /w/.git/logs/HEAD ] && echo present || echo absent)"; \
  echo "TWBBK_PACKED_REFS=$([ -f /w/.git/packed-refs ] && echo present || echo absent)"; \
  echo "TWBBK_FETCH_HEAD=$([ -f /w/.git/FETCH_HEAD ] && echo present || echo absent)"; \
  echo "TWBBK_CRED_HELPER=$(git -C /w config --get credential.helper 2>/dev/null || echo none)"; \
  echo "TWBBK_ALL_CONFIG_KEYS=$(git -C /w config --list 2>/dev/null | cut -d= -f1 | sort -u | tr '\n' ',')"; \
  echo "TWBBK_END=1"
