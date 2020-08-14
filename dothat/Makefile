TARGET := iphone:clang:latest:7.0

include $(THEOS)/makefiles/common.mk

BUNDLE_NAME = DoThat

DoThat_FILES = DTPRootListController.m
DoThat_FRAMEWORKS = UIKit
DoThat_PRIVATE_FRAMEWORKS = Preferences
DoThat_LIBRARIES = applist
DoThat_INSTALL_PATH = /Library/PreferenceBundles
DoThat_CFLAGS = -fobjc-arc

include $(THEOS_MAKE_PATH)/bundle.mk
