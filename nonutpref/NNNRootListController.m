#import "prefs.h"


@interface NNNRootListController : PSListController {
UILabel* _label;
UILabel* underLabel;
}
- (void)HeaderCell;
@end

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

@implementation NNNRootListController

- (NSArray *)specifiers {
	if (!_specifiers) {
		_specifiers = [self loadSpecifiersFromPlistName:@"Root" target:self];
	}

	return _specifiers;
}
//- (void)viewDidLoad {
// [super viewDidLoad];

	//use icon instead of title text
//	UIImage *icon = [UIImage imageNamed:@"icon.png" inBundle:self.bundle];
//	self.navigationItem.titleView = [[UIImageView alloc] initWithImage:icon];


	// add twitter button to the navbar (idk why its weird in this tweak so im gonna just comment it out)
//	UIBarButtonItem *birdButton = [[UIBarButtonItem alloc] initWithTitle:@"Dismiss keyboard" style:UIBarButtonItemStylePlain target:self action:@selector(dismiss)];
//	[self.navigationItem setRightBarButtonItem:birdButton];
//}

- (void)HeaderCell
	@autoreleasepool {
	UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 120)];
	int width = [[UIScreen mainScreen] bounds].size.width;
	CGRect frame = CGRectMake(0, 20, width, 60);
		CGRect botFrame = CGRectMake(0, 55, width, 60);

		_label = [[UILabel alloc] initWithFrame:frame];
		[_label setNumberOfLines:1];
		_label.font = [UIFont fontWithName:@"GillSans" size:40];
		[_label setText:self.title];
		[_label setBackgroundColor:[UIColor clearColor]];
		_label.textColor = [UIColor blackColor];
		_label.textAlignment = NSTextAlignmentCenter;
		_label.alpha = 0;

		underLabel = [[UILabel alloc] initWithFrame:botFrame];
		[underLabel setNumberOfLines:1];
		underLabel.font = [UIFont fontWithName:@"GillSans-Light" size:16];
		[underLabel setText:@"It's not the month to be nutting"];
		[underLabel setBackgroundColor:[UIColor clearColor]];
		underLabel.textColor = [UIColor grayColor];
		underLabel.textAlignment = NSTextAlignmentCenter;
		underLabel.alpha = 0;

		[headerView addSubview:_label];
		[headerView addSubview:underLabel];

	[_table setTableHeaderView:headerView];

	[NSTimer scheduledTimerWithTimeInterval:0.5
                                     target:self
                                   selector:@selector(increaseAlpha)
                                   userInfo:nil
                                    repeats:NO];

	}
}
- (void) loadView
{
	[super loadView];
	self.title = @"NoNutNovember";
	[self HeaderCell];
}
- (void)increaseAlpha
{
	[UIView animateWithDuration:0.5 animations:^{
		_label.alpha = 1;
	}completion:^(BOOL finished) {
		[UIView animateWithDuration:0.5 animations:^{
			underLabel.alpha = 1;
		}completion:nil];
	}];
}


- (void)openTwitter {
	NSURL *url;

	if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"tweetbot:"]]) {
		url = [NSURL URLWithString:@"tweetbot:///user_profile/kaitouiet"];
	} else if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"twitterrific:"]]) {
		url = [NSURL URLWithString:@"twitterrific:///profile?screen_name=kaitouiet"];
	} else if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"tweetings:"]]) {
		url = [NSURL URLWithString:@"tweetings:///user?screen_name=kaitouiet"];
	} else if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"twitter:"]]) {
		url = [NSURL URLWithString:@"twitter://user?screen_name=kaitouiet"];
	} else {
		url = [NSURL URLWithString:@"http://mobile.twitter.com/kaitouiet"];
	}

	// [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:nil];
	[[UIApplication sharedApplication] openURL:url];
}

- (void)dismiss {
	[[UIApplication sharedApplication] sendAction:@selector(resignFirstResponder) to:nil from:nil forEvent:nil]; // Dismisses keyboard
}

@end
