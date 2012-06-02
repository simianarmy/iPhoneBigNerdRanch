//
//  SwitchViewController.h
//  View Switcher
//
//  Created by Marc Mauger on 7/8/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BlueViewController;
@class YellowViewController;

@interface SwitchViewController : UIViewController {
	BlueViewController *blueViewController;
	YellowViewController *yellowViewController;
}
@property (retain, nonatomic) BlueViewController *blueViewController;
@property (retain, nonatomic) YellowViewController *yellowViewController;

-(IBAction)switchViews:(id)sender;

@end
