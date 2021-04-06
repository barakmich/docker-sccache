#!/bin/bash

DIST_PROCESS=${DIST_PROCESS:-"server"}
HOSTADDR=${HOSTADDR:-""}
PORT=${PORT:-""}
CONFIG_FILE=${CONFIG_FILE:-"/config/${DIST_PROCESS}.conf"}
OUTPUT_CONFIG_FILE=${OUTPUT_CONFIG_FILE:-"/etc/sccache-${DIST_PROCESS}.conf"}

VALID=1

case $DIST_PROCESS in
  server|scheduler) VALID=1;;
  *) VALID=0;;
esac

if [ "$VALID" -eq "0" ]; then
  echo "DIST_PROCESS must be one of [server|scheduler]"
  return 1
fi

if [ -z "$PORT" ]; then
  case $DIST_PROCESS in
    server) PORT="10501";;
    scheduler) PORT="10600";;
  esac
fi

if [ -z "$HOSTADDR" ]; then
  echo "Must provide \$HOSTADDR"
  return 1
fi

cp $CONFIG_FILE $OUTPUT_CONFIG_FILE
sed -i 's!\$\$HOSTADDR\$\$!'"${HOSTADDR}"'!g' $OUTPUT_CONFIG_FILE
sed -i 's!\$\$PORT\$\$!'"${PORT}"'!g' $OUTPUT_CONFIG_FILE

cat $OUTPUT_CONFIG_FILE

/usr/local/bin/sccache-dist $DIST_PROCESS --config $OUTPUT_CONFIG_FILE

