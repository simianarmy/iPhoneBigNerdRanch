//
//  MyDocument.h
//  Departments
//
//  Created by Marc Mauger on 11/13/10.
//  Copyright __MyCompanyName__ 2010 . All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class ManagingViewController;

@interface MyDocument : NSPersistentDocument {
	IBOutlet NSBox *box;
	IBOutlet NSPopUpButton *popUp;
	NSMutableArray *viewControllers;
}
- (IBAction)changeViewController:(id)sender;
- (void)displayViewController:(ManagingViewController *)vc;

@end
