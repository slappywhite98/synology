#!/bin/bash
download_dir="/downloads"

if [ "${radarr_moviefile_sourcefolder}" == "${download_dir}" ]; then
  rm "${radarr_moviefile_sourcepath}"
else
  rm -rf "${radarr_moviefile_sourcefolder}"
fi
