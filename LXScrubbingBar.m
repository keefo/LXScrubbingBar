//
//  LXScrubbingBar.m
//  LXScrubbingBar
//
//  Created by Keefo on 10-07-06.
//  Copyright 2010 Beyondcow.com. All rights reserved.
//

#import "LXScrubbingBar.h"

@implementation LXScrubbingBar

- (void)awakeFromNib
{
	isMouseDown=NO;
	leftColor=[[NSColor colorWithCalibratedRed:241.0/256.0 green:0 blue:140.0/256.0 alpha:1.0] retain];
	{
		CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB ();
		CGColorSpaceRelease (colorSpace);
		NSColor *deviceColor = [leftColor colorUsingColorSpaceName:NSDeviceRGBColorSpace];
		CGFloat components[4];
		[deviceColor getRed:&components[0] green:&components[1] blue:&components[2] alpha:&components[3]];
		glowingColor = CGColorCreate (colorSpace, components);
	}
	
	glowingSize=7.0;
	
	lastpostdate=[[NSDate date] retain];
	
	[self display];
}

- (id)initWithFrame:(NSRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self awakeFromNib];
    }
    return self;
}

- (void) dealloc
{
	CGColorRelease (glowingColor);
	[leftColor release];
	[super dealloc];
}

- (void) setGlowingSize:(CGFloat)size
{
	glowingSize=size;
	[self setNeedsDisplay:YES];
}

- (void)drawRect:(NSRect)dirtyRect {
	
	NSImage *canvas = [[[NSImage alloc] initWithSize:[self bounds].size] autorelease];
	NSRect canvasRect=NSMakeRect(0, 0, [canvas size].width, [canvas size].height);
	
	[canvas lockFocus];
	
	NSRect slideRect = canvasRect;
	slideRect.size.height=1;
	slideRect.origin.y += roundf((canvasRect.size.height - slideRect.size.height) / 2)-1;
	slideRect.size.width-=6;
	slideRect.origin.x += 2;
	
	[[NSColor grayColor] set];
	NSRectFill(slideRect);
	
	[leftColor set];
	
	if (glowingSize>0.0) {
		CGContextRef c = (CGContextRef)[[NSGraphicsContext currentContext] graphicsPort];
		CGContextSetShadowWithColor(c, CGSizeZero, glowingSize, glowingColor);		
	}
	
	slideRect.size.width=slideRect.size.width*[self doubleValue]/[self maxValue];
	NSRectFill(slideRect);
	
	
	NSRect knobRect=slideRect;
	knobRect.origin.x+=knobRect.size.width-3;
	if (knobRect.origin.x<0) {
		knobRect.origin.x=0;
	}
	knobRect.size.width=6;
	knobRect.size.height=6;
	knobRect.origin.y-=3;
	
	[leftColor set];
	NSBezierPath *p = [NSBezierPath bezierPath];
	[p appendBezierPathWithOvalInRect:knobRect];
	[p fill];	
	
	[canvas unlockFocus];
	
	[canvas drawInRect:dirtyRect fromRect:dirtyRect operation:NSCompositeSourceOver fraction:1.0];
	
}


- (void)mouseDown:(NSEvent *)theEvent
{
	NSPoint thePoint = [self convertPoint:[theEvent locationInWindow] fromView:nil];
	if(NSPointInRect(thePoint, [self bounds])){
		isMouseDown=YES;
		[self mouseDragged:theEvent];
	}
}

- (void)mouseUp:(NSEvent *)theEvent
{
	isMouseDown=NO;
}

- (void)mouseDragged:(NSEvent *)theEvent
{
	if (isMouseDown) {
		NSPoint thePoint = [self convertPoint:[theEvent locationInWindow] fromView:nil];
		double theValue;
		double maxX=[self bounds].size.width;
		
		if (thePoint.x < 0)
			theValue = [self minValue];
		else if (thePoint.x >= [self bounds].size.width)
			theValue = [self maxValue];
		else
			theValue = [self minValue] + (([self maxValue] - [self minValue]) *
										  (thePoint.x - 0) / (maxX - 0));
		[self setDoubleValue:theValue];
		
		NSDate *now=[[NSDate date] retain];
		NSTimeInterval diff = [now timeIntervalSinceDate:lastpostdate];
		if (diff>0.08) {  
			//Some times we do not want this bar post notification too often
			//So, here is a test before post any notification through time interval;
			[[NSNotificationCenter defaultCenter]
			 postNotificationName:@"LXScrubbingBarChangedNotification"
			 object:self
			 userInfo:[NSDictionary 
					   dictionaryWithObject:[NSNumber numberWithDouble:theValue]
					   forKey:@"LXScrubbingBarValue"]];
			[lastpostdate release];
			lastpostdate=now;			
		}
		
		
		[self display];
	}
}

- (BOOL)mouseDownCanMoveWindow
{
	return NO;
}

- (BOOL)acceptsFirstMouse:(NSEvent *)theEvent
{
	return YES;
}

- (BOOL)isFlipped
{	
	return NO;
}

@end
