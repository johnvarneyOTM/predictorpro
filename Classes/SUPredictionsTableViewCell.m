//
//  SUPredictionsTableViewCell.m
//  PredictorPro
//
//  Created by Oliver Relph on 28/06/2010.
//  Copyright 2010 Sumac. All rights reserved.
//

#import "SUPredictionsTableViewCell.h"
#import <QuartzCore/QuartzCore.h>
#include <stdlib.h>

@implementation SUPredictionsTableViewCell

@synthesize kickOffTimeLabel;
@synthesize cellMode;
@synthesize teamOneNameLabel, teamOneCode, teamOnePredictionLabel, teamOneResultLabel;
@synthesize teamTwoNameLabel, teamTwoCode, teamTwoPredictionLabel, teamTwoResultLabel;
@synthesize match, matchPointsLabel, bankerType, versusLabel, bankerIcon;



- (void)dealloc {
    
    self.match = nil;
    
	[super dealloc];
	
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if ((self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])) {
							
		// Initialization code
		
		// we need a view to place our labels on.
		UIView *cellContentView = self.contentView;			
		CGRect cellBounds = cellContentView.bounds;
        CGFloat boundsX = cellBounds.origin.x;
        CGFloat boundsY = cellBounds.origin.y;
				
		/*
		 * VS Label
		 */	
		versusLabel = [[[UILabel alloc] initWithFrame:CGRectMake(127, 30, 30, 15)] autorelease];
		versusLabel.textColor = [UIColor whiteColor];
		versusLabel.font = [UIFont boldSystemFontOfSize:12];
		versusLabel.shadowColor = [UIColor blackColor];
		versusLabel.shadowOffset = CGSizeMake(0, 1.0);
		versusLabel.textAlignment = UITextAlignmentCenter;
		versusLabel.backgroundColor = [UIColor clearColor];		
		versusLabel.text = @"VS";
		[cellContentView addSubview:versusLabel];
		
		
		/*
		 * kickOffTime
		 */	
		// bg image
		UIImageView *kickOffBackground = [[[UIImageView alloc] initWithFrame:CGRectMake(boundsX + 111.0f, boundsY - 1.0f, 59.0f, 15.0f)] autorelease];		
		[kickOffBackground setImage:[UIImage imageNamedFallbackToPng:@"kickOffTime"]];
		[cellContentView addSubview:kickOffBackground];
		
		// time label
		self.kickOffTimeLabel = [[[UILabel alloc] initWithFrame:CGRectMake(boundsX + 133.0f, boundsY + 2.0f, 30.0f, 10.0f)] autorelease];
		self.kickOffTimeLabel.textColor = [UIColor blackColor];
		self.kickOffTimeLabel.font = [UIFont boldSystemFontOfSize:10];
		self.kickOffTimeLabel.shadowColor = [UIColor whiteColor];
		self.kickOffTimeLabel.shadowOffset = CGSizeMake(0, 1.0);
		self.kickOffTimeLabel.textAlignment = UITextAlignmentCenter;
		self.kickOffTimeLabel.backgroundColor = [UIColor whiteColor];
		[cellContentView addSubview:self.kickOffTimeLabel];
			
		
		/*
		 * teamOne
		 */			
		// Name label.
		self.teamOneNameLabel = [[[UILabel alloc] initWithFrame:CGRectMake(boundsX + 7.0f, boundsY + 46.0f, 75.0f, 20.0f)] autorelease];
		self.teamOneNameLabel.textColor = UIColorFromRGB(0x19191a);
		self.teamOneNameLabel.font = [UIFont boldSystemFontOfSize:10];
		self.teamOneNameLabel.shadowColor = [UIColor whiteColor];
		self.teamOneNameLabel.shadowOffset = CGSizeMake(0, 1.0);
		self.teamOneNameLabel.textAlignment = UITextAlignmentCenter;
		self.teamOneNameLabel.backgroundColor = [UIColor clearColor];
		[cellContentView addSubview:self.teamOneNameLabel];
		
		// Prediction label.
		self.teamOnePredictionLabel = [[[UILabel alloc] initWithFrame:CGRectMake(boundsX + 80.0f, boundsY + 10.0f, 40.0f, 20.0f)] autorelease];
		self.teamOnePredictionLabel.textColor = UIColorFromRGB(0x5e5d50);
		self.teamOnePredictionLabel.font = [UIFont systemFontOfSize:18];
		self.teamOnePredictionLabel.shadowColor = [UIColor whiteColor];
		self.teamOnePredictionLabel.shadowOffset = CGSizeMake(0, 1.0);
		self.teamOnePredictionLabel.textAlignment = UITextAlignmentCenter;
		self.teamOnePredictionLabel.backgroundColor = [UIColor clearColor];
		[cellContentView addSubview:self.teamOnePredictionLabel];
		
		// Result label.
		self.teamOneResultLabel = [[[UILabel alloc] initWithFrame:CGRectMake(boundsX + 88.0f, boundsY + 39.0f, 20.0f, 20.0f)] autorelease];
		self.teamOneResultLabel.textColor = UIColorFromRGB(0x272729);
		self.teamOneResultLabel.font = [UIFont boldSystemFontOfSize:24];
		self.teamOneResultLabel.shadowColor = [UIColor whiteColor];
		self.teamOneResultLabel.shadowOffset = CGSizeMake(0, 1.0);
		self.teamOneResultLabel.textAlignment = UITextAlignmentCenter;
		self.teamOneResultLabel.backgroundColor = [UIColor whiteColor];
		[cellContentView addSubview:self.teamOneResultLabel];
		
		/*
		 *teamTwo
		 */				
		// Name label.
		self.teamTwoNameLabel = [[[UILabel alloc] initWithFrame:CGRectMake(boundsX + 195.0f, boundsY + 46.0f, 75.0f, 20.0f)] autorelease];
		self.teamTwoNameLabel.textColor = UIColorFromRGB(0x19191a);
		self.teamTwoNameLabel.font = [UIFont boldSystemFontOfSize:10];
		self.teamTwoNameLabel.shadowColor = [UIColor whiteColor];
		self.teamTwoNameLabel.shadowOffset = CGSizeMake(0, 1.0);
		self.teamTwoNameLabel.textAlignment = UITextAlignmentCenter;
		self.teamTwoNameLabel.backgroundColor = [UIColor clearColor];
		[cellContentView addSubview:self.teamTwoNameLabel];
		
		// Prediction label.
		self.teamTwoPredictionLabel = [[[UILabel alloc] initWithFrame:CGRectMake(boundsX + 164.0f, boundsY + 10.0f, 40.0f, 20.0f)] autorelease];
		self.teamTwoPredictionLabel.textColor = UIColorFromRGB(0x5e5d50);
		self.teamTwoPredictionLabel.font = [UIFont systemFontOfSize:18];
		self.teamTwoPredictionLabel.shadowColor = [UIColor whiteColor];
		self.teamTwoPredictionLabel.shadowOffset = CGSizeMake(0, 1.0);
		self.teamTwoPredictionLabel.textAlignment = UITextAlignmentCenter;
		self.teamTwoPredictionLabel.backgroundColor = [UIColor clearColor];
		[cellContentView addSubview:self.teamTwoPredictionLabel];
		
		// Result label.
		self.teamTwoResultLabel = [[[UILabel alloc] initWithFrame:CGRectMake(boundsX + 174.0f, boundsY + 39.0f, 20.0f, 20.0f)] autorelease];
		self.teamTwoResultLabel.textColor = UIColorFromRGB(0x272729);
		self.teamTwoResultLabel.font = [UIFont boldSystemFontOfSize:24];
		self.teamTwoResultLabel.shadowColor = [UIColor whiteColor];
		self.teamTwoResultLabel.shadowOffset = CGSizeMake(0, 1.0);
		self.teamTwoResultLabel.textAlignment = UITextAlignmentCenter;
		self.teamTwoResultLabel.backgroundColor = [UIColor whiteColor];
		[cellContentView addSubview:self.teamTwoResultLabel];
		
		
		
		self.matchPointsLabel = [[[UILabel alloc] initWithFrame:CGRectMake(boundsX + 277.0f, boundsY + 22.0f, 37.0f, 29.0f)] autorelease];
		self.matchPointsLabel.textColor = [UIColor whiteColor];
		self.matchPointsLabel.font = [UIFont boldSystemFontOfSize:24];
		self.matchPointsLabel.shadowColor = [UIColor blackColor];
		self.matchPointsLabel.shadowOffset = CGSizeMake(0, 1.0);
		self.matchPointsLabel.textAlignment = UITextAlignmentCenter;
		self.matchPointsLabel.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamedFallbackToPng:@"predPointsBg"]];
		self.matchPointsLabel.opaque = NO;
		self.matchPointsLabel.text =  @"0";
		[cellContentView addSubview:self.matchPointsLabel];
		
		
		
		
    }
    return self;
}

-(void)drawRect:(CGRect)rect {
	[super drawRect:rect];
	
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {

	if (self.cellMode != SUPredictionsTableViewCellModeClosed) {
		
		//
		//[super setSelected:selected animated:animated];

	}
    // Configure the view for the selected state
}


-(void)setData:(NSDictionary *)dict {
	self.match = dict;		
	
	
	self.kickOffTimeLabel.text = [[dict objectForKey:@"DateLocalString"] substringFromIndex:11];
	
	
	self.teamOneNameLabel.text = [[dict objectForKey:@"TeamHome"] objectForKey:@"Name"];
	self.teamTwoNameLabel.text = [[dict objectForKey:@"TeamAway"] objectForKey:@"Name"];
	
	self.teamOneCode = [[[dict objectForKey:@"TeamHome"] objectForKey:@"Code"] lowercaseString];
	self.teamTwoCode = [[[dict objectForKey:@"TeamAway"] objectForKey:@"Code"] lowercaseString];
    
    if (self.teamOneCode.length == 0){
        NSString* testName = self.teamOneNameLabel.text;
        if (testName.length > 5.0)
            self.teamOneCode = [[testName substringWithRange:NSMakeRange(0, 4.0)] uppercaseString];
    }
    
    if (self.teamTwoCode.length == 0){
        NSString* testName = self.teamTwoNameLabel.text;
        if (testName.length > 5.0)
            self.teamTwoCode = [[testName substringWithRange:NSMakeRange(0, 4.0)]uppercaseString];
    }
	
	NSString *teamOnePrediction = @"-";
	NSString *teamTwoPrediction = @"-"; 
	NSString *teamOneScore = [dict objectForKey:@"ScoreHome"];
	NSString *teamTwoScore = [dict objectForKey:@"ScoreAway"]; 
	NSString *matchPoints = @"-";
	
	SUPredictionsTableViewCellMode mode = SUPredictionsTableViewCellModeOpen;
	NSDictionary *prediction = [dict objectForKey:@"Prediction"];
	if (![prediction isEqual:[NSNull null]]) {
		teamOnePrediction = [prediction objectForKey:@"ScoreHome"];
		teamTwoPrediction = [prediction objectForKey:@"ScoreAway"];		

		mode = SUPredictionsTableViewCellModePredicted;
		
		matchPoints = [prediction objectForKey:@"Points"];
		NSLog(@"%@", matchPoints);	
		
		if (![teamOneScore isEqual:@"-"]) {
			mode = SUPredictionsTableViewCellModeClosed;
		} 		 		
		
		if([[prediction objectForKey:@"Banker"] intValue] == 1) {
			self.bankerType = CellIsBanker;			
		}
			 
	} else {		
		
		teamOnePrediction = @"-";
		teamTwoPrediction = @"-";
	}
			 
	self.teamOneResultLabel.text = teamOneScore;
	self.teamTwoResultLabel.text = teamTwoScore;

	self.teamOnePredictionLabel.text = teamOnePrediction;
	self.teamTwoPredictionLabel.text = teamTwoPrediction;

	
	
	// if the match is closed... it overrides everything else
	NSString *dateClosesString = [dict objectForKey:@"DateClosesString"];
	// Convert string to date object
	NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
	[dateFormat setDateFormat:@"dd/MM/yyyy HH:mm"];
	NSDate *closesDate = [dateFormat dateFromString:dateClosesString];  	
	NSDate *localDate = [[NSDate alloc] init];	
    if ([closesDate compare:localDate] == NSOrderedAscending){
		mode = SUPredictionsTableViewCellModeClosed;
	}	
	[localDate release];
	[dateFormat release];
	
	
	if (mode != SUPredictionsTableViewCellModeClosed) {
		self.matchPointsLabel.hidden = YES;
	} else {
		self.matchPointsLabel.text = matchPoints;
		self.matchPointsLabel.hidden = NO;
	}
	

	[self setCellMode:mode];	
	
}
/*
 * Use this instead of setting the property directly as the cell needs redrawing
 */
- (void)setCellMode:(SUPredictionsTableViewCellMode)newMode {
    // Dont change status if it wasn't actually changed to prevent flickering
    if (cellMode && (cellMode == newMode)) {
        return;
    }
	
	if (newMode == SUPredictionsTableViewCellModeClosed) {
		self.selectionStyle = UITableViewCellSelectionStyleNone;
	} else {
		self.selectionStyle = UITableViewCellSelectionStyleGray;
	}

	
    cellMode = newMode;
	
    [self performSelectorOnMainThread:@selector(setNeedsDisplay) withObject:nil waitUntilDone:NO];
}

-(void)setBankerType:(MatchCellBankerType)type {
	
	if (type == CellIsBanker) {
		// add the image
		bankerIcon = [[[UIImageView alloc] initWithImage:[UIImage imageNamedFallbackToPng:@"bankerIcon"]] autorelease];
		bankerIcon.frame = CGRectMake(131, 28, 22, 14);
		[self addSubview:bankerIcon];
		// move down the label
		versusLabel.frame = CGRectMake(126, 40, 30, 15);
	} else {
		// remove the image
		bankerIcon = nil;
		// move up the label
		versusLabel.frame = CGRectMake(126, 30, 30, 15);
	}
	
	bankerType = type;
    [self performSelectorOnMainThread:@selector(setNeedsDisplay) withObject:nil waitUntilDone:NO];

	
}
- (void)resetCodeIfNeeded {
    
    if (self.teamOneCode.length == 0) {
        NSString* teamName = self.teamOneNameLabel.text;
        self.teamOneCode = [teamName substringToIndex:4];
    }
    
    if (self.teamTwoCode.length == 0) {
        NSString* teamName = self.teamTwoNameLabel.text;
        self.teamTwoCode = [teamName substringToIndex:4];
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
		
    [self resetCodeIfNeeded];
    
	// get the cell size
    CGRect cellBounds = self.contentView.bounds;
	UIView *cellContentView = self.contentView;	
	
	// get the cell x & y
	CGFloat boundsX = cellBounds.origin.x;
	CGFloat boundsY = cellBounds.origin.y;
	
	// set the reusable view & gradient references
	CAGradientLayer *layerGradient;
	
	
	if (cellMode != SUPredictionsTableViewCellModeClosed) {
		self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
	}
	
	// base view
	layerGradient = [CAGradientLayer layer];
	layerGradient.frame = CGRectMake(0.0f, 0.0f, 320.0f, 70.0f);		
	
	if (cellMode == SUPredictionsTableViewCellModePredicted) {
		// orange gradient
		layerGradient.colors = [NSArray arrayWithObjects:(id)[UIColorFromRGB(0xfd9b09) CGColor], (id)[UIColorFromRGB(0xff6400) CGColor], nil];
	} else if (cellMode == SUPredictionsTableViewCellModeClosed) {
		// red gradient
		layerGradient.colors = [NSArray arrayWithObjects:(id)[UIColorFromRGB(0xf70000) CGColor], (id)[UIColorFromRGB(0xc90000) CGColor], nil];
	} else {
		// green gradient
		layerGradient.colors = [NSArray arrayWithObjects:(id)[UIColorFromRGB(0x3a993c) CGColor], (id)[UIColorFromRGB(0x164117) CGColor], nil];
	}
	[cellContentView.layer insertSublayer:layerGradient atIndex:0];		
	
	// little ridge in bottom middle
	layerGradient = [CAGradientLayer layer];
	layerGradient.frame = CGRectMake(125.0f, 64.0f, 32.0f, 6.0f);
	if (cellMode == SUPredictionsTableViewCellModePredicted) {
		// orange gradient
		layerGradient.colors = [NSArray arrayWithObjects:(id)[UIColorFromRGB(0xfd9b09) CGColor], (id)[UIColorFromRGB(0xff6400) CGColor], nil];
	} else if (cellMode == SUPredictionsTableViewCellModeClosed) {
		// red gradient
		layerGradient.colors = [NSArray arrayWithObjects:(id)[UIColorFromRGB(0xf70000) CGColor], (id)[UIColorFromRGB(0xc90000) CGColor], nil];
	} else {
		// green gradient
		layerGradient.colors = [NSArray arrayWithObjects:(id)[UIColorFromRGB(0x3a993c) CGColor], (id)[UIColorFromRGB(0x164117) CGColor], nil];
	}
	[cellContentView.layer insertSublayer:layerGradient atIndex:3];		
	
	// the cream view	
	layerGradient = [CAGradientLayer layer];
	layerGradient.frame = CGRectMake(10.0f, 0.0f, 260.0f, 70.0f);
	layerGradient.colors = [NSArray arrayWithObjects:(id)[UIColorFromRGB(0xfbfbe9) CGColor], (id)[UIColorFromRGB(0xddddc4) CGColor], nil];
	[cellContentView.layer insertSublayer:layerGradient atIndex:1];
	
	// the center view	
	layerGradient = [CAGradientLayer layer];
	layerGradient.frame = CGRectMake(125.0f, 0.0f, 32.0f, 70.0f);
	layerGradient.colors = [NSArray arrayWithObjects:(id)[UIColorFromRGB(0x161616) CGColor], (id)[UIColorFromRGB(0x333030) CGColor], nil];	
	[cellContentView.layer insertSublayer:layerGradient atIndex:2];
	
	// add the logos
	UIImageView *teamOneLogoView = [[[UIImageView alloc] initWithFrame:CGRectMake(boundsX + 22.0f, boundsY + 3.0f, 45.0f, 45.0f)] autorelease];		
	[teamOneLogoView setImage:[UIImage imageNamedFallbackToPng:self.teamOneCode]];
	[self addSubview:teamOneLogoView];
	UIImageView *teamTwoLogoView = [[[UIImageView alloc] initWithFrame:CGRectMake(boundsX + 210.0f, boundsY + 3.0f, 45.0f, 45.0f)] autorelease];	
	[teamTwoLogoView setImage:[UIImage imageNamedFallbackToPng:self.teamTwoCode]];	
	[self addSubview:teamTwoLogoView];
	
}


@end
