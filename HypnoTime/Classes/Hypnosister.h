//
//  Hypnosister.h
//  Hypnosister
//
//  Created by Marc Mauger on 12/5/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@class HypnoLayer;
@interface Hypnosister : UIView {
	CALayer *boxLayer;
	HypnoLayer *hypnoLayer;
	UIColor *stripeColor;
	float xShift, yShift;
}
@property (nonatomic, assign) float xShift;
@property (nonatomic, assign) float yShift;

@end
