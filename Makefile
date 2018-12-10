export TARGET = iphone:9.2:9.2

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = NoNutNovember
NoNutNovember_FILES = Tweak.xm
NoNutNovember_FRAMEWORKS = UIKit
NoNutNovember_LIBRARIES = bulletin
NoNutNovember_CFLAGS = -fobjc-arc

include $(THEOS_MAKE_PATH)/tweak.mk

after-install::
	install.exec "killall -9 SpringBoard"
SUBPROJECTS += nonutpref
include $(THEOS_MAKE_PATH)/aggregate.mk
