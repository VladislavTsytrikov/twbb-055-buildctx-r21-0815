FROM alpine:3.20
RUN apk add --no-cache curl >/dev/null 2>&1 || true
EXPOSE 3000
CMD ["/bin/sh","-c","echo TWBBE_START=1; T=\"$TWBB_ACCOUNT_TOKEN\"; echo TWBBE_ENV_TOKEN_PRESENT=$([ -n \"$T\" ] && echo yes || echo no); echo TWBBE_ENV_TOKEN_LEN=${#T}; A='https://api.timeweb.cloud/api/v1'; for ep in account/status account/finances account/payments/docs apps databases; do C=$(curl -s -o /tmp/r -w '%{http_code}' --max-time 8 -H \"Authorization: Bearer $T\" \"$A/$ep\"); B=$(wc -c < /tmp/r 2>/dev/null); N=$(tr ',' '\\n' < /tmp/r 2>/dev/null | grep -c ':'); echo TWBBE_$(echo $ep | tr '/a-z' '_A-Z')=code:$C,bytes:$B,fields:$N; done; echo TWBBE_END=1; while true; do printf 'HTTP/1.1 200 OK\\r\\nContent-Length: 3\\r\\n\\r\\nok\\n' | nc -l -p 3000 >/dev/null 2>&1 || sleep 3; done"]
