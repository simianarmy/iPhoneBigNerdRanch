//
//  ImageCache.m
//  Homepwner
//
//  Created by Marc Mauger on 12/17/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "ImageCache.h"

static ImageCache *sharedImageCache;

@implementation ImageCache
- (id)init
{
	[super init];
	dictionary = [[NSMutableDictionary alloc] init];
	NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
	[nc addObserver:self selector:@selector(clearCache:)
			   name:UIApplicationDidReceiveMemoryWarningNotification 
			 object:nil];
	
	return self;
}

#pragma mark Accessing the cache

- (void)setImage:(UIImage *)i forKey:(NSString *)s
{
	[dictionary setObject:i forKey:s];
	
	NSString *imagePath = pathInDocumentDirectory(s);
	
	// Turn image into JPEG data
	NSData *d = UIImageJPEGRepresentation(i, 0.5);
	
	[d writeToFile:imagePath atomically:YES];
}

- (UIImage *)imageForKey:(NSString *)s
{
	// If possible, get if from the dictionary
	UIImage *result = [dictionary objectForKey:s];
	
	if (!result) {
		// Create UIImage object from the file
		result = [UIImage imageWithContentsOfFile:pathInDocumentDirectory(s)];
		
		// If we found an image on the filesystem, place it into the cache
		if (result)
			[dictionary setObject:result forKey:s];
		else 
			NSLog(@"Error: unable to find %@", pathInDocumentDirectory(s));
	}
	return result;
}

- (void)deleteImageForKey:(NSString *)s
{
	[dictionary removeObjectForKey:s];
	NSString *path = pathInDocumentDirectory(s);
	[[NSFileManager defaultManager] removeItemAtPath:path error:nil];
}

- (void)clearCache:(NSNotification *)none
{
	NSLog(@"flushing %d images out of the cache", [dictionary count]);
	[dictionary removeAllObjects];
}

#pragma mark Singleton stuff

+ (ImageCache *)sharedImageCache
{
	if (!sharedImageCache) {
		sharedImageCache = [[ImageCache alloc] init];
	}
	return sharedImageCache;
}

+ (id)allocWithZone:(NSZone *)zone
{
	if (!sharedImageCache) {
		sharedImageCache = [super allocWithZone:zone];
		return sharedImageCache;
	} else {
		return nil;
	}
}

- (id)copyWithZone:(NSZone *)zone
{
	return self;
}

- (void)release
{
	// No op
}

@end
