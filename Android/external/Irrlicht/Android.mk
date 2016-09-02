LOCAL_PATH := $(call my-dir)

include $(CLEAR_VARS)

LOCAL_MODULE := Irrlicht

LOCAL_SRC_FILES := libs/$(TARGET_ARCH_ABI)/libIrrlicht.a

LOCAL_EXPORT_C_INCLUDE_DIRS := $(LOCAL_PATH)/include

LOCAL_EXPORT_LDLIBS := -lEGL -llog -lGLESv1_CM -lGLESv2 -lz -landroid

include $(PREBUILT_STATIC_LIBRARY)