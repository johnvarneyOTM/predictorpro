//
//  UINavigationBar+Background.m
//  PredictorPro
//
//  Created by Oliver Relph on 12/07/2010.
//  Copyright 2010 Sumac. All rights reserved.
//

#import "UINavigationBar+Background.h"


@implementation UINavigationBar (Background)

- (void)drawRect:(CGRect)rect {
	
	UIColor *color = [UIColor blackColor];
	UIImage *img = [UIImage imageNamedFallbackToPng:@"navBarBg"];
	[img drawInRect:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
	self.tintColor = color;
}

@end
