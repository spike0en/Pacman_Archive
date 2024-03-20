# Nothing Phone (2a) Archive

* A comprehensive collection of unmodified Full OTA update packages & stock OTA images for Nothing Phone (2a).

## Downloads

- Downloads are tagged with `POST_OTA_VERSION` & `NothingOS version` [here](https://github.com/spike0en/Pacman_Archive/releases). It is to be noted that the releases are compatible with all regional variants of the device.

- Official Full OTA Update Package is marked `-FullOTA`. Extract the splitted 7z parts to get the `<name>-FullOTA.zip`.

- The Stock OTA image files are categorized and archived in .7z format based on `boot`, `logical`, and `firmware` partitions:

### Boot Partition (marked `-image-boot.7z`)

Includes 5 images:
```bash
boot, dtbo, init_boot, vendor_boot & vbmeta
```
### Logical partition (marked `-image-logical.7z.001-004`)

Includes 10 images:
```bash
odm, vendor, system_ext, system, vendor_dlkm, odm_dlkm, system_dlkm, product, vbmeta_system & vbmeta_vendor
```
### Firmware partition (marked `-image-firmware.7z`)

Includes 22 images:
```bash
apusys, audio_dsp, ccu, connsys_bt, connsys_gnss, connsys_wifi, dpm, gpueb, gz, lk, logo, mcf_ota, mcupm, md1img, mvpu_algo, pi_img, preloader_raw, scp, spmfw, sspm, tee & vcp
```

## Disclaimer

- While this is a collection of unmodified images, you still need to have the bootloader unlocked.

- You can re-lock the bootloader after flashing images. 

- SHA-1 hash of `<name>-FullOTA.zip` file has been provided. It is to be noted that the built-in NothingOS Offline Updater Tool autonomously verifies file integrity. It initiates the update process only if the file aligns with the hash values specified in `payload-properties.txt`, which is obtained during the creation of the update package.

- For further inquiries, discussions, and engaging content, users are encouraged to explore the [Nothing Phone (2a) Telegram Community](https://t.me/NothingPhone2a)

## Fastboot Flashing

- A working script for the same will be updated here in due time. 

## Manual Sideloading of Full OTA Packages

### A. Via Stock Nothing Offline OTA Updater Tool (Locked BL): 

1. To flash stock, unmodified official Full OTA packages, extract the files using 7z to obtain the <name>-FullOTA.zip file.
2. Using your preferred file manager, create a folder named 'ota' at the root of your storage.
3. Copy the <name>-FullOTA.zip into the newly created 'ota' folder.
4. Open your dial pad and type `*#*#682#*#*`.
5. The manual update utility will launch, scanning and locating your previously downloaded update file.
6. Tap to begin the update. The process will take about 10-15 minutes (duration may vary).
7. Enjoy your updated device after reboot!

### B. Via Custom Recovery (Unlocked BL):

- The FullOTA can be flashed directly via custom recoveries as well.

## Integrity Check

- You can check the downloaded file's integrity with one of the following commands :

``` bash
  md5sum -c *-hash.md5
  sha1sum -c *-hash.sha1
  sha256sum -c *-hash.sha256
  xxh128sum -c *-hash.xxh128
```

- xxh128 is usually the fastest.


### Thanks to
- [luk1337](https://github.com/luk1337/oplus_archive) & [arter97](https://github.com/arter97/nothing_archive) for their great work!
