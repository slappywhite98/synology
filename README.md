# Synology & Seedbox Setup

Synology and Seedbox setup.

### Overview

Radarr, Sonarr, and Plex run on the NAS. Radarr and Sonarr are configured to send torrent
files to RTorrent/RuTorrent running on the seedbox. AutoTools is configured to hardlink
completed downloads to a completed folder. A script on the NAS runs as a repeating task
and mirrors the completed downloads back to directories Radarr/Sonarr are looking on the NAS.
Radarr/Sonarr are configured to hardlink the downloaded files to where Plex is looking. 
A script is then triggered to remove the hardlinks from the download dir.

NOTE: 
I have surely forgotten steps here. But this captures the overall setup.

# Synology Setup

- Enable SSH: Terminal & SNMP -> Terminal -> Enable SSH service
- Enable user home service: User -> Advanced -> "Enable user home service" 

## Package Center
- Enable beta
- Add the SynoCommunity as a package source: `http://packages.synocommunity.com/`
- Set trust level to `Any publisher`
- Install `Radarr`, `Sonarr`, and `Plex` packages.
- Install git package
- SSH in and clone this repo to a common place

    ```
    mkdir -P /volume1/projects
    git clone https://github.com/slappywhite98/synology
    ```

## Users

- Create the media user. It will be the user that runs the sync script to the seedbox and the user that owns the media folders.
- Link scripts for the media user 

    ```
    ln -s /volume1/projects/synology/scripts/lftpsync.sh /volume1/homes/media/lftpsync.sh
    ln -s /volume1/projects/synology/scripts/afterRename.sh /volume1/homes/media/afterRename.sh
    ```

## File System
- Create `media` shared folder
- Create the needed subfolders

    ```
    sudo mkdir -P /volume1/media/{movies, tv, downloads/{incomplete,tv,movies}}
    ```

We need the lftp sync script, which is run by the media user, to have access to the downloads folders.
We also need radarr and sonarr to have access to the downloads folders. To accomplish this we 
set the ownership to be media:sc-download. The radarr/sonarr users are in the sc-download group.
And as the lftp sync script copies files into the downloads directory, because we set g+s the files
will all be created with the sc-download group.

```
sudo chown -R media:sc-download /volume1/media/{movies, tv, downloads}
sudo chmod g+s /volume1/media/{movies, tv, downloads}
```

## Radarr 
TODO

## Sonarr
TODO

# Seedbox Setup

## Jackett
TODO

## RTorrnet
TODO

## RuTorrent
TODO