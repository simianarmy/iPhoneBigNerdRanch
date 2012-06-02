//
//  AppController.h
//  KVCFun
//
//  Created by Marc Mauger on 8/15/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface AppController : NSObject {
	int fido;
}
- (int)fido;
- (void)setFido:(int)x;
- (IBAction)incrementFido:(id)sender;
@end
