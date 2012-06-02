//
//  PinchMeViewController.h
//  PinchMe
//
//  Created by Marc Mauger on 7/17/11.
//  Copyright 2011 Simian Labs. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kMinimumPinchDelta	100

@interface PinchMeViewController : UIViewController {
	UILabel *label;
	CGFloat initialDistance;
}
@property (nonatomic, retain) IBOutlet UILabel *label;
@property CGFloat initialDistance;
-(void)eraseLabel;

@end

