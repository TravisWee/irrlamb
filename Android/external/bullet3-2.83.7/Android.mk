LOCAL_PATH := $(call my-dir)

PROJECT_ROOT_DIR := $(LOCAL_PATH)
PROJECT_SRC_DIR := $(PROJECT_ROOT_DIR)/src


HDR_COMMON_LIST := $(subst $(LOCAL_PATH)/, , $(wildcard $(PROJECT_SRC_DIR)/*.h))

SRC_LinearMath_LIST := $(subst $(LOCAL_PATH)/, , $(wildcard $(PROJECT_SRC_DIR)/LinearMath/*.cpp))
HDR_LinearMath_LIST := $(subst $(LOCAL_PATH)/, , $(wildcard $(PROJECT_SRC_DIR)/LinearMath/*.h))

SRC_BulletSoftBody_LIST := $(subst $(LOCAL_PATH)/, , $(wildcard $(PROJECT_SRC_DIR)/BulletSoftBody/*.cpp))
HDR_BulletSoftBody_LIST := $(subst $(LOCAL_PATH)/, , $(wildcard $(PROJECT_SRC_DIR)/BulletSoftBody/*.h))

SRC_BulletCollision_LIST := $(subst $(LOCAL_PATH)/, , $(wildcard $(PROJECT_SRC_DIR)/BulletCollision/BroadphaseCollision/*.cpp))
SRC_BulletCollision_LIST += $(subst $(LOCAL_PATH)/, , $(wildcard $(PROJECT_SRC_DIR)/BulletCollision/CollisionDispatch/*.cpp))
SRC_BulletCollision_LIST += $(subst $(LOCAL_PATH)/, , $(wildcard $(PROJECT_SRC_DIR)/BulletCollision/CollisionShapes/*.cpp))
SRC_BulletCollision_LIST += $(subst $(LOCAL_PATH)/, , $(wildcard $(PROJECT_SRC_DIR)/BulletCollision/Gimpact/*.cpp))
SRC_BulletCollision_LIST += $(subst $(LOCAL_PATH)/, , $(wildcard $(PROJECT_SRC_DIR)/BulletCollision/NarrowPhaseCollision/*.cpp))
HDR_BulletCollision_LIST := $(subst $(LOCAL_PATH)/, , $(wildcard $(PROJECT_SRC_DIR)/BulletCollision/BroadphaseCollision/*.h))
HDR_BulletCollision_LIST += $(subst $(LOCAL_PATH)/, , $(wildcard $(PROJECT_SRC_DIR)/BulletCollision/CollisionDispatch/*.h))
HDR_BulletCollision_LIST += $(subst $(LOCAL_PATH)/, , $(wildcard $(PROJECT_SRC_DIR)/BulletCollision/CollisionShapes/*.h))
HDR_BulletCollision_LIST += $(subst $(LOCAL_PATH)/, , $(wildcard $(PROJECT_SRC_DIR)/BulletCollision/Gimpact/*.h))
HDR_BulletCollision_LIST += $(subst $(LOCAL_PATH)/, , $(wildcard $(PROJECT_SRC_DIR)/BulletCollision/NarrowPhaseCollision/*.h))

SRC_BulletDynamics_LIST := $(subst $(LOCAL_PATH)/, , $(wildcard $(PROJECT_SRC_DIR)/BulletDynamics/Character/*.cpp))
SRC_BulletDynamics_LIST += $(subst $(LOCAL_PATH)/, , $(wildcard $(PROJECT_SRC_DIR)/BulletDynamics/ConstraintSolver/*.cpp))
SRC_BulletDynamics_LIST += $(subst $(LOCAL_PATH)/, , $(wildcard $(PROJECT_SRC_DIR)/BulletDynamics/Dynamics/*.cpp))
SRC_BulletDynamics_LIST += $(subst $(LOCAL_PATH)/, , $(wildcard $(PROJECT_SRC_DIR)/BulletDynamics/Vehicle/*.cpp))
SRC_BulletDynamics_LIST += $(subst $(LOCAL_PATH)/, , $(wildcard $(PROJECT_SRC_DIR)/BulletDynamics/Featherstone/*.cpp))
SRC_BulletDynamics_LIST += $(subst $(LOCAL_PATH)/, , $(wildcard $(PROJECT_SRC_DIR)/BulletDynamics/MLCPSolvers/*.cpp))
HDR_BulletDynamics_LIST := $(subst $(LOCAL_PATH)/, , $(wildcard $(PROJECT_SRC_DIR)/BulletDynamics/Character/*.h))
HDR_BulletDynamics_LIST += $(subst $(LOCAL_PATH)/, , $(wildcard $(PROJECT_SRC_DIR)/BulletDynamics/ConstraintSolver/*.h))
HDR_BulletDynamics_LIST += $(subst $(LOCAL_PATH)/, , $(wildcard $(PROJECT_SRC_DIR)/BulletDynamics/Dynamics/*.h))
HDR_BulletDynamics_LIST += $(subst $(LOCAL_PATH)/, , $(wildcard $(PROJECT_SRC_DIR)/BulletDynamics/Vehicle/*.h))
HDR_BulletDynamics_LIST += $(subst $(LOCAL_PATH)/, , $(wildcard $(PROJECT_SRC_DIR)/BulletDynamics/Featherstone/*.h))
HDR_BulletDynamics_LIST += $(subst $(LOCAL_PATH)/, , $(wildcard $(PROJECT_SRC_DIR)/BulletDynamics/MLCPSolvers/*.h))

BULLET_HDR_LIST := $(HDR_COMMON_LIST) $(HDR_BulletSoftBody_LIST) $(HDR_BulletCollision_LIST) $(HDR_BulletDynamics_LIST)



include $(CLEAR_VARS)
LOCAL_MODULE := LinearMath
LOCAL_C_INCLUDES := $(HDR_LinearMath_LIST)
LOCAL_SRC_FILES :=  $(SRC_LinearMath_LIST)
LOCAL_EXPORT_C_INCLUDE_DIRS := $(HDR_LinearMath_LIST)
include $(BUILD_STATIC_LIBRARY)


include $(CLEAR_VARS)
LOCAL_MODULE := BulletSoftBody
LOCAL_C_INCLUDES := $(HDR_BulletSoftBody_LIST) $(PROJECT_SRC_DIR)
LOCAL_SRC_FILES :=  $(SRC_BulletSoftBody_LIST)
LOCAL_EXPORT_C_INCLUDE_DIRS := $(HDR_BulletSoftBody_LIST)
include $(BUILD_STATIC_LIBRARY)
LOCAL_STATIC_LIBRARIES := BulletDynamics


include $(CLEAR_VARS)
LOCAL_MODULE := BulletCollision
LOCAL_C_INCLUDES := $(PROJECT_SRC_DIR)
LOCAL_SRC_FILES :=  $(SRC_BulletCollision_LIST)
LOCAL_EXPORT_C_INCLUDE_DIRS := $(BULLET_HDR_LIST)
include $(BUILD_STATIC_LIBRARY)
LOCAL_STATIC_LIBRARIES := LinearMath


include $(CLEAR_VARS)
LOCAL_MODULE := BulletDynamics
LOCAL_C_INCLUDES := $(PROJECT_SRC_DIR)
LOCAL_SRC_FILES :=  $(SRC_BulletDynamics_LIST)
LOCAL_EXPORT_C_INCLUDE_DIRS := $(BULLET_HDR_LIST)
include $(BUILD_STATIC_LIBRARY)
LOCAL_STATIC_LIBRARIES := LinearMath BulletCollision





