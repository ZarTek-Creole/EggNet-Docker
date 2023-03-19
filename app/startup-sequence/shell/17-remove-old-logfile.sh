#!/bin/bash
if [ -f "${EGG_PATH_LOGS}/${EGG_LONG_NAME}.log" ]; then
    rm "${EGG_PATH_LOGS}/${EGG_LONG_NAME}.log"
fi
if [ -f "${EGG_PATH_LOGS}/${EGG_LONG_NAME}_screen.log" ]; then
    rm "${EGG_PATH_LOGS}/${EGG_LONG_NAME}_screen.log"
fi
if [ -f "${EGG_PATH_LOGS}/${EGG_LONG_NAME}_raw_io.log" ]; then
    rm "${EGG_PATH_LOGS}/${EGG_LONG_NAME}_raw_io.log"
fi
if [ -f "${EGG_PATH_LOGS}/${EGG_LONG_NAME}_error.log" ]; then
    rm "${EGG_PATH_LOGS}/${EGG_LONG_NAME}_error.log"
fi