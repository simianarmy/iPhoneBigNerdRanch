//
//  DependentComponentPickerViewController.h
//  Pickers
//
//  Created by Marc Mauger on 7/9/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#define kStateComponent	0
#define kZipComponent 1

@interface DependentComponentPickerViewController : UIViewController 
	<UIPickerViewDelegate, UIPickerViewDataSource> {
		UIPickerView *picker;
		NSDictionary *stateZips;
		NSArray *states;
		NSArray *zips;
}
@property (retain, nonatomic) IBOutlet UIPickerView *picker;
@property (retain, nonatomic) NSDictionary *stateZips;
@property (retain, nonatomic) NSArray *states;
@property (retain, nonatomic) NSArray *zips;
- (IBAction) buttonPressed;

@end
