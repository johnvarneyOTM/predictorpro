//
//  SUPredictionsTableViewHeader.m
//  PredictorPro
//
//  Created by Oliver Relph on 30/06/2010.
//  Copyright 2010 Sumac. All rights reserved.
//

#import "SUPredictionsTableViewHeader.h"
#import <QuartzCore/QuartzCore.h>

// util macro to convert hex to rgb
#define UIColorFromRGB(rgbValue) [UIColor \
colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

@implementation SUPredictionsTableViewHeader

@synthesize resultsCount, scoresCount, goalsCount, pointsCount, bankerSummary;

- (void)dealloc {
    self.resultsCount = nil;
	self.scoresCount = nil;
	self.goalsCount = nil;	
	self.pointsCount = nil;
	self.bankerSummary = nil;
    
    [super dealloc];
}

- (id)initWithFrame:(CGRect)viewFrame {
	
	
    if ((self = [super initWithFrame:viewFrame])) {
        // Initialization code
		
		
		UIImageView *iv = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 80)];
		[iv setImage:[UIImage imageNamedFallbackToPng:@"predictionsTableViewHeader"]];
		[self addSubview:iv];
        [iv release];
		
		
		UILabel *resultsLabel = [[[UILabel alloc] init] autorelease];
		resultsLabel.frame = CGRectMake(77, 20, 55, 14);
		resultsLabel.textAlignment = UITextAlignmentCenter;
		resultsLabel.backgroundColor = UIColorFromRGB(0x1d1d1f);
		resultsLabel.textColor = [UIColor whiteColor];
		resultsLabel.shadowColor = [UIColor blackColor];
		resultsLabel.shadowOffset = CGSizeMake(0.0, 1.0);
		resultsLabel.font = [UIFont boldSystemFontOfSize:11];
		resultsLabel.text = @"RESULTS";		
		[self addSubview:resultsLabel];
		
		self.resultsCount = [[[UILabel alloc] init] autorelease];
		self.resultsCount.frame = CGRectMake(77, 36, 55, 25);
		self.resultsCount.textAlignment = UITextAlignmentCenter;
		self.resultsCount.backgroundColor = UIColorFromRGB(0x1d1d1f);
		self.resultsCount.textColor = [UIColor whiteColor];
		self.resultsCount.shadowColor = [UIColor blackColor];
		self.resultsCount.shadowOffset = CGSizeMake(0.0, 1.0);
		self.resultsCount.font = [UIFont boldSystemFontOfSize:18];
		self.resultsCount.text = @"-";	
		[self addSubview:self.resultsCount];
		
		UILabel *scoresLabel = [[[UILabel alloc] init] autorelease];
		scoresLabel.frame = CGRectMake(147, 20, 55, 14);
		scoresLabel.textAlignment = UITextAlignmentCenter;
		scoresLabel.backgroundColor = UIColorFromRGB(0x1d1d1f);
		scoresLabel.textColor = [UIColor whiteColor];
		scoresLabel.shadowColor = [UIColor blackColor];
		scoresLabel.shadowOffset = CGSizeMake(0.0, 1.0);
		scoresLabel.font = [UIFont boldSystemFontOfSize:11];
		scoresLabel.text = @"SCORES";		
		[self addSubview:scoresLabel];
		
		self.scoresCount = [[[UILabel alloc] init] autorelease];
		self.scoresCount.frame = CGRectMake(147, 36, 55, 25);
		self.scoresCount.textAlignment = UITextAlignmentCenter;
		self.scoresCount.backgroundColor = UIColorFromRGB(0x1d1d1f);
		self.scoresCount.textColor = [UIColor whiteColor];
		self.scoresCount.shadowColor = [UIColor blackColor];
		self.scoresCount.shadowOffset = CGSizeMake(0.0, 1.0);
		self.scoresCount.font = [UIFont boldSystemFontOfSize:18];
		self.scoresCount.text = @"-";	
		[self addSubview:self.scoresCount];
		
		UILabel *goalsLabel = [[[UILabel alloc] init] autorelease];
		goalsLabel.frame = CGRectMake(207, 20, 55, 14);
		goalsLabel.textAlignment = UITextAlignmentCenter;
		goalsLabel.backgroundColor = UIColorFromRGB(0x1d1d1f);
		goalsLabel.textColor = [UIColor whiteColor];
		goalsLabel.shadowColor = [UIColor blackColor];
		goalsLabel.shadowOffset = CGSizeMake(0.0, 1.0);
		goalsLabel.font = [UIFont boldSystemFontOfSize:11];
		goalsLabel.text = @"GOALS";		
		[self addSubview:goalsLabel];
		
		self.goalsCount = [[[UILabel alloc] init] autorelease];
		self.goalsCount.frame = CGRectMake(207, 36, 55, 25);
		self.goalsCount.textAlignment = UITextAlignmentCenter;
		self.goalsCount.backgroundColor = UIColorFromRGB(0x1d1d1f);
		self.goalsCount.textColor = [UIColor whiteColor];
		self.goalsCount.shadowColor = [UIColor blackColor];
		self.goalsCount.shadowOffset = CGSizeMake(0.0, 1.0);
		self.goalsCount.font = [UIFont boldSystemFontOfSize:18];
		self.goalsCount.text = @"-";	
		[self addSubview:self.goalsCount];
		
		self.pointsCount = [[[UILabel alloc] init] autorelease];
		self.pointsCount.frame = CGRectMake(257, 28, 45, 25);
		self.pointsCount.textAlignment = UITextAlignmentCenter;
		self.pointsCount.backgroundColor = [UIColor clearColor];
		self.pointsCount.textColor = UIColorFromRGB(0xecbd30);
		self.pointsCount.shadowColor = [UIColor blackColor];
		self.pointsCount.shadowOffset = CGSizeMake(0.0, 1.0);
		self.pointsCount.font = [UIFont boldSystemFontOfSize:18];
		self.pointsCount.text = @"-";				
		[self addSubview:self.pointsCount];
		
		
		self.bankerSummary = [[[UILabel alloc] init] autorelease];
		self.bankerSummary.frame = CGRectMake(14, 44, 50, 12);
		self.bankerSummary.textAlignment = UITextAlignmentCenter;
		self.bankerSummary.backgroundColor = UIColorFromRGB(0x1d1d1f);
		self.bankerSummary.textColor = UIColorFromRGB(0xffffff);
		self.bankerSummary.shadowColor = [UIColor blackColor];
		self.bankerSummary.shadowOffset = CGSizeMake(0.0, 1.0);
		self.bankerSummary.font = [UIFont boldSystemFontOfSize:12];
		self.bankerSummary.text = @"0/0";				
		[self addSubview:self.bankerSummary];
				
    }
    return self;
}

-(void)setData:(NSDictionary *)dict {
		
	NSInteger goals = 0;
	NSInteger results = 0;
	NSInteger scores = 0;
	NSInteger points = 0;	
	NSInteger bankers = 0;
	NSInteger bankerCount = 0;
	
	NSLog(@"stats: %@", dict);
	
	if ([dict objectForKey:@"Goals"] != nil) {
		goals = [[dict objectForKey:@"Goals"] intValue];
	}
	self.goalsCount.text = [NSString stringWithFormat:@"%i", goals];
	
	if ([dict objectForKey:@"Results"] != nil) {
		results = [[dict objectForKey:@"Results"] intValue];
	}	
	self.resultsCount.text = [NSString stringWithFormat:@"%i", results];
	
	if ([dict objectForKey:@"Scores"] != nil) {
		scores = [[dict objectForKey:@"Scores"] intValue];
	}
	self.scoresCount.text = [NSString stringWithFormat:@"%i", scores];
	
	if ([dict objectForKey:@"Points"] != nil) {
		points = [[dict objectForKey:@"Points"] intValue];
	}
	self.pointsCount.text = [NSString stringWithFormat:@"%i", points];
	
	if ([dict objectForKey:@"Bankers"] != nil) {
		bankers = [[dict objectForKey:@"Bankers"] intValue];
	}
	if ([dict objectForKey:@"BankerCount"] != nil) {
		bankerCount = [[dict objectForKey:@"BankerCount"] intValue];
	}
	self.bankerSummary.text = [NSString stringWithFormat:@"%i/%i", bankers, bankerCount];
		
	[self setNeedsLayout];
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/


@end
