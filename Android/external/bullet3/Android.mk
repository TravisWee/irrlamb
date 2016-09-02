LOCAL_PATH := $(call my-dir)

include $(CLEAR_VARS)

LOCAL_MODULE := Bullet

LOCAL_SRC_FILES := libs/$(TARGET_ARCH_ABI)/libBullet.a

LOCAL_EXPORT_C_INCLUDE_DIRS := $(LOCAL_PATH)/include

include $(PREBUILT_STATIC_LIBRARY)