FROM alpine:3.20
RUN mkdir -p /www && echo "TWBBRT-0b2f687ed78f2136" > /www/index.html
EXPOSE 3000
CMD ["/bin/sh","-c","echo TWBBR_A_START=1; echo TWBBR_A_IP=$(ip -o -4 addr show | awk '$2!=\"lo\"{print $4}' | head -1); echo TWBBR_A_HOST=$(hostname); httpd -f -p 3000 -h /www"]
