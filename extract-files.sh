#!/bin/sh

# Copyright (C) 2013 The CyanogenMod Project
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# This file is generated by device/common/generate-blob-scripts.sh - DO NOT EDIT

VENDOR=samsung
DEVICE=l900
COMMON=t0ltecdma

mkdir -p ../../../vendor/$VENDOR/$DEVICE/proprietary

adb root
adb wait-for-device

echo "Pulling proprietary files..."
for FILE in `cat ../$DEVICE/proprietary-files.txt | grep -v ^# | grep -v ^$`; do
    DIR=`dirname $FILE`
    if [ ! -d ../../../vendor/$VENDOR/$COMMON/proprietary/$DIR ]; then
        mkdir -p ../../../vendor/$VENDOR/$COMMON/proprietary/$DIR
    fi
    adb pull /$FILE ../../../vendor/$VENDOR/$COMMON/proprietary/$FILE
done


(cat << EOF) | sed s/__COMMON__/$COMMON/g | sed s/__VENDOR__/$VENDOR/g > ../../../vendor/$VENDOR/$COMMON/$COMMON-vendor-blobs.mk
# Copyright (C) 2013 The CyanogenMod Project
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

LOCAL_PATH := vendor/__VENDOR__/__COMMON__

PRODUCT_COPY_FILES += \\
EOF

LINEEND=" \\"
COUNT=`cat proprietary-files.txt | grep -v ^# | grep -v ^$ | wc -l | awk {'print $1'}`
for FILE in `cat proprietary-files.txt | grep -v ^# | grep -v ^$`; do
    COUNT=`expr $COUNT - 1`
    if [ $COUNT = "0" ]; then
        LINEEND=""
    fi
    echo "    \$(LOCAL_PATH)/proprietary/$FILE:$FILE$LINEEND" >> ../../../vendor/$VENDOR/$COMMON/$COMMON-vendor-blobs.mk
done

(cat << EOF) | sed s/__COMMON__/$COMMON/g | sed s/__VENDOR__/$VENDOR/g > ../../../vendor/$VENDOR/$COMMON/$COMMON-vendor.mk
# Copyright (C) 2013 The CyanogenMod Project
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# Pick up overlay for features that depend on non-open-source files
DEVICE_PACKAGE_OVERLAYS += vendor/__VENDOR__/__COMMON__/overlay

\$(call inherit-product, vendor/__VENDOR__/__COMMON__/__COMMON__-vendor-blobs.mk)
EOF

(cat << EOF) | sed s/__COMMON__/$COMMON/g | sed s/__VENDOR__/$VENDOR/g > ../../../vendor/$VENDOR/$COMMON/BoardConfigVendor.mk
# Copyright (C) 2013 The CyanogenMod Project
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

EOF

cd ./../../../device/samsung/t0lte/ && ./extract-files.sh "common"
