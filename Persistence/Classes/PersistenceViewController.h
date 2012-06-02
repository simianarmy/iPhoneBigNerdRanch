//
//  PersistenceViewController.h
//  Persistence
//
//  Created by Marc Mauger on 7/14/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "/usr/include/sqlite3.h"

//#define kFilename	@"data.plist"
#define kFilename	@"data.sqlite3"

@interface PersistenceViewController : UIViewController {
	UITextField *field1;
	UITextField *field2;
	UITextField *field3;
	UITextField *field4;
	
	sqlite3	*database;
}
@property (nonatomic, retain) IBOutlet UITextField *field1;
@property (nonatomic, retain) IBOutlet UITextField *field2;
@property (nonatomic, retain) IBOutlet UITextField *field3;
@property (nonatomic, retain) IBOutlet UITextField *field4;
- (NSString *)dataFilePath;
- (void)applicationWillTerminate:(NSNotification *)notification;
@end

