LOCAL_PATH := $(call my-dir)

PROJECT_ROOT_DIR := $(LOCAL_PATH)/../../..
PROJECT_SRC_DIR := $(PROJECT_ROOT_DIR)/src

EXTRA_PROJECT_PATH := $(LOCAL_PATH)/../../external

SRC_MAIN_LIST := $(subst $(LOCAL_PATH)/, , $(wildcard $(LOCAL_PATH)/../*.cpp))
SRC_ROOT_LIST := $(subst $(LOCAL_PATH)/, , $(wildcard $(PROJECT_SRC_DIR)/*.cpp))
SRC_FONT_LIST := $(subst $(LOCAL_PATH)/, , $(wildcard $(PROJECT_SRC_DIR)/font/*.cpp))
SRC_IRRB_LIST := $(subst $(LOCAL_PATH)/, , $(wildcard $(PROJECT_SRC_DIR)/irrb/*.cpp))
SRC_OBJECTS_LIST := $(subst $(LOCAL_PATH)/, , $(wildcard $(PROJECT_SRC_DIR)/objects/*.cpp))
SRC_STATES_LIST := $(subst $(LOCAL_PATH)/, , $(wildcard $(PROJECT_SRC_DIR)/states/*.cpp))
SRC_XML_LIST := $(subst $(LOCAL_PATH)/, , $(wildcard $(PROJECT_SRC_DIR)/tinyxml/*.cpp))



include $(CLEAR_VARS)
LOCAL_MODULE := Irrlamb

LOCAL_CFLAGS := -Wall -pipe -fno-exceptions -fno-rtti -fstrict-aliasing \
				-Wno-deprecated-declarations -pedantic -std=c++11

LOCAL_C_INCLUDES := $(PROJECT_SRC_DIR)
LOCAL_C_INCLUDES += $(PROJECT_SRC_DIR)/font
LOCAL_C_INCLUDES += $(PROJECT_SRC_DIR)/irrb
LOCAL_C_INCLUDES += $(PROJECT_SRC_DIR)/objects
LOCAL_C_INCLUDES += $(PROJECT_SRC_DIR)/states
LOCAL_C_INCLUDES += $(PROJECT_SRC_DIR)/tinyxml
LOCAL_C_INCLUDES += $(EXTRA_PROJECT_PATH)/Irrlicht/include

LOCAL_SRC_FILES :=  $(SRC_MAIN_LIST) \
				#	$(SRC_ROOT_LIST) \
				#	$(SRC_FONT_LIST) \
				#	$(SRC_IRRB_LIST) \
				#	$(SRC_OBJECTS_LIST) \
				#	$(SRC_STATES_LIST) \
				#	$(SRC_XML_LIST)


LOCAL_STATIC_LIBRARIES := 	Irrlicht \
							android_native_app_glue \
							lua \
							libpng_static sqlite3_static \
							libogg libvorbis \
							LinearMath BulletSoftBody BulletCollision BulletDynamics \
							libft2

include $(BUILD_SHARED_LIBRARY)

$(call import-add-path, $(EXTRA_PROJECT_PATH))
$(call import-module,android/native_app_glue)
$(call import-module, Irrlicht)
$(call import-module, bullet3-2.83.7)
$(call import-module, freetype-2.6.5)
$(call import-module, lua-5.3.3)
$(call import-module, libpng)
$(call import-module, sqlite)
$(call import-module, libogg)
$(call import-module, libvorbis)
