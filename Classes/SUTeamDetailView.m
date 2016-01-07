//
//  SUTeamDetailView.m
//  PredictorPro
//
//  Created by Oliver Relph on 13/07/2010.
//  Copyright 2010 Sumac. All rights reserved.
//

#import "SUTeamDetailView.h"

@implementation SUTeamDetailView
@synthesize fullNameLabel, avatarView, medalCountLabel, trophyCountLabel, rankedValueLabel, ratingValueLabel;
@synthesize rankedHelpButton, ratingHelpButton, ppgHelpButton, gpgHelpButton, resultsHelpButton, scoresHelpButton, goalsHelpButton;
@synthesize parentController;
@synthesize ppgValueLabel, gpgValueLabel, resultsValueLabel, scoresValueLabel, goalsValueLabel;

- (void)dealloc {
    [super dealloc];
}

- (id)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
        // Initialization code
		
		self.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamedFallbackToPng:@"teamBackground"]];
		self.avatarView = [[[UIImageView alloc] initWithFrame:CGRectMake(14, 15, 77, 77)] autorelease];
		[self addSubview:self.avatarView];
		
		// Drawing code
		self.fullNameLabel = [[[UILabel alloc] initWithFrame:CGRectMake(137.0f, 16.0f, 120.0f, 13.0f)] autorelease];
		self.fullNameLabel.backgroundColor = [UIColor clearColor];
		self.fullNameLabel.textColor = [UIColor blackColor];
		self.fullNameLabel.shadowColor = [UIColor whiteColor];
		self.fullNameLabel.shadowOffset = CGSizeMake(0.0, 1.0);
		self.fullNameLabel.font = [UIFont boldSystemFontOfSize:13];
		self.fullNameLabel.adjustsFontSizeToFitWidth = TRUE;
		self.fullNameLabel.text = @"";
		[self addSubview:self.fullNameLabel];
		
		UILabel *medalMultiplierLabel = [[[UILabel alloc] initWithFrame:CGRectMake(156.0f, 54.0f, 12.0f, 32.0f)] autorelease];
		medalMultiplierLabel.backgroundColor = [UIColor clearColor];
		medalMultiplierLabel.textColor = [UIColor whiteColor];
		medalMultiplierLabel.shadowColor = [UIColor blackColor];
		medalMultiplierLabel.shadowOffset = CGSizeMake(0.0, -1.0);
		medalMultiplierLabel.font = [UIFont boldSystemFontOfSize:11];
		medalMultiplierLabel.text = @"x";	
		[self addSubview:medalMultiplierLabel];
		
		self.medalCountLabel = [[[UILabel alloc] initWithFrame:CGRectMake(165.0f, 54.0f, 60.0f, 32.0f)] autorelease];
		self.medalCountLabel.backgroundColor = [UIColor clearColor];
		self.medalCountLabel.textColor = [UIColor whiteColor];
		self.medalCountLabel.shadowColor = [UIColor blackColor];
		self.medalCountLabel.shadowOffset = CGSizeMake(0.0, -1.0);
		self.medalCountLabel.font = [UIFont boldSystemFontOfSize:32];
		self.medalCountLabel.adjustsFontSizeToFitWidth = TRUE;
		self.medalCountLabel.text = @"";
		[self addSubview:self.medalCountLabel];
		
		
		UILabel *trophyMultiplierLabel = [[[UILabel alloc] initWithFrame:CGRectMake(255.0f, 54.0f, 12.0f, 32.0f)] autorelease];
		trophyMultiplierLabel.backgroundColor = [UIColor clearColor];
		trophyMultiplierLabel.textColor = [UIColor whiteColor];
		trophyMultiplierLabel.shadowColor = [UIColor blackColor];
		trophyMultiplierLabel.shadowOffset = CGSizeMake(0.0, -1.0);
		trophyMultiplierLabel.font = [UIFont boldSystemFontOfSize:11];
		trophyMultiplierLabel.text = @"x";	
		[self addSubview:trophyMultiplierLabel];
		
		self.trophyCountLabel = [[[UILabel alloc] initWithFrame:CGRectMake(265.0f, 54.0f, 60.0f, 32.0f)] autorelease];
		self.trophyCountLabel.backgroundColor = [UIColor clearColor];
		self.trophyCountLabel.textColor = [UIColor whiteColor];
		self.trophyCountLabel.shadowColor = [UIColor blackColor];
		self.trophyCountLabel.shadowOffset = CGSizeMake(0.0, -1.0);
		self.trophyCountLabel.font = [UIFont boldSystemFontOfSize:32];
		self.trophyCountLabel.adjustsFontSizeToFitWidth = TRUE;
		self.trophyCountLabel.text = @"";
		[self addSubview:self.trophyCountLabel];
		
		
		UILabel *rankedTitleLabel = [[[UILabel alloc] initWithFrame:CGRectMake(57.0f, 133.0f, 120.0f, 32.0f)] autorelease];
		rankedTitleLabel.backgroundColor = [UIColor clearColor];
		rankedTitleLabel.textColor = UIColorFromRGB(0x1E1E1E);
		rankedTitleLabel.shadowColor = [UIColor whiteColor];
		rankedTitleLabel.shadowOffset = CGSizeMake(0.0, 1.0);
		rankedTitleLabel.font = [UIFont boldSystemFontOfSize:32];
		rankedTitleLabel.text = @"Ranked";
		[self addSubview:rankedTitleLabel];
		
		self.rankedHelpButton = [[[UIButton alloc] initWithFrame:CGRectMake(10, 120, 300, 60)] autorelease];
		[self.rankedHelpButton addTarget:self action:@selector(helpButtonPushed:) 
						forControlEvents:UIControlEventTouchUpInside];
		self.rankedHelpButton.backgroundColor = [UIColor clearColor];
		[self addSubview:self.rankedHelpButton];
		
		self.rankedValueLabel = [[[UILabel alloc] initWithFrame:CGRectMake(200.0f, 133.0f, 97.0f, 32.0f)] autorelease];
		self.rankedValueLabel.backgroundColor = [UIColor clearColor];
		self.rankedValueLabel.textAlignment = UITextAlignmentRight;
		self.rankedValueLabel.textColor = UIColorFromRGB(0x1E1E1E);
		self.rankedValueLabel.shadowColor = [UIColor whiteColor];
		self.rankedValueLabel.shadowOffset = CGSizeMake(0.0, 1.0);
		self.rankedValueLabel.font = [UIFont boldSystemFontOfSize:32];
		self.rankedValueLabel.adjustsFontSizeToFitWidth = TRUE;
		self.rankedValueLabel.text = @"";
		[self addSubview:self.rankedValueLabel];
		
		
		UILabel *ratingTitleLabel = [[[UILabel alloc] initWithFrame:CGRectMake(57.0f, 206.0f, 120.0f, 37.0f)] autorelease];
		ratingTitleLabel.backgroundColor = [UIColor clearColor];
		ratingTitleLabel.textColor = UIColorFromRGB(0x1E1E1E);
		ratingTitleLabel.shadowColor = [UIColor whiteColor];
		ratingTitleLabel.shadowOffset = CGSizeMake(0.0, 1.0);
		ratingTitleLabel.font = [UIFont boldSystemFontOfSize:32];
		ratingTitleLabel.text = @"Rating";
		[self addSubview:ratingTitleLabel];
		
		self.ratingHelpButton = [[[UIButton alloc] initWithFrame:CGRectMake(10, 190, 300, 65)] autorelease];
		[self.ratingHelpButton addTarget:self action:@selector(helpButtonPushed:) 
						forControlEvents:UIControlEventTouchUpInside];
		self.ratingHelpButton.backgroundColor = [UIColor clearColor];
		[self addSubview:self.ratingHelpButton];
		
		self.ratingValueLabel = [[[UILabel alloc] initWithFrame:CGRectMake(200.0f, 206.0f, 97.0f, 37.0f)] autorelease];
		self.ratingValueLabel.backgroundColor = [UIColor clearColor];
		self.ratingValueLabel.textAlignment = UITextAlignmentRight;
		self.ratingValueLabel.textColor = UIColorFromRGB(0x1E1E1E);
		self.ratingValueLabel.shadowColor = [UIColor whiteColor];
		self.ratingValueLabel.shadowOffset = CGSizeMake(0.0, 1.0);
		self.ratingValueLabel.font = [UIFont boldSystemFontOfSize:32];
		self.ratingValueLabel.adjustsFontSizeToFitWidth = TRUE;
		self.ratingValueLabel.text = @"";
		[self addSubview:self.ratingValueLabel];	
		
		UILabel *averagesTitleLabel = [[[UILabel alloc] initWithFrame:CGRectMake(15.0f, 252.0f, 120.0f, 32.0f)] autorelease];
		averagesTitleLabel.backgroundColor = [UIColor clearColor];
		averagesTitleLabel.textColor = [UIColor whiteColor];
		averagesTitleLabel.shadowColor = [UIColor blackColor];
		averagesTitleLabel.shadowOffset = CGSizeMake(0.0, -1.0);
		averagesTitleLabel.font = [UIFont boldSystemFontOfSize:11];
		averagesTitleLabel.text = @"AVERAGES";
		[self addSubview:averagesTitleLabel];
		
		UILabel *ppgTitleLabel = [[[UILabel alloc] initWithFrame:CGRectMake(22.0f, 280.0f, 120.0f, 32.0f)] autorelease];
		ppgTitleLabel.backgroundColor = [UIColor clearColor];
		ppgTitleLabel.textAlignment = UITextAlignmentCenter;
		ppgTitleLabel.textColor = [UIColor whiteColor];
		ppgTitleLabel.shadowColor = [UIColor blackColor];
		ppgTitleLabel.shadowOffset = CGSizeMake(0.0, -1.0);
		ppgTitleLabel.font = [UIFont boldSystemFontOfSize:11];
		ppgTitleLabel.text = @"POINTS PER GAME";
		[self addSubview:ppgTitleLabel];
		
		self.ppgValueLabel = [[[UILabel alloc] initWithFrame:CGRectMake(22.0f, 307.0f, 120.0f, 32.0f)] autorelease];
		self.ppgValueLabel.backgroundColor = [UIColor clearColor];
		self.ppgValueLabel.textAlignment = UITextAlignmentCenter;
		self.ppgValueLabel.textColor = [UIColor whiteColor];
		self.ppgValueLabel.shadowColor = [UIColor blackColor];
		self.ppgValueLabel.shadowOffset = CGSizeMake(0.0, -1.0);
		self.ppgValueLabel.font = [UIFont boldSystemFontOfSize:32];
		self.ppgValueLabel.adjustsFontSizeToFitWidth = TRUE;
		self.ppgValueLabel.text = @"";
		[self addSubview:self.ppgValueLabel];	
		
		self.ppgHelpButton = [[[UIButton alloc] initWithFrame:CGRectMake(10, 280, 145, 65)] autorelease];
		[self.ppgHelpButton addTarget:self action:@selector(helpButtonPushed:) 
					 forControlEvents:UIControlEventTouchUpInside];
		self.ppgHelpButton.backgroundColor = [UIColor clearColor];
		[self addSubview:self.ppgHelpButton];
		
		UILabel *gpgTitleLabel = [[[UILabel alloc] initWithFrame:CGRectMake(178.0f, 280.0f, 120.0f, 32.0f)] autorelease];
		gpgTitleLabel.backgroundColor = [UIColor clearColor];
		gpgTitleLabel.textAlignment = UITextAlignmentCenter;
		gpgTitleLabel.textColor = [UIColor whiteColor];
		gpgTitleLabel.shadowColor = [UIColor blackColor];
		gpgTitleLabel.shadowOffset = CGSizeMake(0.0, -1.0);
		gpgTitleLabel.font = [UIFont boldSystemFontOfSize:11];
		gpgTitleLabel.text = @"GOALS PER GAME";
		[self addSubview:gpgTitleLabel];
		
		self.gpgValueLabel = [[[UILabel alloc] initWithFrame:CGRectMake(178.0f, 307.0f, 120.0f, 32.0f)] autorelease];
		self.gpgValueLabel.backgroundColor = [UIColor clearColor];
		self.gpgValueLabel.textAlignment = UITextAlignmentCenter;
		self.gpgValueLabel.textColor = [UIColor whiteColor];
		self.gpgValueLabel.shadowColor = [UIColor blackColor];
		self.gpgValueLabel.shadowOffset = CGSizeMake(0.0, -1.0);
		self.gpgValueLabel.font = [UIFont boldSystemFontOfSize:32];
		self.gpgValueLabel.adjustsFontSizeToFitWidth = TRUE;
		self.gpgValueLabel.text = @"";
		[self addSubview:self.gpgValueLabel];	
		
		self.gpgHelpButton = [[[UIButton alloc] initWithFrame:CGRectMake(167, 280, 145, 65)] autorelease];
		[self.gpgHelpButton addTarget:self action:@selector(helpButtonPushed:) 
					 forControlEvents:UIControlEventTouchUpInside];
		self.gpgHelpButton.backgroundColor = [UIColor clearColor];
		[self addSubview:self.gpgHelpButton];
		
		// totals
		UILabel *totalsTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(15.0f, 342.0f, 120.0f, 32.0f)];
		totalsTitleLabel.backgroundColor = [UIColor clearColor];
		totalsTitleLabel.textColor = [UIColor whiteColor];
		totalsTitleLabel.shadowColor = [UIColor blackColor];
		totalsTitleLabel.shadowOffset = CGSizeMake(0.0, -1.0);
		totalsTitleLabel.font = [UIFont boldSystemFontOfSize:11];
		totalsTitleLabel.text = @"TOTALS";
		[self addSubview:totalsTitleLabel];	
		[totalsTitleLabel release];
		
		UILabel *resultsTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10.0f, 370.0f, 90.0f, 32.0f)];
		resultsTitleLabel.backgroundColor = [UIColor clearColor];
		resultsTitleLabel.textAlignment = UITextAlignmentCenter;
		resultsTitleLabel.textColor = [UIColor whiteColor];
		resultsTitleLabel.shadowColor = [UIColor blackColor];
		resultsTitleLabel.shadowOffset = CGSizeMake(0.0, -1.0);
		resultsTitleLabel.font = [UIFont boldSystemFontOfSize:11];
		resultsTitleLabel.text = @"RESULTS";
		[self addSubview:resultsTitleLabel];
		[resultsTitleLabel release];
		
		self.resultsValueLabel = [[[UILabel alloc] initWithFrame:CGRectMake(10.0f, 397.0f, 90.0f, 32.0f)] autorelease];
		self.resultsValueLabel.backgroundColor = [UIColor clearColor];
		self.resultsValueLabel.textAlignment = UITextAlignmentCenter;
		self.resultsValueLabel.textColor = [UIColor whiteColor];
		self.resultsValueLabel.shadowColor = [UIColor blackColor];
		self.resultsValueLabel.shadowOffset = CGSizeMake(0.0, -1.0);
		self.resultsValueLabel.font = [UIFont boldSystemFontOfSize:32];
		self.resultsValueLabel.adjustsFontSizeToFitWidth = TRUE;
		self.resultsValueLabel.text = @"";
		[self addSubview:self.resultsValueLabel];	
		
		self.resultsHelpButton = [[[UIButton alloc] initWithFrame:CGRectMake(10, 370, 90, 65)] autorelease];
		[self.resultsHelpButton addTarget:self action:@selector(helpButtonPushed:) 
						 forControlEvents:UIControlEventTouchUpInside];
		self.resultsHelpButton.backgroundColor = [UIColor clearColor];
		[self addSubview:self.resultsHelpButton];
		
		UILabel *scoresTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(115.0f, 370.0f, 90.0f, 32.0f)];
		scoresTitleLabel.backgroundColor = [UIColor clearColor];
		scoresTitleLabel.textAlignment = UITextAlignmentCenter;
		scoresTitleLabel.textColor = [UIColor whiteColor];
		scoresTitleLabel.shadowColor = [UIColor blackColor];
		scoresTitleLabel.shadowOffset = CGSizeMake(0.0, -1.0);
		scoresTitleLabel.font = [UIFont boldSystemFontOfSize:11];
		scoresTitleLabel.text = @"EXACT SCORES";
		[self addSubview:scoresTitleLabel];
		[scoresTitleLabel release];
		
		self.scoresValueLabel = [[[UILabel alloc] initWithFrame:CGRectMake(115.0f, 397.0f, 90.0f, 32.0f)] autorelease];
		self.scoresValueLabel.backgroundColor = [UIColor clearColor];
		self.scoresValueLabel.textAlignment = UITextAlignmentCenter;
		self.scoresValueLabel.textColor = [UIColor whiteColor];
		self.scoresValueLabel.shadowColor = [UIColor blackColor];
		self.scoresValueLabel.shadowOffset = CGSizeMake(0.0, -1.0);
		self.scoresValueLabel.font = [UIFont boldSystemFontOfSize:32];
		self.scoresValueLabel.adjustsFontSizeToFitWidth = TRUE;
		self.scoresValueLabel.text = @"";
		[self addSubview:self.scoresValueLabel];
		
		self.scoresHelpButton = [[[UIButton alloc] initWithFrame:CGRectMake(115, 370, 90, 65)] autorelease];
		[self.scoresHelpButton addTarget:self action:@selector(helpButtonPushed:) 
						forControlEvents:UIControlEventTouchUpInside];
		self.scoresHelpButton.backgroundColor = [UIColor clearColor];
		[self addSubview:self.scoresHelpButton];
		
		UILabel *goalsTitleLabel = [[[UILabel alloc] initWithFrame:CGRectMake(220.0f, 370.0f, 90.0f, 32.0f)] autorelease];
		goalsTitleLabel.backgroundColor = [UIColor clearColor];
		goalsTitleLabel.textAlignment = UITextAlignmentCenter;
		goalsTitleLabel.textColor = [UIColor whiteColor];
		goalsTitleLabel.shadowColor = [UIColor blackColor];
		goalsTitleLabel.shadowOffset = CGSizeMake(0.0, -1.0);
		goalsTitleLabel.font = [UIFont boldSystemFontOfSize:11];
		goalsTitleLabel.text = @"GOALS";
		[self addSubview:goalsTitleLabel];
		
		self.goalsValueLabel = [[[UILabel alloc] initWithFrame:CGRectMake(220.0f, 397.0f, 90.0f, 32.0f)] autorelease];
		self.goalsValueLabel.backgroundColor = [UIColor clearColor];
		self.goalsValueLabel.textAlignment = UITextAlignmentCenter;
		self.goalsValueLabel.textColor = [UIColor whiteColor];
		self.goalsValueLabel.shadowColor = [UIColor blackColor];
		self.goalsValueLabel.shadowOffset = CGSizeMake(0.0, -1.0);
		self.goalsValueLabel.font = [UIFont boldSystemFontOfSize:32];
		self.goalsValueLabel.adjustsFontSizeToFitWidth = TRUE;
		self.goalsValueLabel.text = @"";
		[self addSubview:self.goalsValueLabel];
		
		self.goalsHelpButton = [[[UIButton alloc] initWithFrame:CGRectMake(220, 370, 90, 65)] autorelease];
		[self.goalsHelpButton addTarget:self action:@selector(helpButtonPushed:) 
					   forControlEvents:UIControlEventTouchUpInside];
		self.goalsHelpButton.backgroundColor = [UIColor clearColor];
		[self addSubview:self.goalsHelpButton];
    }
    return self;
}

-(void)setData:(NSDictionary *)dict {
	
	self.fullNameLabel.text = [dict objectForKey:@"FullName"];
	
	NSDictionary *stats = [dict objectForKey:@"Stats"];
	self.medalCountLabel.text = [stats objectForKey:@"MedalCount"];
	self.trophyCountLabel.text = [stats objectForKey:@"TrophyCount"];
	self.rankedValueLabel.text = [stats objectForKey:@"Rank"];
	self.ratingValueLabel.text = [stats objectForKey:@"Rating"];
	self.ppgValueLabel.text = [stats objectForKey:@"PointsPerGame"];
	self.gpgValueLabel.text = [stats objectForKey:@"GoalsPerGame"];
	self.resultsValueLabel.text = [stats objectForKey:@"Results"];
	self.scoresValueLabel.text = [stats objectForKey:@"Scores"];
	self.goalsValueLabel.text = [stats objectForKey:@"Goals"];
	
	NSURL *url = [NSURL URLWithString:[dict objectForKey:@"AvatarUrl"]];
	if (url != nil) {
		[self.avatarView loadFromURL:url];
	}
	
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {

	
}
	
- (void)helpButtonPushed:(id)sender {
	
	UIButton *btn = (UIButton*)sender;	
	NSString *helpText = @"";
	NSDictionary *content = [[SUPrefInterface sharedSUPrefInterface] getDictionary:@"Content"];
	
	// Set the text based on a pointer comparison
	if (btn == self.rankedHelpButton) {
		helpText = [content objectForKey:@"rankedHelpText"];
	} else if (btn == self.ratingHelpButton) {
		helpText = [content objectForKey:@"ratingHelpText"];
	} else if (btn == self.ppgHelpButton) {
		helpText = [content objectForKey:@"ppgHelpText"];
	} else if (btn == gpgHelpButton) {
		helpText = [content objectForKey:@"gpgHelpText"];
	} else if (btn == self.resultsHelpButton) {
		helpText = [content objectForKey:@"resultsHelpText"];
	} else if (btn == self.scoresHelpButton) {
		helpText = [content objectForKey:@"scoresHelpText"];
	} else {
		helpText = [content objectForKey:@"goalsHelpText"];		
	}

	 
	SUTextViewController *helpView = [[SUTextViewController alloc] initWithNibName:nil bundle:nil];
	helpView.detailLabel.text = helpText;
	
	[self.parentController.navigationController pushViewController:helpView animated:YES];
	
	[helpView release];
}


@end
