//
//  ItemDetailViewController.h
//  Homepwner
//
//  Created by Marc Mauger on 12/12/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AddressBookUI/AddressBookUI.h>

@class Possession;

@interface ItemDetailViewController : UIViewController 
<UINavigationControllerDelegate, UIImagePickerControllerDelegate, 
UIPopoverControllerDelegate, ABPeoplePickerNavigationControllerDelegate> {
	IBOutlet UITextField *nameField;
	IBOutlet UITextField *serialNumberField;
	IBOutlet UITextField *valueField;
	IBOutlet UILabel *dateLabel;
	IBOutlet UIImageView *imageView;
	IBOutlet UIButton *clearImageButton;
	IBOutlet UILabel *inheritorNameField;
	IBOutlet UILabel *inheritorNumberField;
	
	Possession *editingPossession;
	UIPopoverController *imagePickerPopover;
}
@property (nonatomic, assign) Possession *editingPossession;

- (IBAction)chooseInheritor:(id)sender;
- (void)clearImage:(id)sender;

@end
