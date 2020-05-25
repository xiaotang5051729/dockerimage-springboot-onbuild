#!/bin/bash

set -e

# ----------------------------------------------------------------------------------
# check debug mode
# ----------------------------------------------------------------------------------
if [[ "${APP_DEBUG}" == "true" ]]; then
  debug_mode="--debug"
else
  debug_mode=""
fi

# ----------------------------------------------------------------------------------
# check spring-boot active profiles
# ----------------------------------------------------------------------------------
profiles="${APP_PROFILES}"

if [[ "${profiles}" == "" ]]; then
  profiles="${SPRING_PROFILES_ACTIVE}"
fi

if [[ "${profiles}" == "" ]]; then
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

if [[ "$tz" == "" ]]; then
  tz="${APP_TZ}"
fi

if [[ "${tz}" == "" ]]; then
  export APP_TIMEZONE=UTC
  export APP_TZ=UTC
else
  export APP_TIMEZONE="${tz}"
  export APP_TZ="${tz}"
fi

# ----------------------------------------------------------------------------------
# check language. default to english
# ----------------------------------------------------------------------------------
lang="${APP_LANG}"
if [[ "$lang" == "" ]]; then
  lang="en"
fi

# ----------------------------------------------------------------------------------
# check country. default to english
# ----------------------------------------------------------------------------------
country="${APP_COUNTRY}"
if [[ "$country" == "" ]]; then
  country="US"
fi

# ----------------------------------------------------------------------------------
# call shell if the shell exists and execute permission is granted.
#  - /home/spring/app-init.sh
# ----------------------------------------------------------------------------------
if [[ -x "/home/spring/app-init.sh" ]]; then
  /home/spring/app-init.sh
fi

# ----------------------------------------------------------------------------------
# wait for other containers. (optional)
#   see: https://github.com/yingzhuo/docktool
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
  -Duser.language="${lang}" \
  -Duser.country="${country}" \
  -Djava.io.tmpdir=/home/spring/tmp \
  -cp /home/spring/app.jar \
  -Dloader.path=/home/spring/lib \
  org.springframework.boot.loader.PropertiesLauncher \
  "${debug_mode}" \
  "${JAVA_OPTS}" \
  "$@"
