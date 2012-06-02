//
//  BigLetterView.m
//  TypingTutor
//
//  Created by Marc Mauger on 10/23/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "BigLetterView.h"
#import "FirstLetter.h"

// Declare private methods here
@interface BigLetterView ()
- (void)prepareAttributes;
- (void)drawStringCenteredIn:(NSRect)r;
@end

@implementation BigLetterView

- (id)initWithFrame:(NSRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
		[self prepareAttributes];
        bgColor = [[NSColor yellowColor] retain];
		string = @" ";
		bold = italic = NO;
		[self registerForDraggedTypes:
		 [NSArray arrayWithObject:NSStringPboardType]];
	}
    return self;
}

- (void)drawRect:(NSRect)rect {
    NSRect bounds = [self bounds];
	// Draw gradient background if highlighted
	if (highlighted) {
		NSGradient *gr;
		gr = [[NSGradient alloc] initWithStartingColor:[NSColor whiteColor]
										   endingColor:bgColor];
		[gr drawInRect:bounds relativeCenterPosition:NSZeroPoint];
		[gr release];
	} else {
		[bgColor set];
		[NSBezierPath fillRect:bounds];
	}
	[self drawStringCenteredIn:bounds];
	
	// Am I window's 1st responder?
	if (([[self window] firstResponder] == self) && 
			[NSGraphicsContext currentContextDrawingToScreen]) {
		[NSGraphicsContext saveGraphicsState];
		NSSetFocusRingStyle(NSFocusRingOnly);
		[NSBezierPath strokeRect:bounds];
		[NSGraphicsContext restoreGraphicsState];
	}
}

- (void)prepareAttributes
{
	attributes = [[NSMutableDictionary alloc] init];
	shadow = [[NSShadow alloc] init];
	NSSize shadowOffsetSize;
	shadowOffsetSize.width = 10;
	shadowOffsetSize.height = -10;
	
	[shadow setShadowColor:[NSColor blackColor]];
	[shadow setShadowBlurRadius:2.0];
	[shadow setShadowOffset:shadowOffsetSize];
	
	[attributes setObject:[NSFont fontWithName:@"Helvetica" size:75]
				   forKey:NSFontAttributeName];
	[attributes setObject:[NSColor redColor]
				   forKey:NSForegroundColorAttributeName];
	[attributes setObject:shadow forKey:NSShadowAttributeName];
}

- (void)drawStringCenteredIn:(NSRect)r
{
	NSSize strSize = [string sizeWithAttributes:attributes];
	NSPoint strOrigin;
	strOrigin.x = r.origin.x + (r.size.width - strSize.width)/2;
	strOrigin.y = r.origin.y + (r.size.height - strSize.height)/2;
	[string drawAtPoint:strOrigin withAttributes:attributes];
}

- (void)writeToPasteboard:(NSPasteboard *)pb
{
	// Declare types
	NSArray *ptypes = [NSArray arrayWithObjects:NSStringPboardType, NSPDFPboardType, nil];
	[pb declareTypes:ptypes
			   owner:self];
	 
	// Copy data to the pasteboard
	[pb setString:string forType:NSStringPboardType];

	NSRect r = [self bounds];
	NSData *data = [self dataWithPDFInsideRect:r];
	[pb setData:data forType:NSPDFPboardType];
}

- (BOOL)readFromPasteboard:(NSPasteboard *)pb
{
	// Is there a string on the pasteboard
	NSArray *types = [pb types];
	if ([types containsObject:NSStringPboardType]) {
		// Read the string from the pasteboard
		NSString *value = [pb stringForType:NSStringPboardType];
		
		[self setString:[value BNR_firstLetter]];
		return YES;
	}
	return NO;
}
	
- (void)dealloc
{
	[bgColor release];
	[string release];
	[shadow release];
	[super dealloc];
}

#pragma mark Events

- (BOOL)isOpaque
{
	return YES;
}

- (BOOL)acceptsFirstResponder
{
	NSLog(@"Accepting");
	return YES;
}

- (BOOL)resignFirstResponder
{
	NSLog(@"Resigning");
	[self setKeyboardFocusRingNeedsDisplayInRect:[self bounds]];
	return YES;
}

- (BOOL)becomeFirstResponder
{
	NSLog(@"Becoming");
	[self setNeedsDisplay:YES];
	return YES;
}

- (void)keyDown:(NSEvent *)theEvent
{
	[self interpretKeyEvents:[NSArray arrayWithObject:theEvent]];
}

- (void)mouseDown:(NSEvent *)event
{
	[event retain];
	[mouseDownEvent release];
	mouseDownEvent = event;
}

- (void)mouseDragged:(NSEvent *)theEvent
{
	NSPoint down = [mouseDownEvent locationInWindow];
	NSPoint drag = [theEvent locationInWindow];
	float distance = hypot(down.x - drag.x, down.y - drag.y);
	if (distance < 3) {
		return;
	}
	
	if ([string length] == 0) {
		return;
	}
	// Get the size of the the string
	NSSize s = [string sizeWithAttributes:attributes];
	
	// Create the image that will be dragged
	NSImage *anImage = [[NSImage alloc] initWithSize:s];
	
	// Create a rect in which you will draw the letter in the image
	NSRect imageBounds;
	imageBounds.origin = NSZeroPoint;
	imageBounds.size = s;
	
	// Draw the letter on the image
	[anImage lockFocus];
	[self drawStringCenteredIn:imageBounds];
	[anImage unlockFocus];
	
	// Get the location of the mouseDown event
	NSPoint p = [self convertPoint:down fromView:nil];
	
	// Drag from the center of the image
	p.x = p.x - s.width/2;
	p.y = p.y - s.height/2;
	
	// Get the pasteboard
	NSPasteboard *pb = [NSPasteboard pasteboardWithName:NSDragPboard];
	
	// put the string on the pasteboard
	[self writeToPasteboard:pb];
	
	// Start the drag
	[self dragImage:anImage
				 at:p 
			 offset:NSMakeSize(0, 0) 
			  event:mouseDownEvent 
		 pasteboard:pb 
			 source:self 
		  slideBack:YES];
	
	[anImage release];
}
- (void)insertText:(id)insertString
{
	[self setString:insertString];
}

- (void)insertTab:(id)sender
{
	[[self window] selectKeyViewFollowingView:self];
}

- (void)insertBacktab:(id)sender
{
	[[self window] selectKeyViewPrecedingView:self];
}

- (void)deleteBackward:(id)sender
{
	[self setString:@" "];
}

- (IBAction)boldButtonPressed:(id)sender
{
	bold = [boldCheckbox state];
	NSLog(@"bold changed: %d", bold);
	NSFontManager *fontManager = [NSFontManager sharedFontManager];
	NSFont *currentFont = [attributes objectForKey:NSFontAttributeName];

	if (bold == YES) {
		currentFont = [fontManager convertFont:currentFont 
							toHaveTrait:NSBoldFontMask];
	} else {
		currentFont = [fontManager convertFont:currentFont 
								   toNotHaveTrait:NSBoldFontMask];
	}
	[attributes setObject:currentFont
				   forKey:NSFontAttributeName];
	[self setNeedsDisplay:YES];
}

- (IBAction)italicButtonPressed:(id)sender
{
	italic = [italicCheckbox state];
	NSLog(@"italic changed: %d", italic);
	NSFontManager *fontManager = [NSFontManager sharedFontManager];
	NSFont *currentFont = [attributes objectForKey:NSFontAttributeName];
	
	if (italic == YES) {
		currentFont = [fontManager convertFont:currentFont 
								   toHaveTrait:NSItalicFontMask];
	} else {
		currentFont = [fontManager convertFont:currentFont 
								toNotHaveTrait:NSItalicFontMask];
	}
	[attributes setObject:currentFont
				   forKey:NSFontAttributeName];
	[self setNeedsDisplay:YES];
	
}

- (IBAction)cut:(id)sender
{
	[self copy:sender];
	[self setString:@""];
}

- (IBAction)copy:(id)sender
{
	NSPasteboard *pb = [NSPasteboard generalPasteboard];
	[self writeToPasteboard:pb];
}

- (IBAction)paste:(id)sender
{
	NSPasteboard *pb = [NSPasteboard generalPasteboard];
	if (![self readFromPasteboard:pb]) {
		NSBeep();
	}
}

- (NSDragOperation)draggingSourceOperationMaskForLocal:(BOOL)isLocal
{
	return NSDragOperationCopy | NSDragOperationDelete;
}

- (void)draggedImage:(NSImage *)image 
			 endedAt:(NSPoint)screenPoint
		   operation:(NSDragOperation)operation
{
	if (operation == NSDragOperationDelete) {
		[self setString:@""];
	}
}

- (NSDragOperation)draggingEntered:(id <NSDraggingInfo>)sender
{
	NSLog(@"draggingEntered:");
	if ([sender draggingSource] == self) {
		return NSDragOperationNone;
	}
	highlighted = YES;
	[self setNeedsDisplay:YES];
	return NSDragOperationCopy;
}

- (NSDragOperation)draggingUpdated:(id <NSDraggingInfo>)sender
{
	NSDragOperation op = [sender draggingSourceOperationMask];
	NSLog(@"operation mask = %d", op);
	if ([sender draggingSource] == self) {
		return NSDragOperationNone;
	}
	return NSDragOperationCopy;
}

- (void)draggingExited:(id <NSDraggingInfo>)sender
{
	NSLog(@"draggingExited:");
	highlighted = NO;
	[self setNeedsDisplay:YES];
}

- (BOOL)prepareForDragOperation:(id <NSDraggingInfo>)sender
{
	return YES;
}

- (BOOL)performDragOperation:(id <NSDraggingInfo>)sender
{
	NSPasteboard *pb = [sender draggingPasteboard];
	if (![self readFromPasteboard:pb]) {
		NSLog(@"Error: Could not read from dragging pasteboard");
		return NO;
	}
	return YES;
}

- (void)concludeDragOperation:(id <NSDraggingInfo>)sender
{
	NSLog(@"concludeDragOperation");
	highlighted = NO;
	[self setNeedsDisplay:YES];
}
	

#pragma mark Accessors

- (void)setBgColor:(NSColor *)c
{
	[c retain];
	[bgColor release];
	bgColor = c;
	[self setNeedsDisplay:YES];
}

- (NSColor *)bgColor
{
	return bgColor;
}

- (void)setString:(NSString *)c
{
	c = [c copy];
	[string release];
	string = c;
	NSLog(@"The string is now %@", string);
	[self setNeedsDisplay:YES];
}

- (NSString *)string
{
	return string;
}

- (IBAction)savePDF:(id)sender
{
	NSSavePanel *panel = [NSSavePanel savePanel];
	[panel setRequiredFileType:@"pdf"];
	[panel beginSheetForDirectory:nil
							file:nil 
				   modalForWindow:[self window]
					modalDelegate:self
				   didEndSelector:@selector(didEnd:returnCode:contextInfo:)
					  contextInfo:NULL];
}

- (void)didEnd:(NSSavePanel *)sheet 
	returnCode:(int)code 
   contextInfo:(void *)contextInfo
{
	if (code != NSOKButton)
		return;
	
	NSRect r = [self bounds];
	NSData *data = [self dataWithPDFInsideRect:r];
	NSString *path = [sheet filename];
	NSError *error;
	BOOL successful = [data writeToFile:path
								options:0
								  error:&error];
	
	if (!successful) {
		NSAlert *a = [NSAlert alertWithError:error];
		[a runModal];
	}
}

@end
