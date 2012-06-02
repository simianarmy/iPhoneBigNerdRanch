//
//  GlissView.h
//  Gliss
//
//  Created by Marc Mauger on 11/19/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface GlissView : NSOpenGLView 
{
	IBOutlet NSMatrix *sliderMatrix;
	float lightX, theta, radius;
	int displayList;
}
- (IBAction)changeParameter:(id)sender;

@end
