#ifdef DEBUG
  #define debug(fmt, ...) NSLog((@"[NoNutNovember(%d)]:: " fmt), __LINE__, ##__VA_ARGS__)
#else
  #define debug(s, ...)
#endif
#define kIdentifier @"com.kaitouiet.nonutnovember"
#define kSettingsChangedNotification (CFStringRef)@"com.kaitouiet.nonutnovember/ReloadPrefs"
#define kSettingsPath @"/var/mobile/Library/Preferences/com.kaitouiet.nonutnovember.plist"

#import <objc/runtime.h>
#import <UIKit/UIKit.h>
#import <CoreFoundation/CoreFoundation.h>
#import <CoreFoundation/CFNotificationCenter.h>
#import <sys/utsname.h>

@interface FBProcessState : NSObject
-(int)visibility;
@end

@interface JBBulletinManager : NSObject
	+(id)sharedInstance;
	-(id)showBulletinWithTitle:(NSString *)title message:(NSString *)message bundleID:(NSString *)bundleID;
@end

@interface SBDisplayItem : NSObject
@property (nonatomic, copy, readonly) NSString *displayIdentifier;
@end

@interface SBApplication : NSObject
-(NSString *)bundleIdentifier;
@end

static BOOL enabled = YES;
static NSString *titleNoti = @"";
static NSString *messageNoti = @"";
static NSMutableArray *blacklist;
static BOOL godStopIt = true;
NSString *bundleIdentifier = [[NSBundle mainBundle] bundleIdentifier];

%hook SBApplication

%group iOS11

/* iOS 11 - 11.1.2 */
-(void)_updateProcess:(id)arg1 withState:(FBProcessState *)state {
  %orig;
    if ([state visibility] == 2 && [blacklist containsObject:[self bundleIdentifier]] && enabled) {
      //static dispatch_once_t once;
	    //dispatch_once(&once, ^ {
        if(godStopIt) {
            [[objc_getClass("JBBulletinManager") sharedInstance] showBulletinWithTitle:titleNoti message:messageNoti bundleID:[self bundleIdentifier]];
            godStopIt = false;
  //  });
      }
        else {
          godStopIt = true;
      }
    }
}

%end

%group iOS10Lower

/* iOS 7 - 10.2 */
-(void)willActivate {
	%orig;
  if ([blacklist containsObject:[self bundleIdentifier]] && enabled) {

    if(godStopIt) {
        [[objc_getClass("JBBulletinManager") sharedInstance] showBulletinWithTitle:titleNoti message:messageNoti bundleID:[self bundleIdentifier]];
        godStopIt = false;

//  });
}
    else {
  godStopIt = true;
    }
  }
}

%end

%end

static void reloadPrefs() {
	CFPreferencesAppSynchronize((CFStringRef)kIdentifier);

	NSDictionary *prefs = nil;
	if ([NSHomeDirectory() isEqualToString:@"/var/mobile"]) {
		CFArrayRef keyList = CFPreferencesCopyKeyList((CFStringRef)kIdentifier, kCFPreferencesCurrentUser, kCFPreferencesAnyHost);
		if (keyList != nil) {
			prefs = (NSDictionary *)CFBridgingRelease(CFPreferencesCopyMultiple(keyList, (CFStringRef)kIdentifier, kCFPreferencesCurrentUser, kCFPreferencesAnyHost));
			if (prefs == nil)
				prefs = [NSDictionary dictionary];
			CFRelease(keyList);
		}
	} else {
		prefs = [NSDictionary dictionaryWithContentsOfFile:kSettingsPath];
	}

  enabled = [prefs objectForKey:@"enabled"] ? [(NSNumber *)[prefs objectForKey:@"enabled"] boolValue] : true;
  titleNoti = [prefs objectForKey:@"titleNoti"] ? [prefs objectForKey:@"titleNoti"] : titleNoti;
  messageNoti = [prefs objectForKey:@"messageNoti"] ? [prefs objectForKey:@"messageNoti"] : messageNoti;

  NSDictionary *apps = [NSDictionary dictionaryWithContentsOfFile:@"/var/mobile/Library/Preferences/com.kaitouiet.nonotnovember.plist"];
  blacklist = [[NSMutableArray alloc] init];

  [apps enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
  //    debug("%@", key);
  BOOL shouldHideApp = [[apps objectForKey:key] boolValue];
  		if (shouldHideApp && [key hasPrefix:@"apps-"] && ![blacklist containsObject:key])
  			[blacklist addObject:[key stringByReplacingOccurrencesOfString:@"apps-" withString:@""]];
  	}];
	}

%ctor {
  reloadPrefs();
    CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, (CFNotificationCallback)reloadPrefs, kSettingsChangedNotification, NULL, CFNotificationSuspensionBehaviorDeliverImmediately);
	if (kCFCoreFoundationVersionNumber > 1400) {
		%init(iOS11);
	} else {
		%init(iOS10Lower);
	}
	%init;
}
