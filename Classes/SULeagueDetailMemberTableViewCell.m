//
//  SULeagueDetailMemberTableViewCell.m
//  PredictorPro
//
//  Created by Sumac on 15/07/2010.
//  Copyright 2010 Sumac. All rights reserved.
//

#import "SULeagueDetailMemberTableViewCell.h"


@implementation SULeagueDetailMemberTableViewCell

@synthesize memberPlace, memberPoints, memberImage;

- (void)dealloc {
    self.memberPlace = nil;    
    self.memberPoints = nil;
    self.memberImage = nil;
    
    [super dealloc];
}

//- (void)layoutSubviews {
//    [super layoutSubviews];
//    
//    CGSize size = self.bounds.size;
//    CGRect frame = CGRectMake(4.0f, 4.0f, size.width, size.height);
//    self.textLabel.frame =  frame;
//    self.textLabel.contentMode = UIViewContentModeScaleAspectFit;
//}
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    if ((self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])) {
        // Initialization code
		
		
		// bit of a hack here, add a image to push the label out a bit
	self.imageView.image = [UIImage imageNamedFallbackToPng:@"leagueMemberImageBackground"];
		
		// do some themeing here
		
		// I am creating a new view with the required components
		UIView *canvas = self.contentView;
		
		self.memberPlace = [[[UILabel alloc] initWithFrame:CGRectMake(7,11, 20, 20)] autorelease];
		self.memberPlace.textColor = [UIColor redColor];
		self.memberPlace.text = @"0";
		self.memberPlace.font = [UIFont boldSystemFontOfSize:11];
		self.memberPlace.textColor = UIColorFromRGB(0x000000);
		self.memberPlace.backgroundColor = [UIColor clearColor];
		[canvas addSubview:self.memberPlace];
		
		// now take care of the accessory view
		UIView *newAccessoryView = [[UIView alloc] initWithFrame:CGRectMake(0,0,64,40)];
		
		// throw an image on there
		UIImageView *memberPointsBackgroundImage = [[UIImageView alloc] initWithImage: [UIImage imageNamedFallbackToPng:@"leagueMemberPointsBackground"]];
		[newAccessoryView addSubview:memberPointsBackgroundImage];
		[memberPointsBackgroundImage release];
		
		// and the position label
		self.memberPoints = [[[UILabel alloc] initWithFrame:CGRectMake(2,11, 26,20)] autorelease];
		self.memberPoints.text = @"-";
		self.memberPoints.textAlignment = UITextAlignmentCenter;
		self.memberPoints.font = [UIFont boldSystemFontOfSize:14];
		self.memberPoints.textColor = [UIColor whiteColor];
		self.memberPoints.backgroundColor = UIColorFromRGB(0x454647);
		[newAccessoryView addSubview:self.memberPoints];
		
		self.accessoryView = newAccessoryView;
        [newAccessoryView release];

		
		// our background colour for being selected
		UIView *selectedView = [[UIView alloc] initWithFrame:self.frame];
		selectedView.backgroundColor = [UIColor grayColor];
		self.selectedBackgroundView = selectedView;
		[selectedView release];
        
        self.textLabel.frame = CGRectOffset(self.textLabel.frame, 100.0, 0.0);
    }
    return self;
}




@end
