//
//  LXScrubbingBar.h
//  LXScrubbingBar
//
//  Created by Keefo on 10-07-06.
//  Copyright 2010 Beyondcow.com. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface LXScrubbingBar : NSProgressIndicator {
	BOOL isMouseDown;
	CGFloat glowingSize;
	CGColorRef	glowingColor;
	NSColor *leftColor;
	NSDate	*lastpostdate;
}

- (void) mouseDown:(NSEvent *)theEvent;
- (void) mouseDragged:(NSEvent *)theEvent;

- (void) drawRect:(NSRect)aRect;
- (void) setGlowingSize:(CGFloat)size;

@end
