//
//  SUPredictionsTableViewCell.h
//  PredictorPro
//
//  Created by Oliver Relph on 28/06/2010.
//  Copyright 2010 Sumac. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 * Match Statuses.
 */
typedef enum {
    SUPredictionsTableViewCellModeOpen,
	SUPredictionsTableViewCellModePredicted,
	SUPredictionsTableViewCellModeClosed
} SUPredictionsTableViewCellMode;

typedef enum {
    CellIsBanker,
	NotCellIsBanker
} MatchCellBankerType;

@interface SUPredictionsTableViewCell : UITableViewCell {
	
	
	MatchCellBankerType bankerType;
	
	SUPredictionsTableViewCellMode cellMode;
		
	// Team One (left)
	UILabel *teamOneNameLabel;
	UILabel *teamOnePredictionLabel;
	UILabel *teamOneResultLabel;	
	// Team Two (right)
	UILabel *teamTwoNameLabel;
	UILabel *teamTwoPredictionLabel;
	UILabel *teamTwoResultLabel;
	
	UILabel *matchPointsLabel;
    
    UILabel *kickOffTimeLabel;
    UILabel *matchsPointLabel;
	
	UILabel *versusLabel;
	UIImageView *bankerIcon;
	
	NSDictionary *match;
	
}


// Used to set data from another class
-(void)setData:(NSDictionary *)dict;

@property (assign) MatchCellBankerType bankerType;
// Generic
@property (nonatomic, retain) UILabel *kickOffTimeLabel;
@property (assign) SUPredictionsTableViewCellMode cellMode;
@property (nonatomic, retain) UILabel *versusLabel;
@property (nonatomic, retain) UIImageView *bankerIcon;

// Team One (left)
@property (nonatomic, retain) UILabel *teamOneNameLabel;
@property (nonatomic, retain) NSString *teamOneCode;
@property (nonatomic, retain) UILabel *teamOnePredictionLabel;
@property (nonatomic, retain) UILabel *teamOneResultLabel;

// Team Two (right)
@property (nonatomic, retain) UILabel *teamTwoNameLabel;
@property (nonatomic, retain) NSString *teamTwoCode;
@property (nonatomic, retain) UILabel *teamTwoPredictionLabel;
@property (nonatomic, retain) UILabel *teamTwoResultLabel;

@property (nonatomic, retain) UILabel *matchPointsLabel;
@property (nonatomic, retain) NSDictionary *match;

@end
