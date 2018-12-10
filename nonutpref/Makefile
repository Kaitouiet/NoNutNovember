export TARGET = iphone:9.2:9.2

include $(THEOS)/makefiles/common.mk

BUNDLE_NAME = nonutpref
nonutpref_FILES = NNNRootListController.m
nonutpref_INSTALL_PATH = /Library/PreferenceBundles
nonutpref_FRAMEWORKS = UIKit
nonutpref_PRIVATE_FRAMEWORKS = Preferences
nonutpref_LIBRARIES = applist
nonutpref_CFLAGS = -fobjc-arc

include $(THEOS_MAKE_PATH)/bundle.mk

internal-stage::
	$(ECHO_NOTHING)mkdir -p $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences$(ECHO_END)
	$(ECHO_NOTHING)cp entry.plist $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences/nonutpref.plist$(ECHO_END)
