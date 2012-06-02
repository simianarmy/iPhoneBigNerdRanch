//
//  DatePickerViewController.h
//  Pickers
//
//  Created by Marc Mauger on 7/9/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface DatePickerViewController : UIViewController {
	UIDatePicker *datePicker;
}
@property (nonatomic, retain) IBOutlet UIDatePicker *datePicker;
-(IBAction)buttonPressed;

@end
