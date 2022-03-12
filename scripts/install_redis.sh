#!/bin/bash
set -e

CURRENT_DIR=$( cd "$(dirname "${BASH_SOURCE[0]}")" ; pwd -P )
source ${CURRENT_DIR}/../common/common.sh
source ${CURRENT_DIR}/../common/library.sh

call_function "installing: redis" install_redis