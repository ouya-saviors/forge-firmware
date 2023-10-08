Razer Forge TV system apk files
===============================
The ``.apk`` files inside the Razer Forge TV firmware files
are optimized for faster loading (``.odex``)
and cannot be decompiled as easily as standard ``.apk`` files.

This repository containes de-odexed system apks that can be inspected easily
with tools like `jadx-gui`__.

__ https://github.com/skylot/jadx

Full firmware images can be downloaded at
https://archive.org/details/razer-forge-tv-firmware
and
http://archive.cweiske.de/binary/#forge-firmware


Build a de-odexed .apk
----------------------

1. Unzip ``.apk`` file
2. Convert ``.odex`` file into many ``.smali`` files with ``baksmali deodex``
3. Unpack the unzipped ``classes.dex`` into the same directory
4. Generate a new ``classes.dex`` from the smali directory
5. Re-zip the apk files

See ``merge-odex-into-apk.sh``.
