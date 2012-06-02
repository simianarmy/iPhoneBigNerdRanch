//
//  QuizInfoAppDelegate.m
//  QuizInfo
//
//  Created by Marc Mauger on 11/21/10.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

#import "QuizInfoAppDelegate.h"

@implementation QuizInfoAppDelegate

@synthesize window;

- (id)init
{
	[super init];
	
	questions = [[NSMutableArray alloc] init];
	answers = [[NSMutableArray alloc] init];
	
	[questions addObject:@"What is your name?"];
	[answers addObject:@"your momma knows"];
	[questions addObject:@"What is your favorite color?"];
	[answers addObject:@"fuck yourself"];
	[questions addObject:@"What is your favorite movie?"];
	[answers addObject:@"*?!@ yourself"];

	return self;
}

- (IBAction)showQuestion:(id)sender
{
	currentQuestionIndex++;
	
	if (currentQuestionIndex == [questions count]) {
		currentQuestionIndex = 0;
	}
	NSString *question = [questions objectAtIndex:currentQuestionIndex];
	
	[questionField setText:question];
	
	[answerField setText:@"???"];
}

- (IBAction)showAnswer:(id)sender
{
	NSString *answer = [answers objectAtIndex:currentQuestionIndex];
	[answerField setText:answer];
}


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {    

    // Override point for customization after application launch
	
    [window makeKeyAndVisible];
	
	return YES;
}


- (void)dealloc {
    [window release];
    [super dealloc];
}


@end
