LOCAL_PATH := $(call my-dir)

PROJECT_ROOT_DIR := $(LOCAL_PATH)/../../..
PROJECT_SRC_DIR := $(PROJECT_ROOT_DIR)/src

EXTRA_PROJECT_PATH := $(LOCAL_PATH)/../../external

EXCLUDE_FILE_LIST := $(PROJECT_SRC_DIR)/main.cpp

SRC_MAIN_LIST := $(subst $(LOCAL_PATH)/, , $(wildcard $(LOCAL_PATH)/../*.cpp))
SRC_ROOT_LIST := $(subst $(LOCAL_PATH)/, , $(filter-out $(EXCLUDE_FILE_LIST), $(wildcard $(PROJECT_SRC_DIR)/*.cpp)))
SRC_FONT_LIST := $(subst $(LOCAL_PATH)/, , $(wildcard $(PROJECT_SRC_DIR)/font/*.cpp))
SRC_IRRB_LIST := $(subst $(LOCAL_PATH)/, , $(wildcard $(PROJECT_SRC_DIR)/irrb/*.cpp))
SRC_OBJECTS_LIST := $(subst $(LOCAL_PATH)/, , $(wildcard $(PROJECT_SRC_DIR)/objects/*.cpp))
SRC_STATES_LIST := $(subst $(LOCAL_PATH)/, , $(wildcard $(PROJECT_SRC_DIR)/states/*.cpp))
SRC_XML_LIST := $(subst $(LOCAL_PATH)/, , $(wildcard $(PROJECT_SRC_DIR)/tinyxml/*.cpp))



include $(CLEAR_VARS)
LOCAL_MODULE := Irrlamb

LOCAL_CFLAGS := -D_ANDROID \
				-Wall -pipe -fno-exceptions -fno-rtti -fstrict-aliasing \
				-Wno-deprecated-declarations -pedantic -std=c++11
				

LOCAL_C_INCLUDES := $(PROJECT_SRC_DIR)
LOCAL_C_INCLUDES += $(PROJECT_SRC_DIR)/font
LOCAL_C_INCLUDES += $(PROJECT_SRC_DIR)/irrb
LOCAL_C_INCLUDES += $(PROJECT_SRC_DIR)/objects
LOCAL_C_INCLUDES += $(PROJECT_SRC_DIR)/states
LOCAL_C_INCLUDES += $(PROJECT_SRC_DIR)/tinyxml

# TODO: to be removed if LOCAL_EXPORT_C_INCLUDE_DIRS works
LOCAL_C_INCLUDES += $(EXTRA_PROJECT_PATH)/Irrlicht/include
LOCAL_C_INCLUDES += $(EXTRA_PROJECT_PATH)/lua-5.3.3/include
LOCAL_C_INCLUDES += $(EXTRA_PROJECT_PATH)/bullet3/include

LOCAL_SRC_FILES :=  $(SRC_MAIN_LIST) \
					$(SRC_ROOT_LIST) \
					$(SRC_FONT_LIST) \
					$(SRC_IRRB_LIST) \
					$(SRC_OBJECTS_LIST) \
					$(SRC_STATES_LIST) \
					$(SRC_XML_LIST)


LOCAL_STATIC_LIBRARIES := 	android_native_app_glue \
							Irrlicht \
							Bullet \
							lua \
							libpng_static sqlite3_static \
							libogg libvorbis openal_static \
							libft2

include $(BUILD_SHARED_LIBRARY)

$(call import-add-path, $(EXTRA_PROJECT_PATH))
$(call import-module, android/native_app_glue)
$(call import-module, Irrlicht)
$(call import-module, bullet3)
$(call import-module, freetype)
$(call import-module, lua-5.3.3)
$(call import-module, libpng)
$(call import-module, sqlite)
$(call import-module, libogg)
$(call import-module, libvorbis)
$(call import-module, openal)

