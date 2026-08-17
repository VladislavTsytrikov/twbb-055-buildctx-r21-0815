FROM debian:12-slim
RUN apt-get update -qq && apt-get install -y -qq default-mysql-client >/dev/null 2>&1
CMD sh -c '\
  echo "TWBB_DB_BEGIN=1"; \
  OUT=$(mysql -h "$DB_HOST" -P 3306 -u "$DB_USER" -p"$DB_PASS" -N -B \
        -e "SELECT CONCAT(\"TWBB_DB_VERSION=\",VERSION()); SELECT CONCAT(\"TWBB_DB_USER=\",CURRENT_USER());" 2>&1 | tr "\n" " "); \
  echo "TWBB_DB_CONNECT_RC=$?"; \
  echo "TWBB_DB_RESULT=[$(echo "$OUT" | tail -c 140)]"; \
  BAD=$(mysql -h "$DB_HOST" -P 3306 -u "$DB_USER" -pwrongpass000 -N -B -e "SELECT 1" 2>&1 | tr "\n" " "); \
  echo "TWBB_DB_NEG_RC=$?"; \
  echo "TWBB_DB_NEG=[$(echo "$BAD" | tail -c 90)]"; \
  echo "TWBB_DB_END=1"; \
  sleep 3600'
