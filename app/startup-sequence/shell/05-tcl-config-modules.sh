#!/bin/bash

# ---- Start unofficial bash strict mode boilerplate
# http://redsymbol.net/articles/unofficial-bash-strict-mode/
set -o errexit  # always exit on error
set -o errtrace # trap errors in functions as well
set -o pipefail # don't ignore exit codes when piping output
set -o posix    # more strict failures in subshells
# set -x          # enable debugging

IFS="$(printf "\n\t")"
# ---- End unofficial bash strict mode boilerplate
sed -i 's@^loadmodule@#loadmodule@' "${EGG_PATH_CONF}/${EGG_LONG_NAME}.conf"
for MODULES in "${EGG_MODULES_ENABLE}"; do
	echo "s@#loadmodule ${MODULES}@loadmodule ${MODULES}@"
	sed -i "s@#loadmodule ${MODULES}@loadmodule ${MODULES}@" "${EGG_PATH_CONF}/${EGG_LONG_NAME}.conf"
done
