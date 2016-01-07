//
//  SULeaguesTableViewCell.m
//  PredictorPro
//
//  Created by Sumac on 14/07/2010.
//  Copyright 2010 Sumac. All rights reserved.
//

#import "SUAllLeaguesTableViewCell.h"
#import <QuartzCore/QuartzCore.h>

@implementation SUAllLeaguesTableViewCell

@synthesize memberLabel;

- (void)dealloc {
    self.memberLabel = nil;
    
    [super dealloc];    
}


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if ((self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])) {
        self.backgroundColor = [UIColor blackColor];
		// some basic formatting
		self.textLabel.textColor = UIColorFromRGB(0xFFFFFF);
		self.textLabel.backgroundColor = [UIColor clearColor];
		self.textLabel.font = [UIFont systemFontOfSize:15];
		
		// our background gradient
		UIView *customBackgroundView = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height)] autorelease];
		customBackgroundView.backgroundColor = UIColorFromRGB(0x3a3c3d);
		self.backgroundView = customBackgroundView;
		
		UIView *topLine = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 1)];
		topLine.backgroundColor = UIColorFromRGB(0x4f4e4e);
		[self addSubview:topLine];
		[topLine release];

		self.textLabel.shadowColor = [UIColor blackColor];
		self.textLabel.shadowOffset = CGSizeMake(0.0, -1.0);
		
		// create a label for our member count
		UIView *newAccessoryView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 55, 30)];		UIImage *img = [[UIImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] 
																		pathForResource:@"leagueMembersBackground" ofType:@"png" 
																		inDirectory:@"/"]];
		UIImageView *imgView = [[UIImageView alloc] initWithImage:img];
		[img release];
		imgView.frame = CGRectMake(0, 5, 43, 20);
		[newAccessoryView addSubview:imgView];
		[imgView release];
		
		self.memberLabel = [[[UILabel alloc] initWithFrame:CGRectMake(20,7,17,17)] autorelease];
		self.memberLabel.font = [UIFont systemFontOfSize:10];
		self.memberLabel.textColor = UIColorFromRGB(0xFFFFFF);
        self.memberLabel.backgroundColor = [UIColor clearColor];
		self.memberLabel.textAlignment = UITextAlignmentCenter;
		[newAccessoryView addSubview:self.memberLabel];
		
		UIImageView *accessory = [[UIImageView alloc] initWithImage:[UIImage imageNamedFallbackToPng:@"accDisclosureWhite"]];
		accessory.frame = CGRectMake(35,0,30,30);
		[newAccessoryView addSubview:accessory];
		[accessory release];
		
		self.accessoryView = newAccessoryView;
		[newAccessoryView release];		
		
    }
    return self;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {

    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}



@end
