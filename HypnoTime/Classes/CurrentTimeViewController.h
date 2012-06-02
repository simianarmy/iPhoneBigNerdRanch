//
//  CurrentTimeViewController.h
//  HypnoTime
//
//  Created by Marc Mauger on 12/5/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface CurrentTimeViewController : UIViewController {
	IBOutlet UILabel *timeLabel;
	IBOutlet UIButton *timeButton;
}
@property (nonatomic, retain) UIButton *timeButton;

- (IBAction)showCurrentTime:(id)sender;

@end
