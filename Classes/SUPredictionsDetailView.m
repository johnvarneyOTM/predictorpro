//
//  SUPredictionsDetailView.m
//  PredictorPro
//
//  Created by Oliver Relph on 01/07/2010.
//  Copyright 2010 Sumac. All rights reserved.
//

#import "SUPredictionsDetailView.h"
#define PREDICTIONS_UPDATED @"predictonsUpdated"

@implementation SUPredictionsDetailView

@synthesize teamOneNameLabel, teamOneCode, teamOnePredictionLabel, teamOneResultLabel;
@synthesize teamTwoNameLabel, teamTwoCode, teamTwoPredictionLabel, teamTwoResultLabel;
@synthesize predictionPickerView, matchId, bankerButton, totalBankers, remainingBankers, bankerType;
@synthesize savedSuccessful;

- (void)dealloc {
	self.matchId = nil;
	self.teamOnePredictionLabel = nil;
	self.teamOneResultLabel = nil;
	self.teamTwoPredictionLabel = nil;
	self.teamTwoResultLabel = nil;
    self.predictionPickerView = nil;
	
    [super dealloc];
}

#define DELTA 50.0
#define PICKERDELTA 80.0

- (id)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
        // Initialization code
        CGRect imageFrame = CGRectMake(0.0, DELTA, frame.size.width, frame.size.height);
        
		UIImageView *iv = [[UIImageView alloc] initWithFrame:imageFrame];
		[iv setImage:[UIImage imageNamedFallbackToPng:@"predictionsDetailViewBackground"]];
		[self addSubview:iv];
        [iv release];
		
		// we need a view to place our labels on	
		CGRect viewBounds = self.bounds;
        CGFloat boundsX = viewBounds.origin.x;
        CGFloat boundsY = viewBounds.origin.y;
		
		/*
		 * teamOne
		 */			
		// Name label.
		self.teamOneNameLabel = [[[UILabel alloc] initWithFrame:CGRectMake(boundsX + 54.0f, boundsY + 100.0f+DELTA, 61.0f, 20.0f)] autorelease];
		self.teamOneNameLabel.textColor = UIColorFromRGB(0x19191a);
		self.teamOneNameLabel.font = [UIFont boldSystemFontOfSize:10];
		self.teamOneNameLabel.shadowColor = [UIColor whiteColor];
		self.teamOneNameLabel.shadowOffset = CGSizeMake(0, 1.0);
		self.teamOneNameLabel.textAlignment = UITextAlignmentCenter;
		self.teamOneNameLabel.backgroundColor = [UIColor clearColor];
		[self addSubview:self.teamOneNameLabel];
				
		/*
		 *teamTwo
		 */				
		// Name label.
		self.teamTwoNameLabel = [[[UILabel alloc] initWithFrame:CGRectMake(boundsX + 205.0f, boundsY + 100.0f+DELTA, 61.0f, 20.0f)] autorelease];
		self.teamTwoNameLabel.textColor = UIColorFromRGB(0x19191a);
		self.teamTwoNameLabel.font = [UIFont boldSystemFontOfSize:10];
		self.teamTwoNameLabel.shadowColor = [UIColor whiteColor];
		self.teamTwoNameLabel.shadowOffset = CGSizeMake(0, 1.0);
		self.teamTwoNameLabel.textAlignment = UITextAlignmentCenter;
		self.teamTwoNameLabel.backgroundColor = [UIColor clearColor];
		[self addSubview:self.teamTwoNameLabel];
		
		
			
		// Pickers
		self.predictionPickerView = [[[SUPredictionPickerViewController alloc] initWithNibName:nil bundle:nil] autorelease];

		[self addSubview:predictionPickerView.view];
 
        
		predictionPickerView.notificationName = PREDICTIONS_UPDATED;
					
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(beginSave) name:PREDICTIONS_UPDATED object:nil];
				
        
		// Banker Button		
		self.bankerButton = [[[UIButton alloc] initWithFrame:CGRectMake(139.0f, 260.0f+PICKERDELTA, 41, 38)] autorelease];
		[self.bankerButton setImage:[UIImage imageNamedFallbackToPng:@"bankerButtonOn"] forState:UIControlStateSelected];
		[self.bankerButton setImage:[UIImage imageNamedFallbackToPng:@"bankerButtonOn"] forState:UIControlStateHighlighted];
		[self.bankerButton setImage:[UIImage imageNamedFallbackToPng:@"bankerButtonOff"] forState:UIControlStateNormal];
		[self.bankerButton setTitle:@"0/0" forState:UIControlStateNormal];
		[self.bankerButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
		[self.bankerButton setTitleColor:UIColorFromRGB(0xecbd30) forState:UIControlStateHighlighted];
		[self.bankerButton setTitleColor:UIColorFromRGB(0xecbd30) forState:UIControlStateSelected];
		[self.bankerButton.titleLabel setShadowColor:[UIColor whiteColor]];
		[self.bankerButton.titleLabel setShadowOffset:CGSizeMake(0, 1)];
		[bankerButton.titleLabel setFont:[UIFont boldSystemFontOfSize:13.0]];
		[bankerButton setTitleEdgeInsets:UIEdgeInsetsMake(0.0, -40, -15.0, 0.0)];
		self.bankerButton.backgroundColor = [UIColor clearColor];
		
  
        
        
		[self.bankerButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
		[self.bankerButton addTarget:self action:@selector(toggleBanker:) forControlEvents:UIControlEventTouchUpInside];		
		[self addSubview:self.bankerButton];
        
        UILabel* label = [[UILabel alloc] init];
        label.text = @"Banker";
        label.textColor = [UIColor whiteColor];
        CGRect bF = self.bankerButton.frame;
        label.frame = CGRectOffset(bF, 5.0, -34.0);
        label.frame = CGRectInset(label.frame, -10.0, 0.0);
        label.font = [UIFont systemFontOfSize:15.0];
        [self addSubview:label];

    }
    return self;
}
-(void)toggleBanker:(id)pointer {
		
	if (self.bankerType == IsBanker) {
		// increment
		if (self.remainingBankers < self.totalBankers) {
			self.remainingBankers += 1;
			[self.bankerButton setSelected:NO];
			self.bankerType = NotIsBanker;
		} else {
			[self.bankerButton setSelected:YES];
		}

	} else {
		// decrease
		if (self.remainingBankers > 0) {
			self.remainingBankers -= 1;
			[self.bankerButton setSelected:YES];
			self.bankerType = IsBanker;
		} else {			
			[self.bankerButton setSelected:NO];
		}

	}
	
	[self.bankerButton setTitle:[NSString stringWithFormat:@"%i/%i", self.remainingBankers, self.totalBankers] forState:UIControlStateNormal];
	
	
	

}

- (void)layoutSubviews {
	
    [super layoutSubviews];
	
	CGRect viewBounds = self.bounds;
	CGFloat boundsX = viewBounds.origin.x;
	CGFloat boundsY = viewBounds.origin.y;
	
	
	UIImageView *teamOneLogoView = [[[UIImageView alloc] initWithFrame:CGRectMake(boundsX + 62.0f, boundsY + 50.0f + DELTA, 45.0f, 45.0f)] autorelease];
	[teamOneLogoView setImage:[UIImage imageNamedFallbackToPng:self.teamOneCode]];		
	[self addSubview:teamOneLogoView];
	UIImageView *teamTwoLogoView = [[[UIImageView alloc] initWithFrame:CGRectMake(boundsX + 213.0f, boundsY + 50.0f + DELTA, 45.0f, 45.0f)] autorelease];
	[teamTwoLogoView setImage:[UIImage imageNamedFallbackToPng:self.teamTwoCode]];		
	[self addSubview:teamTwoLogoView];
	
}

-(void)setData:(NSDictionary *)dict maxBankers:(NSInteger)mb remainingBankers:(NSInteger)rb {
	
	self.totalBankers = mb;
	self.remainingBankers = rb;
	[self.bankerButton setTitle:[NSString stringWithFormat:@"%i/%i", rb, mb] forState:UIControlStateNormal];
	
	self.bankerType = NotIsBanker;
	
	if (mb == 0) {
		self.bankerButton.enabled = NO;
	} else {		
		self.bankerButton.enabled = YES;
	}

	
	self.matchId = [dict objectForKey:@"Id"];
	
	self.teamOneNameLabel.text = [[dict objectForKey:@"TeamHome"] objectForKey:@"Name"];
	self.teamTwoNameLabel.text = [[dict objectForKey:@"TeamAway"] objectForKey:@"Name"];
	
	self.teamOneCode = [[[dict objectForKey:@"TeamHome"] objectForKey:@"Code"] lowercaseString];
	self.teamTwoCode = [[[dict objectForKey:@"TeamAway"] objectForKey:@"Code"] lowercaseString];
    
    // hack because the webservice doesnt always return this code

    if (self.teamOneCode.length == 0){
        NSString* testName = [[dict objectForKey:@"TeamHome"] objectForKey:@"Name"];
        if (testName.length > 5.0)
            self.teamOneCode = [[testName substringWithRange:NSMakeRange(0, 4.0)] uppercaseString];
    }
    
    if (self.teamTwoCode.length == 0){
        NSString* testName = [[dict objectForKey:@"TeamAway"] objectForKey:@"Name"];
        if (testName.length > 5.0)
            self.teamTwoCode = [[testName substringWithRange:NSMakeRange(0, 4.0)]uppercaseString];
    }
   
	
	NSString *teamOnePrediction = nil;
	NSString *teamTwoPrediction = nil; 
	NSString *teamOneScore = [dict objectForKey:@"ScoreHome"];
	NSString *teamTwoScore = [dict objectForKey:@"ScoreAway"]; 
	
	NSDictionary *prediction = [dict objectForKey:@"Prediction"];
	if (![prediction isEqual:[NSNull null]]) {
		teamOnePrediction = [[dict objectForKey:@"Prediction"] objectForKey:@"ScoreHome"];
		teamTwoPrediction = [[dict objectForKey:@"Prediction"] objectForKey:@"ScoreAway"];		
				
		if ([teamOneScore isEqual:[NSNull null]]) {
			teamOneScore = @"-";
			teamTwoScore = @"-";
		}	
		
		if([[prediction objectForKey:@"Banker"] intValue] == 1) {
			self.bankerType = IsBanker;
			[self.bankerButton setSelected:YES];
		}
		
	} else {
		
		teamOneScore = @"-";
		teamTwoScore = @"-";
		
		teamOnePrediction = @"-";
		teamTwoPrediction = @"-";
	}
	
	self.teamOneResultLabel.text = teamOneScore;
	self.teamTwoResultLabel.text = teamTwoScore;
	
	self.teamOnePredictionLabel.text = teamOnePrediction;
	self.teamTwoPredictionLabel.text = teamTwoPrediction;
	
	NSString *teamOnePred = @"0";
	NSString *teamTwoPred = @"0";
	
	if (![teamOnePrediction isEqual:@"-"]) {
		teamOnePred = [[dict objectForKey:@"Prediction"] objectForKey:@"ScoreHome"];
	}
	if (![teamTwoPrediction isEqual:@"-"]) {
		teamTwoPred = [[dict objectForKey:@"Prediction"] objectForKey:@"ScoreAway"];
	}
		
	[self.predictionPickerView setTeamOne:teamOnePred teamTwo:teamTwoPred];
	
}



-(void)beginSave {
	
	[self setUserInteractionEnabled:NO];
	// show loading
	HUD = [[MBProgressHUD alloc] initWithView:self];
	
	// Add HUD to screen
	[self addSubview:HUD];
	
	// Register for HUD callbacks so we can remove it from the window at the right time
	HUD.delegate = self;
	
	HUD.labelText = @"Saving";
	
	// Show the HUD while the provided method executes in a new thread
	[HUD showWhileExecuting:@selector(saveData) onTarget:self withObject:nil animated:YES];
	
	
}
-(void)saveData {
	
  //  NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	@autoreleasepool {
  
	NSInteger teamOnePrediction = (NSInteger)self.predictionPickerView.teamOnePrediction;
	NSInteger teamTwoPrediction = (NSInteger)self.predictionPickerView.teamTwoPrediction;
	
	
	self.savedSuccessful = [[SUAPIInterface sharedSUAPIInterface] updatePredictionMatchId:self.matchId homeTeam:teamOnePrediction awayTeam:teamTwoPrediction banker:(BOOL)(self.bankerType == IsBanker ? YES : NO)];

}
	//pool = nil;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/


#pragma mark -
#pragma mark MBProgressHUD delegate methods
- (void)hudWasHidden {
	
	if (!self.savedSuccessful) {
		UIAlertView *errorAlert = [[UIAlertView alloc] initWithTitle: @"Woops" message:[[SUAPIInterface sharedSUAPIInterface] errorMessage] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
		[errorAlert show];
		[errorAlert release];
	}
	[self setUserInteractionEnabled:YES];

}

@end
