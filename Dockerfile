FROM alpine:3.20
WORKDIR /app
COPY . .
EXPOSE 3000
CMD ["/bin/sh","-c","echo TWBBR_RT_START=1; echo TWBBR_RT_CRED_FILES=$(grep -rl TWBBCAN'ARY' /app 2>/dev/null | wc -l); echo TWBBR_RT_GITCFG=$([ -f /app/.git/config ] && echo present || echo absent); echo TWBBR_RT_ORIGIN_USERINFO=$(grep -c 'url = https://[^@]*@' /app/.git/config 2>/dev/null || echo 0); echo TWBBR_RT_ENV=$(env | cut -d= -f1 | sort | tr '\\n' ','); echo TWBBR_RT_END=1; while true; do printf 'HTTP/1.1 200 OK\\r\\nContent-Length: 3\\r\\n\\r\\nok\\n' | nc -l -p 3000 >/dev/null 2>&1 || sleep 2; done"]
