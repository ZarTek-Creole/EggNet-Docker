#!/bin/bash


sed -i 's@^loadmodule@#loadmodule@' ${EGG_PATH_CONF}/${EGG_LONG_NAME}.conf
for MODULES in $(echo ${EGG_MODULES_ENABLE})
do
	echo "s@#loadmodule ${MODULES}@loadmodule ${MODULES}@"
	sed -i "s@#loadmodule ${MODULES}@loadmodule ${MODULES}@" ${EGG_PATH_CONF}/${EGG_LONG_NAME}.conf
done