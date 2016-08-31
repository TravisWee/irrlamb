LOCAL_PATH := $(call my-dir)

PROJECT_ROOT_DIR := $(LOCAL_PATH)
PROJECT_SRC_DIR := $(PROJECT_ROOT_DIR)/src

SRC_BIN_LIST := lua.c luac.c

SRC_CORE_LIST := \
				$(PROJECT_SRC_DIR)/lapi.c \
				$(PROJECT_SRC_DIR)/lcode.c \
				$(PROJECT_SRC_DIR)/lctype.c \
				$(PROJECT_SRC_DIR)/ldebug.c \
				$(PROJECT_SRC_DIR)/ldo.c \
				$(PROJECT_SRC_DIR)/ldump.c \
				$(PROJECT_SRC_DIR)/lfunc.c \
				$(PROJECT_SRC_DIR)/lgc.c \
				$(PROJECT_SRC_DIR)/llex.c \
				$(PROJECT_SRC_DIR)/lmem.c \
				$(PROJECT_SRC_DIR)/lobject.c \
				$(PROJECT_SRC_DIR)/lopcodes.c \
				$(PROJECT_SRC_DIR)/lparser.c \
				$(PROJECT_SRC_DIR)/lstate.c \
				$(PROJECT_SRC_DIR)/lstring.c \
				$(PROJECT_SRC_DIR)/ltable.c \
				$(PROJECT_SRC_DIR)/ltm.c \
				$(PROJECT_SRC_DIR)/lundump.c \
				$(PROJECT_SRC_DIR)/lvm.c \
				$(PROJECT_SRC_DIR)/lzio.c

SRC_LIB_LIST := \
				$(PROJECT_SRC_DIR)/lauxlib.c \
				$(PROJECT_SRC_DIR)/lbaselib.c \
				$(PROJECT_SRC_DIR)/lbitlib.c \
				$(PROJECT_SRC_DIR)/lcorolib.c \
				$(PROJECT_SRC_DIR)/ldblib.c \
				$(PROJECT_SRC_DIR)/liolib.c \
				$(PROJECT_SRC_DIR)/lmathlib.c \
				$(PROJECT_SRC_DIR)/loslib.c \
				$(PROJECT_SRC_DIR)/lstrlib.c \
				$(PROJECT_SRC_DIR)/ltablib.c \
				$(PROJECT_SRC_DIR)/lutf8lib.c \
				$(PROJECT_SRC_DIR)/loadlib.c \
				$(PROJECT_SRC_DIR)/linit.c
				


include $(CLEAR_VARS)

LOCAL_MODULE := lua

LOCAL_CFLAGS := -D_ANDROID_PLATFORM_

#LOCAL_SRC_FILES := $(subst jni/, , $(wildcard $(LOCAL_PATH)/../src/*.c))
#$(info $(LOCAL_SRC_FILES))
#LOCAL_SRC_FILES := $(filter-out $(EXCLUDE_FILE_LIST), $(LOCAL_SRC_FILES))
#$(info $(LOCAL_SRC_FILES))

LOCAL_SRC_FILES :=  $(subst $(LOCAL_PATH)/, , $(SRC_CORE_LIST)) \
					$(subst $(LOCAL_PATH)/, , $(SRC_LIB_LIST))

LOCAL_EXPORT_C_INCLUDE_DIRS := $(LOCAL_PATH)/../include

include $(BUILD_STATIC_LIBRARY)