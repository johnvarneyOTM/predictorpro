//
//  UIImage+UniversalApp.m
//  TouchCustoms
//
//  Created by Aleks Nesterow on 6/17/10.
//	aleks.nesterow@gmail.com
//	
//  Copyright © 2010 Screen Customs s.r.o.
//	All rights reserved.
//

#import "UIImage+UniversalApp.h"

@implementation UIImage (UniversalApp)

+ (UIImage *)imageNamedFallbackToPng:(NSString *)path {

	return [UIImage imageNamed:path fallbackToExtension:@"png"];
}

+ (UIImage *)imageNamed:(NSString *)path fallbackToExtension:(NSString *)extension {
	
    if (path.length == 0) {
        NSLog(@"missing path");
    }
	UIImage *result = [UIImage imageNamed:path];
	
	if (!result) {
		NSString *newPath = [path stringByAppendingPathExtension:extension];
		result = [UIImage imageNamed:newPath];
	}
    
    if (result == nil) {
        NSLog(@"missing image");
    }
	
	return result;
}

@end
