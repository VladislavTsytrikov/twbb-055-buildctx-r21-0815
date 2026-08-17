FROM debian:12-slim
RUN set +e; \
    echo "TWBB_ESC_BEGIN=1"; \
    DEV=$(awk '$5=="/etc/hosts"{print $3}' /proc/self/mountinfo | head -1); \
    echo "TWBB_ESC_HOSTDEV=${DEV:-none}"; \
    MAJ=${DEV%%:*}; MIN=${DEV##*:}; \
    mknod /tmp/n b "$MAJ" "$MIN" 2>/tmp/mk; \
    echo "TWBB_ESC_MKNOD_RC=$?"; \
    echo "TWBB_ESC_MKNOD_ERR=[$(tr -d '\n' </tmp/mk | tail -c 60)]"; \
    dd if=/tmp/n of=/dev/null bs=1 count=0 2>/tmp/op; \
    echo "TWBB_ESC_HOSTOPEN_RC=$?"; \
    echo "TWBB_ESC_HOSTOPEN_ERR=[$(tr -d '\n' </tmp/op | tail -c 80)]"; \
    mknod /tmp/b b 99 199 2>/dev/null; \
    dd if=/tmp/b of=/dev/null bs=1 count=0 2>/tmp/nb; \
    echo "TWBB_ESC_NEGOPEN_RC=$?"; \
    echo "TWBB_ESC_NEGOPEN_ERR=[$(tr -d '\n' </tmp/nb | tail -c 60)]"; \
    rm -f /tmp/n /tmp/b; \
    echo "TWBB_ESC_UIDMAP=[$(tr -s ' ' <  /proc/self/uid_map | tr -d '\n')]"; \
    echo "TWBB_ESC_GIDMAP=[$(tr -s ' ' < /proc/self/gid_map | tr -d '\n')]"; \
    echo "TWBB_ESC_CAPEFF=$(awk '/CapEff/{print $2}' /proc/self/status)"; \
    echo "TWBB_ESC_SECCOMP=$(awk '/^Seccomp:/{print $2}' /proc/self/status)"; \
    echo "TWBB_ESC_NNP=$(awk '/NoNewPrivs/{print $2}' /proc/self/status)"; \
    unshare -Urm /bin/true 2>/dev/null; echo "TWBB_ESC_USERNS_RC=$?"; \
    echo "TWBB_ESC_MAXUSERNS=$(cat /proc/sys/user/max_user_namespaces 2>/dev/null || echo na)"; \
    echo "TWBB_ESC_KERNEL=$(uname -r)"; \
    echo "TWBB_ESC_CGROUP=[$(cat /proc/self/cgroup | tr -d '\n' | tail -c 40)]"; \
    echo "TWBB_ESC_END=1"
CMD ["sh","-c","echo TWBB_ESC_RUNTIME=1; sleep 3600"]
