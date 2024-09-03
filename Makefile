INSTALL_TARGET_PROCESSES = Snapchat

THEOS_PACKAGE_SCHEME=roothide
TARGET := iphone:clang:latest:16.4
ARCHS = arm64e

THEOS_DEVICE_IP = localhost
THEOS_DEVICE_PORT = 2222
THEOS_DEVICE_USER = root
TARGET_INSTALL_REMOTE = 1



include $(THEOS)/makefiles/common.mk

TWEAK_NAME = SnapSafe

SnapSafe_FILES = $(shell find Sources/SnapSafe -name '*.swift') $(shell find Sources/SnapSafeC -name '*.m' -o -name '*.c' -o -name '*.mm' -o -name '*.cpp')
SnapSafe_SWIFTFLAGS = -ISources/SnapSafeC/include
SnapSafe_CFLAGS = -fobjc-arc -ISources/SnapSafeC/include

include $(THEOS_MAKE_PATH)/tweak.mk
