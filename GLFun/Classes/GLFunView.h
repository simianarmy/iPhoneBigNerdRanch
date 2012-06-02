//
//  GLFunView.h
//  GLFun
//
//  Created by Marc Mauger on 7/16/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Constants.h"
#import "OpenGLES2DView.h"

@class Texture2D;

@interface GLFunView : OpenGLES2DView {
	CGPoint	firstTouch;
	CGPoint	lastTouch;
	UIColor *currentColor;
	BOOL	useRandomColor;
	ShapeType	shapeType;
	Texture2D	*sprite;
}
@property CGPoint firstTouch;
@property CGPoint lastTouch;
@property (nonatomic, retain) UIColor *currentColor;
@property BOOL useRandomColor;
@property ShapeType shapeType;
@property (nonatomic, retain) Texture2D *sprite;

@end
