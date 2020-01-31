#!/bin/bash
set -o errexit
set -o nounset
set -o pipefail
#set -o xtrace
#shellcheck disable=SC1091

#if [[ "$*" = *"/run.sh"* ]]; then
#    info "** Starting Handle.net server **"
#    /setup.sh
#    touch "$POSTGRESQL_TMP_DIR"/.initialized
#    info "** PostgreSQL setup finished! **"
#fi

echo ""
exec "$@"