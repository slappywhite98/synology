#!/bin/bash
script_dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"
download_dir=$1

log_file="${script_dir}/logs/afterRename.log"

if [ "${radarr_moviefile_sourcefolder}" == "${download_dir}" ]; then
  echo "$(date "+%m%d%Y %T"): Deleting movie ${radarr_moviefile_sourcepath}" >> "${log_file}" 2>&1
  rm "${radarr_moviefile_sourcepath}"
else
  echo "$(date "+%m%d%Y %T"): Deleting movie folder ${radarr_moviefile_sourcefolder}" >> "${log_file}" 2>&1
  rm -rf "${radarr_moviefile_sourcefolder}"
fi
