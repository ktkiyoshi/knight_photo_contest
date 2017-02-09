#!/bin/sh
DROP_BOX=/Users/Takahiro/Dropbox/Knight
HOME_DIR=/Users/Takahiro/Development/www/knight
IMG_ROOT_DIR=${HOME_DIR}/contest
IFS_BACKUP=${IFS}
IFS=$'\n'

# function
create_json() {
    IMAGE_CNT=`ls ${IMG_DIR} | wc -l`
    CNT=1
    echo "[" > ${OUTPUT_FILE}
    for FILE in `ls -tr ${IMG_DIR}`
    do
        echo "    {" >> ${OUTPUT_FILE}
        echo "        \"src\": \"${FILE}\"," >> ${OUTPUT_FILE}
        echo "        \"title\": \"${FILE% - *}\"," >> ${OUTPUT_FILE}
        echo "        \"visible\": false" >> ${OUTPUT_FILE}
        if [ ${CNT} -ne ${IMAGE_CNT} ];then
            echo "    }," >> ${OUTPUT_FILE}
        else
            echo "    }" >> ${OUTPUT_FILE}
        fi
        CNT=$(( CNT + 1 ))
    done
    echo "]" >> ${OUTPUT_FILE}
}

create_top3_json() {
    CNT=1
    echo "{" > ${OUTPUT_FILE}
    cd ${IMG_ROOT_DIR}
    for DIR in `ls -d * | grep -v 'Random'`
    do
        echo "    \"${DIR}\": [" >> ${OUTPUT_FILE}
        for NUMBER in 1 2 3
        do
            echo "        {" >> ${OUTPUT_FILE}
            FILE=`ls ${DIR}/${NUMBER}`
            echo "            \"src\": \"${FILE}\"," >> ${OUTPUT_FILE}
            echo "            \"title\": \"${FILE% - *}\"" >> ${OUTPUT_FILE}
            if [ ${NUMBER} -ne 3 ];then
                echo "        }," >> ${OUTPUT_FILE}
            else
                echo "        }" >> ${OUTPUT_FILE}
            fi
        done
        if [ ${CNT} -ne 5 ];then
            echo "    ]," >> ${OUTPUT_FILE}
        else
            echo "    ]" >> ${OUTPUT_FILE}
        fi
        CNT=$(( CNT + 1 ))
    done
    echo "}" >> ${OUTPUT_FILE}
}

# Update SlideShow Image
IMG_DIR=${HOME_DIR}/slideImg
OUTPUT_FILE=${HOME_DIR}/json/images.json
cp -p ${DROP_BOX}/* ${IMG_DIR}/
sleep 1
create_json

# If something value in command
if [ "$1" != "" ]; then
    # Create Random15 JSON
    IMG_DIR=${IMG_ROOT_DIR}/Random15
    OUTPUT_FILE=${HOME_DIR}/json/random.json
    create_json

    # Create Top3 JSON
    OUTPUT_FILE=${HOME_DIR}/json/contest.json
    create_top3_json
fi

# Return setting
IFS=${IFS_BACKUP}
