//
//  DisclosureDetailController.h
//  Nav
//
//  Created by Marc Mauger on 7/10/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface DisclosureDetailController : UIViewController {
	UILabel *label;
	NSString *message;
}
@property (nonatomic, retain) IBOutlet UILabel *label;
@property (nonatomic, retain) NSString *message;

@end
