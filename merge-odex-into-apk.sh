#!/bin/sh
# Create a .apk files containing classes from the
#  original .apk file and the corresponding .odex file
# Needs smali and baksmali tools.
# Needs the mounted razer forge system image at ../system/
set -e

if [ -d "$1" ]; then
    dir="$1"
    appname=$(basename "$dir")
    apkfile="$dir/$appname.apk"
    odexfile="$dir/oat/arm/$appname.odex"
else
    odexfile=$1
    apkfile=$2
fi

baksmali=~/dev/android/tools/baksmali-2.5.2.jar
smali=~/dev/android/tools/smali-2.5.2.jar

if [ ! -f "$odexfile" ]; then
    echo ".odex file does not exist: $odexfile"
    exit 1
fi

if [ ! -f "$apkfile" ]; then
    echo ".apk file does not exist: $apkfile"
    exit 1
fi

if [ ! -d unzip-apk ]; then
    mkdir unzip-apk
fi
rm -rf unzip-apk/*

cd unzip-apk/
unzip -q "../$apkfile"
cd ..

if [ -d out ]; then
    rm -rf out/
fi
echo "Unpacking .odex"
java -jar "$baksmali" deodex\
     --api 23\
     --bootclasspath ../system/framework/arm/boot.oat\
     -d ../system/framework/\
     -d ../system/app/\
     -d ../system/priv-app/\
     "$odexfile"

echo "Unpacking classes.dex from .apk"
if [ -f unzip-apk/classes.dex ]; then
    java -jar "$baksmali" disassemble\
         --api 23\
         --bootclasspath ../system/framework/arm/boot.oat\
         -d ../system/framework/\
         -d ../system/app/\
         -d ../system/priv-app/\
         "unzip-apk/classes.dex"
else
    echo " No classes.dex in .apk"
fi

echo "Generating new classes.dex"
java -jar "$smali" assemble\
     --api 23\
     --output unzip-apk/classes.dex\
     out/

echo "Generating full .apk"
cd unzip-apk
apkfilename=$(basename "$apkfile")
zip -qr "../full-$apkfilename" .
cd ..

echo "Size comparison"
ls -lh "$odexfile"
ls -lh "$apkfile"
ls -lh "full-$apkfilename"
