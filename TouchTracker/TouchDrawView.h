//
//  TouchDrawView.h
//  TouchTracker
//
//  Created by Marc Mauger on 12/26/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface TouchDrawView : UIView {
	NSMutableDictionary *linesInProcess;
	NSMutableDictionary *circlesInProcess;
	NSMutableArray *completeLines;
	NSMutableArray *completeCircles;
}
- (NSMutableArray *)completedLines;
- (NSMutableArray *)completedCircles;
- (void)archiveLines;
- (NSString *)completedLinesPath;
@end
