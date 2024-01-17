#!/bin/bash
# Script has been modified by Spike for additional functionality and clarity, originally by arter97 and luk1337.

# Download base ota package while renaming it to ota.zip
aria2c -x5 $1 -o ota.zip

# Create a new folder 'fullota' and copy ota.zip to it
mkdir fullota
cp ota.zip fullota

# Continue with unzipping and extracting the payload
unzip ota.zip payload.bin
mv payload.bin payload_working.bin
TAG="`unzip -p ota.zip payload_properties.txt | grep ^POST_OTA_VERSION= | cut -b 18-`"
BODY="[$TAG]($1) (full)"
rm ota.zip
mkdir ota
(
    ./bin/ota_extractor -output_dir ota -payload payload_working.bin
    rm payload_working.bin
) & # Allow subsequent downloads to be done in parallel

# Apply incrementals
for i in ${@:2}; do
    aria2c -x5 $i -o ota.zip
    unzip ota.zip payload.bin
    wait
    mv payload.bin payload_working.bin
    TAG="`unzip -p ota.zip payload_properties.txt | grep ^POST_OTA_VERSION= | cut -b 18-`"
    BODY="$BODY -> [$TAG]($i)"
    rm ota.zip

    (
        mkdir ota_new
        ./bin/ota_extractor -input-dir ota -output_dir ota_new -payload payload_working.bin

        rm -rf ota
        mv ota_new ota

        rm payload_working.bin
    ) & # Allow subsequent downloads to be done in parallel
done
wait

# Create necessary folders to be used later
mkdir out dyn syn

# Switch back to ota folder  
cd ota

# Calculate hash for all files in ota folder
for h in md5 sha1 sha256 xxh128; do
    if [ "$h" = "xxh128" ]; then
        ls * | parallel xxh128sum | sort -k2 -V > ../out/${TAG}-hash.$h
    else
        ls * | parallel "openssl dgst -${h} -r" | sort -k2 -V > ../out/${TAG}-hash.${h}
    fi
done

# Copy boot, vendor_boot and recovery images to ../syn directory
cp boot.img ../syn/
cp recovery.img ../syn/
cp vendor_boot.img ../syn/

# Create compressed images individually in syn directory and move them to out directory
cd ../syn
for f in boot vendor_boot recovery; do
    7z a -mmt128 -mx5 ${f}.img.zip ${f}.img
    mv ${f}.img.zip ../out
done

# Move specific logical image files from ../ota to ../dyn/ directory
cd ../ota
for f in system system_ext product vendor vendor_dlkm odm; do
    mv ${f}.img ../dyn
done

# Change back to ../ota/ directory and create the split .7z for non-logical images
cd ../ota
7z a -mmt128 -mx6 ../out/${TAG}-image.7z *

# Change to ../dyn/ directory and create the split .7z for logical images
cd ../dyn
7z a -mmt128 -mx6 -v1g ../out/${TAG}-image-logical.7z *
wait

# Move to fullota folder and create the splitted .7z for the base FullOTA Package (ota.zip renamed earlier)
cd ../fullota
cp ota.zip "./${TAG}-FullOTA.zip"
7z a -mmt128 -mx6 -v1g "../out/${TAG}-FullOTA.7z" "${TAG}-FullOTA.zip"
cd ..

# Cleanup of corresponding folders
rm -rf ../fullota ../ota ../dyn ../syn

# Echo tag name, release body, and release history
echo "tag=$TAG" >> "$GITHUB_OUTPUT"
echo "body=$BODY" >> "$GITHUB_OUTPUT"