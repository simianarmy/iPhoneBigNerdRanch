//
//  QuizInfoAppDelegate.h
//  QuizInfo
//
//  Created by Marc Mauger on 11/21/10.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QuizInfoAppDelegate : NSObject <UIApplicationDelegate> {
	int currentQuestionIndex;
	
	// Model objects
	NSMutableArray *questions;
	NSMutableArray *answers;
	
	// View objects
	IBOutlet UILabel *questionField;
	IBOutlet UILabel *answerField;
	
    UIWindow *window;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;

- (IBAction)showQuestion:(id)sender;
- (IBAction)showAnswer:(id)sender;

@end

