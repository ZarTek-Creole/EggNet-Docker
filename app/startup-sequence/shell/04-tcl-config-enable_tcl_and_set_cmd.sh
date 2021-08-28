#!/bin/bash
# Active .tcl and .set
sed -i 's@#unbind dcc n tcl \*dcc:tcl@bind dcc n tcl *dcc:tcl@' ${EGG_PATH_CONF}/${EGG_LONG_NAME}.conf
sed -i 's@#unbind dcc n set \*dcc:set@bind dcc n set *dcc:set@' ${EGG_PATH_CONF}/${EGG_LONG_NAME}.conf
sed -i 's@set must-be-owner 1@set must-be-owner 0@' ${EGG_PATH_CONF}/${EGG_LONG_NAME}.conf