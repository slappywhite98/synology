#!/bin/bash
export LFTP_HOME="/config"

REMOTE_MOVIES_DIR=${REMOTE_MOVIES_DIR:-"files/complete/movie/radarr/"}
LOCAL_MOVIES_TEMP_DIR="/downloads/incomplete/movies"
LOCAL_MOVIES_DIR="/downloads/movies"

REMOTE_TV_DIR=${REMOTE_TV_DIR:-"files/complete/tv/sonarr/"}
LOCAL_MOVIES_TEMP_DIR="/downloads/incomplete/movies"
LOCAL_TV_DIR="/downloads/tv"

base_name=$(basename "$0")
lock_file="/config/${base_name}.lock"

trap "rm -f ${lock_file}; exit 0" SIGINT SIGTERM
if [ -e "${lock_file}" ]
then
    echo "${base_name} is running already."
    exit
else
    touch "${lock_file}"
    # Bookmark with name 'host' should be stored in ~/.local/share/lftp/bookmarks in the form
    # host    ftp://<username>:<password>@<host>/
    lftp bm:host << EOF
    set log:enabled/xfer yes
    set xfer:use-temp-file yes
    set xfer:temp-file-name *.lftp
    set ftp:ssl-allow no
    set mirror:use-pget-n 5
    mirror -v -c -P5 --verbose --no-empty-dirs --no-umask --Remove-source-files --Remove-source-dirs "${REMOTE_MOVIES_DIR}" "${LOCAL_MOVIES_TEMP_DIR}"
    mirror -v -c -P5 --verbose --no-empty-dirs --no-umask --Remove-source-files --Remove-source-dirs "${REMOTE_TV_DIR}" "${LOCAL_TV_TEMP_DIR}"
    quit
EOF
    if [ -d "${LOCAL_MOVIES_TEMP_DIR}" ]; then
        # chmod -R 775 "${LOCAL_MOVIES_TEMP_DIR}"
        cp -lr "${LOCAL_MOVIES_TEMP_DIR}/." "${LOCAL_MOVIES_DIR}"
        rm -rf "${LOCAL_MOVIES_TEMP_DIR}"
    fi

    if [ -d "${LOCAL_TV_TEMP_DIR}" ]; then
     	# chmod -R 775 "${LOCAL_TV_TEMP_DIR}"
        cp -lr "${LOCAL_TV_TEMP_DIR}/." "${LOCAL_TV_DIR}"
        rm -rf "${LOCAL_TV_TEMP_DIR}"
    fi

    rm -f "$lock_file"
    trap - SIGINT SIGTERM
    exit
fi
