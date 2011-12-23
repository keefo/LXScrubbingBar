//
//  LXScrubbingBarAppDelegate.h
//  LXScrubbingBar
//
//  Created by Keefo on 10-07-06.
//  Copyright 2010 Beyondcow.com. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "LXScrubbingBar.h"
@interface LXScrubbingBarAppDelegate : NSObject <NSApplicationDelegate> {
    NSWindow *window;
	NSTextField	*progressField;
	LXScrubbingBar *scrubbingbar;
}

@property (assign) IBOutlet NSWindow *window;
@property (assign) IBOutlet NSTextField *progressField;
@property (assign) IBOutlet LXScrubbingBar *scrubbingbar;

- (IBAction)setGlowing:(id)sender;

@end
