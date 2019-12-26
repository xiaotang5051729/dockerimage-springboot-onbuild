#!/bin/bash

set -e

# ----------------------------------------------------------------------------------
# check spring-boot active profiles
# ----------------------------------------------------------------------------------

profiles="${APP_PROFILES}"

if [[ "${profiles}" == "" ]]; then
  profiles="${SPRING_PROFILES_ACTIVE}"
fi

if [[ "${profiles}" == "" ]]; then
  echo "[WARN] Environment 'APP_PROFILES' or 'SPRING_PROFILES_ACTIVE' is NOT set. Default to 'default'."
  export APP_PROFILES='default'
  export SPRING_PROFILES_ACTIVE='default'
else
  export APP_PROFILES="${profiles}"
  export SPRING_PROFILES_ACTIVE="${profiles}"
fi

# ----------------------------------------------------------------------------------
# check timezone, if not set. default to UTC
# ----------------------------------------------------------------------------------

tz="${APP_TIMEZONE}"

if [[ "$tz" == "APP_TZ" ]]; then
  tz="${APP_TZ}"
fi

if [[ "${tz}" == "" ]]; then
  echo "[WARN] Environment 'APP_TIMEZONE' or 'APP_TZ' is NOT set. Default to 'UTC'."
  export APP_TIMEZONE=UTC
  export APP_TZ=UTC
else
  export APP_TIMEZONE="${tz}"
  export APP_TZ="${tz}"
fi

# ----------------------------------------------------------------------------------
# check server port
# ----------------------------------------------------------------------------------

if [[ "${APP_SERVER_PORT}" != "" ]]; then
  echo "[INFO] Environment 'APP_SERVER_PORT' is set."
  server_port="--server.port=${APP_SERVER_PORT}"
else
  server_port=""
fi

# ----------------------------------------------------------------------------------
# check java options
# ----------------------------------------------------------------------------------
if [[ "${JAVA_OPTS}" != "" ]]; then
  echo "[INFO] Environment 'JAVA_OPTS' set. Value is = ${JAVA_OPTS}"
fi

# ----------------------------------------------------------------------------------
# call shells if the shell exists and execute permission is granted.
#  - /opt/app-init.sh
#  - /opt/app-init
#  - /opt/init.sh
#  - /opt/init
# ----------------------------------------------------------------------------------
if [[ -x "/opt/app-init.sh" ]]; then
  echo "[INFO] init shell: /opt/app-init.sh"
  /opt/app-init.sh
fi

if [[ -x "/opt/app-init" ]]; then
  echo "[INFO] init shell: /opt/app-init"
  /opt/app-init
fi

if [[ -x "/opt/init.sh" ]]; then
  echo "[INFO] init shell: /opt/init.sh"
  /opt/init.sh
fi

if [[ -x "/opt/init" ]]; then
  echo "[INFO] init shell: /opt/init"
  /opt/init
fi

# ----------------------------------------------------------------------------------
# show environment which start with 'APP_'
# ----------------------------------------------------------------------------------
echo "[INFO] Application environments:"
env | sed -n '/^APP_/p' | sort | xargs -I % echo "    %"

# ----------------------------------------------------------------------------------
# wait for other containers. (optional)
# ----------------------------------------------------------------------------------
if [[ "${APP_DOCKTOOL_WAIT_TIMEOUT}" == "" ]]; then
  docktool -q wait -e="APP_DOCKTOOL_WAIT_"
else
  docktool -q wait -e="APP_DOCKTOOL_WAIT_" -t="${APP_DOCKTOOL_WAIT_TIMEOUT}"
fi

# ----------------------------------------------------------------------------------
# startup the app
# ----------------------------------------------------------------------------------
exec java \
  -Djava.security.egd=file:/dev/./urandom \
  -Duser.timezone="${APP_TIMEZONE}" \
  -Djava.io.tmpdir=/var/tmp \
  -cp /opt/app.jar \
  -Dloader.path=/opt/lib \
  org.springframework.boot.loader.PropertiesLauncher \
  "${server_port}" \
  "${JAVA_OPTS}" \
  "$@"
