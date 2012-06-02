//
//  HypnoLayer.h
//  HypnoTime
//
//  Created by Marc Mauger on 12/27/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface HypnoLayer : NSObject {
	CGRect viewFrame;
	float superLayerY;
}
@property (nonatomic, assign) float superLayerY;
@property (nonatomic, assign) CGRect viewFrame;

- (float)getBoxOpacity;
@end
