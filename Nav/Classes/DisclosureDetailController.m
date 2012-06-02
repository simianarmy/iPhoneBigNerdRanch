//
//  DisclosureDetailController.m
//  Nav
//
//  Created by Marc Mauger on 7/10/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "DisclosureDetailController.h"

@implementation DisclosureDetailController
@synthesize label;
@synthesize message;

- (void)viewWillAppear:(BOOL)animated {
	label.text = message;
	[super viewWillAppear:animated];
}

- (void)viewdidUnload {
	self.label = nil;
	self.message = nil;
	[super viewDidUnload];
}

- (void)dealloc {
	[label release];
	[message release];
	[super dealloc];
}
@end
