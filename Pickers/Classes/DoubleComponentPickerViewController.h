//
//  DoubleComponentPickerViewController.h
//  Pickers
//
//  Created by Marc Mauger on 7/9/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

const uint kPickerMainCourse	= 0;
const uint kPickerBread			= 1;

@interface DoubleComponentPickerViewController : UIViewController 
	<UIPickerViewDelegate, UIPickerViewDataSource> {
	UIPickerView *doublePicker;
	NSArray *pickerData;
}
@property (nonatomic, retain) IBOutlet UIPickerView *doublePicker;
@property (nonatomic, retain) NSArray *pickerData;
- (IBAction)buttonPressed;

@end
