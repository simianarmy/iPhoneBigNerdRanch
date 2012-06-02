//
//  QuartzFunView.h
//  QuartzFun
//
//  Created by Marc Mauger on 7/16/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Constants.h"

@interface QuartzFunView : UIView {
	CGPoint	firstTouch;
	CGPoint	lastTouch;
	UIColor	*currentColor;
	ShapeType shapeType;
	UIImage *drawImage;
	BOOL useRandomColor;
	CGRect redrawRect;
}
@property CGPoint firstTouch;
@property CGPoint lastTouch;
@property (nonatomic, retain) UIColor *currentColor;
@property ShapeType shapeType;
@property (nonatomic, retain) UIImage *drawImage;
@property BOOL useRandomColor;
@property (readonly) CGRect currentRect;
@property CGRect redrawRect;

@end
