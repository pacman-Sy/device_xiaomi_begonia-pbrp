#
# Copyright (C) 2022 The Android Open Source Project
# Copyright (C) 2022 SebaUbuntu's TWRP device tree generator
#
# SPDX-License-Identifier: Apache-2.0
#

# Soong namespaces
PRODUCT_SOONG_NAMESPACES += \
    $(LOCAL_PATH)

# API
PRODUCT_SHIPPING_API_LEVEL := 29

# HACK: Set vendor patch level
PRODUCT_PROPERTY_OVERRIDES += \
    ro.vendor.build.security_patch=2099-12-31 \
    ro.bootimage.build.date.utc=0 \
    ro.build.date.utc=0

ifeq ($(PBRP_ENABLE_CRYPTO),true)
    PRODUCT_PROPERTY_OVERRIDES += ro.pbrp.crypto=true
else
    PRODUCT_PROPERTY_OVERRIDES += ro.pbrp.crypto=false
endif

# The hardware-backed keymaster stack is opt-in. The default safe image must
# not enter the vendor TEE/FBE path before the main UI is ready.
ifeq ($(PBRP_ENABLE_CRYPTO),true)
    TARGET_RECOVERY_DEVICE_MODULES += \
        libkeymaster4 \
        libpuresoftkeymasterdevice \
        libshim_beanpod

    TW_RECOVERY_ADDITIONAL_RELINK_LIBRARY_FILES += \
        $(TARGET_OUT_SHARED_LIBRARIES)/libkeymaster4.so \
        $(TARGET_OUT_SHARED_LIBRARIES)/libpuresoftkeymasterdevice.so

    PRODUCT_PACKAGES += \
        libshim_beanpod
endif
