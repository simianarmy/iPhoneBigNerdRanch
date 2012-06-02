/*
 *  FileHelpers.c
 *  Homepwner
 *
 *  Created by Marc Mauger on 12/19/10.
 *  Copyright 2010 __MyCompanyName__. All rights reserved.
 *
 */

#include "FileHelpers.h"

NSString *pathInDocumentDirectory(NSString *fileName)
{
	// Get list of document directories in sandbox
	NSArray *documentDirectories = 
		NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
											NSUserDomainMask, YES);

	// Get one and only document dir from that list
	NSString *documentDirectory = [documentDirectories objectAtIndex:0];

	// Append passed in file name to that dir, return it
	return [documentDirectory stringByAppendingPathComponent:fileName];
}
