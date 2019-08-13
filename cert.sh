#!/bin/bash

# get work path
cd $(dirname "$0")
WORKDIR=$(pwd)

# get aliyun access id & key
source aliyun_access_key

# docker run args
DOCKER_RUN="docker run --rm \
  -v ${WORKDIR}/data/:/etc/letsencrypt/ \
  -v ${WORKDIR}/scripts/:/opt/scripts/ \
  -e ACCESS_KEY_ID=${ALY_KEY_ID} \
  -e ACCESS_KEY_SECRET=${ALY_KEY_SECRET} \
  certbot/certbot:latest"

# usage
function usage() {
  echo "Usage: cert.sh COMMAND [OPTIONS] ..."
  echo -e "  - list, renew, new let's encrypt certificate.\n"

  echo "Commands:"
  echo -e "  list\t\t\tList present certificates"
  echo -e "  renew\t\t\tRenew certificates"
  echo -e "  new -d <domain>\tRequest new certificates"
  echo -e "  help,-h,--help\tHelp information"
}

case "$1" in
  list)
    ${DOCKER_RUN} certificates
    ;;
  renew)
    ${DOCKER_RUN} renew \
        --manual --preferred-challenges dns --manual-auth-hook /opt/scripts/au.sh
    ;;
  new)
    shift 1

    case "$1" in
      -d)
        DOMAIN_NAME="$2"
        shift 2

        ${DOCKER_RUN} certonly \
          -d *.${DOMAIN_NAME} --manual -preferred-challenges dns --manual-auth-hook /opt/scripts/au.sh
        ;;
      *)
        echo -e "Error, Require domain parameter.\n"
        usage
        exit 1
        ;;
    esac
    ;;
  -h | --help | help)
    usage
    ;;
  *)
    ${DOCKER_RUN} certificates
    ;;
esac

