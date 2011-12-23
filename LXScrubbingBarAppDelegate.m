//
//  LXScrubbingBarAppDelegate.m
//  LXScrubbingBar
//
//  Created by Keefo on 10-07-06.
//  Copyright 2010 Beyondcow.com. All rights reserved.
//

#import "LXScrubbingBarAppDelegate.h"

@implementation LXScrubbingBarAppDelegate
@synthesize window;
@synthesize progressField;
@synthesize scrubbingbar;

- (void)awakeFromNib{
	[scrubbingbar setMaxValue:100.0];
	[scrubbingbar setDoubleValue:47.0];
	[progressField setStringValue:[NSString stringWithFormat:@"%f",[scrubbingbar doubleValue]]];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(scrubbingbarDidChange:) name:@"LXScrubbingBarChangedNotification" object:nil];
}

- (void)dealloc{
	[[NSNotificationCenter defaultCenter] removeObserver:self name:@"LXScrubbingBarChangedNotification" object:nil];
	[super dealloc];
}
- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
	// Insert code here to initialize your application 
}

- (void)scrubbingbarDidChange:(NSNotification *)aNotification {
	NSNumber *progress=[[aNotification userInfo] objectForKey:@"LXScrubbingBarValue"];
	[progressField setStringValue:[NSString stringWithFormat:@"%f",[progress floatValue]]];
}

- (IBAction)setGlowing:(id)sender
{
	[scrubbingbar setGlowingSize:[sender doubleValue]];
}

@end
