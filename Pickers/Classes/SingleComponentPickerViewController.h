//
//  SingleComponentPickerViewController.h
//  Pickers
//
//  Created by Marc Mauger on 7/9/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface SingleComponentPickerViewController : UIViewController 
	<UIPickerViewDelegate, UIPickerViewDataSource> {
		UIPickerView *singlePicker;
		NSArray *pickerData;
}
@property (nonatomic, retain) IBOutlet UIPickerView *singlePicker;
@property (nonatomic, retain) NSArray *pickerData;
- (IBAction)buttonPressed;

@end
