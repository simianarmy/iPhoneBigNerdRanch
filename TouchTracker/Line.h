//
//  Line.h
//  TouchTracker
//
//  Created by Marc Mauger on 12/26/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Line : NSObject <NSCoding> {
	CGPoint begin;
	CGPoint end;
}
@property (nonatomic) CGPoint begin;
@property (nonatomic) CGPoint end;

@end
