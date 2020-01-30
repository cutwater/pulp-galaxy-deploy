#!/bin/bash

# NOTE: This line should be before setting bash modes, because
# `scl_source` is not compatible with `set -o nounset`.
ENABLED_COLLECTIONS="${ENABLED_COLLECTIONS:-}"
if [[ ! -z "${ENABLED_COLLECTIONS}" ]]; then
  source scl_source enable ${ENABLED_COLLECTIONS}
fi

set -o nounset
set -o errexit
set -o pipefail


_wait_tcp_port() {
  local -r host="$1"
  local -r port="$2"

  local attempts=6
  local timeout=1

  echo "[debug]: Waiting for port tcp://${host}:${port}"
  while [ $attempts -gt 0 ]; do
    timeout 1 /bin/bash -c ">/dev/tcp/${host}/${port}" &>/dev/null && return 0 || :

    echo "[debug]: Waiting ${timeout} seconds more..."
    sleep $timeout

    timeout=$(( $timeout * 2 ))
    attempts=$(( $attempts - 1 ))
  done

  echo "[error]: Port tcp://${host}:${port} is not available"
  return 1
}

run_pulp_galaxy() {
  exec django-admin runserver "0.0.0.0:8000"
}

run_pulp_resource_manager() {
  exec rq worker \
      -w 'pulpcore.tasking.worker.PulpWorker' \
      -n 'resource-manager' \
      -c 'pulpcore.rqconfig' \
      --pid='/var/run/pulp/resource-manager.pid'
}

run_pulp_worker() {
  exec rq worker \
      -w 'pulpcore.tasking.worker.PulpWorker' \
      -c 'pulpcore.rqconfig' \
      --pid="/var/run/pulp/worker.pid"
}

run_pulp_content_app() {
  exec pulp-content
}

run_service() {
  local cmd
  case "$1" in
    'pulp-galaxy')
      cmd='run_pulp_galaxy'
      ;;
    'pulp-resource-manager')
      cmd='run_pulp_resource_manager'
      ;;
    'pulp-worker')
      cmd='run_pulp_worker'
      ;;
    'pulp-content-app')
      cmd='run_pulp_content_app'
      ;;
    *)
      echo "ERROR: Unexpected argument '$1'." >&2
      return 1
      ;;
    esac

  _wait_tcp_port "${PULP_DB_HOST:-localhost}" "${PULP_DB_PORT:-5432}"
  pip install -e "/app"
  django-admin migrate
  ${cmd}
}

run_manage() {
  pip install -e "/app"
  exec django-admin "$@"
}

main() {
  if [[ "$#" -eq 0 ]]; then
    exec "/bin/bash"
  fi

  case "$1" in
    'run')
      run_service "${@:2}"
      ;;
    'manage')
      run_manage "${@:2}"
      ;;
    *)
      exec "$@"
      ;;
    esac
}


main "$@"
