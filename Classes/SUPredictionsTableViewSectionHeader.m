//
//  SUPredictionsTableViewSectionHeader.m
//  PredictorPro
//
//  Created by Oliver Relph on 30/06/2010.
//  Copyright 2010  Sumac. All rights reserved.
//

#import "SUPredictionsTableViewSectionHeader.h"
#import <QuartzCore/QuartzCore.h>
#include <stdlib.h>

@implementation SUPredictionsTableViewSectionHeader

- (void)dealloc {
    [super dealloc];
}

- (id)initWithFrame:(CGRect)viewFrame sectionTitle:(NSString *)sectionTitle {
    if ((self = [super initWithFrame:viewFrame])) {
        // Initialization code
		
		// Create label with section title
		UILabel *label = [[[UILabel alloc] init] autorelease];
		label.frame = CGRectMake(20, 5, 300, 16);
		label.backgroundColor = [UIColor clearColor];
		label.textColor = [UIColor whiteColor];
		label.shadowColor = [UIColor blackColor];
		label.shadowOffset = CGSizeMake(0.0, 1.0);
		label.font = [UIFont boldSystemFontOfSize:16];
		label.text = sectionTitle;
				
		// Throw a gradient as the background
		self.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"sectionHeader" ofType:@"png" inDirectory:@"/"]]];

		
		[self addSubview:label];
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/


@end
