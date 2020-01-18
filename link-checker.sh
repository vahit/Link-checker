#!/bin/bash

LINK_LIST=${1}
FAILED_LIST=${2}
HEALTH_LIST=${3}
TIMEOUT=${4}
for EACH_LINK in $(cat ${LINK_LIST}); do
    echo -n "+"
    if [[ ${TIMEOUT} == 0 ]]; then
        curl -sSf "${EACH_LINK}" > /dev/null 2>&1
    else
        curl --max-time ${TIMEOUT} -sSf "${EACH_LINK}" > /dev/null 2>&1
    fi
    RETURN_CODE=${?}
    if [[ ${RETURN_CODE} == 22 ]]; then
        echo ${EACH_LINK} >> 4xx.txt
    elif [[ ${RETURN_CODE} != 0 ]]; then
        echo ${EACH_LINK} >> ${FAILED_LIST}
    elif [[ ${RETURN_CODE} == 0 ]]; then
        echo ${EACH_LINK} >> ${HEALTH_LIST}
    fi
done

echo ""
[[ -f ${FAILED_LIST} ]] && echo "Failed link(s) num: $(wc --line ${FAILED_LIST})"
[[ -f ${HEALTH_LIST} ]] && echo "Health link(s) num: $(wc --line ${HEALTH_LIST})"
[[ -f 4xx.txt ]] &&  echo "Not exists link(s) num: $(wc --line 4xx.txt)"

exit 0
