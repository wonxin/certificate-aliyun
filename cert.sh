#!/bin/bash

WORKDIR=$(dirname "$0")
cd ${WORKDIR}

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
    docker-compose -f docker-compose.yml run --rm certbot
    ;;
  renew)
    docker-compose -f docker-compose.yml run --rm certbot renew \
        --manual --preferred-challenges dns --manual-auth-hook /opt/scripts/au.sh
    ;;
  new)
    shift 1

    case "$1" in
      -d)
        DOMAIN_NAME="$2"
        shift 2

        docker-compose -f docker-compose.yml run --rm certbot certonly -d *.${DOMAIN_NAME} \
          --manual -preferred-challenges dns --manual-auth-hook /opt/scripts/au.sh
        ;;
      *)
        echo -e "Error, Require domain parameter.\n"
        usage
        exit 1
        ;;
    esac
    ;;
  -h | --help)
    usage
    ;;
  *)
    docker-compose -f docker-compose.yml run --rm certbot
    ;;
esac

