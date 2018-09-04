#!/bin/sh

script_dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"

remote_movies_dir="files/complete/movie/radarr/"
local_movies_temp_dir="/volume1/media/downloads/incomplete/movies"
local_movies_dir="/volume1/media/downloads/movies"

remote_tv_dir="files/complete/tv/sonarr/"
local_movies_temp_dir="/volume1/media/downloads/incomplete/movies"
local_tv_dir="/volume1/media/downloads/tv"

base_name="$(basename "$0")"
log_file="${script_dir}/logs/lftpsync.log"
lock_file="/tmp/${base_name}.lock"

trap "rm -f $lock_file; exit 0" SIGINT SIGTERM
if [ -e "$lock_file" ]
then
    echo "$base_name is running already."
    exit
else
    touch "$lock_file"
    # Bookmark with name 'host' should be stored in ~/.local/share/lftp/bookmarks in the form
    # host    ftp://<username>:<password>@<host>/
    lftp bm:host << EOF
    set log:enabled/xfer yes
    set log:file/xfer ${log_file}
    set xfer:use-temp-file yes
    set xfer:temp-file-name *.lftp
    set ftp:ssl-allow no
    set mirror:use-pget-n 5
    mirror -v -c -P5 --verbose --no-empty-dirs --no-umask --Remove-source-files --Remove-source-dirs "${remote_movies_dir}" "${local_movies_temp_dir}"
    mirror -v -c -P5 --verbose --no-empty-dirs --no-umask --Remove-source-files --Remove-source-dirs "${remote_tv_dir}" "${local_tv_temp_dir}"
    quit
EOF
    if [ -d "${local_movies_temp_dir}" ]; then
        chmod -R 775 "${local_movies_temp_dir}"
        cp -lr "${local_movies_temp_dir}/." "${local_movies_dir}"
        rm -rf "${local_movies_temp_dir}"
    fi

    if [ -d "${local_tv_temp_dir}" ]; then
     	chmod -R 775 "${local_tv_temp_dir}"
        cp -lr "${local_tv_temp_dir}/." "${local_tv_dir}"
        rm -rf "${local_tv_temp_dir}"
    fi

    rm -f "$lock_file"
    trap - SIGINT SIGTERM
    exit
fi
