//
//  CustomPickerViewController.h
//  Pickers
//
//  Created by Marc Mauger on 7/9/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AudioToolbox/AudioToolbox.h>

@interface CustomPickerViewController : UIViewController 
<UIPickerViewDataSource, UIPickerViewDelegate> {
	UIPickerView *picker;
	UILabel *winLabel;
	NSArray *column1;
	NSArray *column2;
	NSArray *column3;
	NSArray *column4;
	NSArray *column5;
	UIButton *button;
}
@property (nonatomic, retain) IBOutlet UIPickerView *picker;
@property (nonatomic, retain) IBOutlet UILabel *winLabel;
@property (nonatomic, retain) NSArray *column1;
@property (nonatomic, retain) NSArray *column2;
@property (nonatomic, retain) NSArray *column3;
@property (nonatomic, retain) NSArray *column4;
@property (nonatomic, retain) NSArray *column5;
@property (nonatomic, retain) IBOutlet UIButton *button;
-(IBAction)spin;
@end
