//
//  SwipesViewController.h
//  Swipes
//
//  Created by Marc Mauger on 7/17/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kMinimumGestureLength	25
#define kMaximumVariance		5

typedef enum {
	kNoSwipe = 0,
	kHorizontalSwipe,
	kVerticalSwipe
} SwipeType;

@interface SwipesViewController : UIViewController {
	UILabel	*label;
	CGPoint	gestureStartPoint;
}
@property (nonatomic, retain) IBOutlet UILabel *label;
@property CGPoint gestureStartPoint;
- (void)eraseText;

@end

