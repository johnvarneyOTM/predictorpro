//
//  SUPredictionsDetailView.h
//  PredictorPro
//
//  Created by Oliver Relph on 01/07/2010.
//  Copyright 2010  Sumac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SUPredictionPickerViewController.h"
#import "SUPredictionsTableViewController.h"
#import "MBProgressHUD.h"

typedef enum {
    IsBanker,
	NotIsBanker
} MatchBankerType;

@interface SUPredictionsDetailView : UIView <MBProgressHUDDelegate> {
	
	MatchBankerType bankerType;
	
	// Team One (left)
	UILabel *teamOneNameLabel;
	UILabel *teamOnePredictionLabel;
	UILabel *teamOneResultLabel;	
	// Team Two (right)
	UILabel *teamTwoNameLabel;
	UILabel *teamTwoPredictionLabel;
	UILabel *teamTwoResultLabel;
	
	MBProgressHUD *HUD;
	UIButton *bankerButton;
	
	NSString *matchId;
	
	SUPredictionPickerViewController *predictionPickerView;
	
	NSInteger totalBankers;
	NSInteger remainingBankers;
	
	BOOL savedSuccessful;
	
}


// used to get data from another class
-(void)setData:(NSDictionary *)dict maxBankers:(NSInteger)mb remainingBankers:(NSInteger)rb;
-(void)saveData;
-(void)beginSave;

@property (assign) MatchBankerType bankerType;
@property (nonatomic) NSInteger totalBankers;
@property (nonatomic) NSInteger remainingBankers;
@property (nonatomic) BOOL savedSuccessful;

@property (nonatomic, retain) NSString *matchId;

// Team One (left)
@property (nonatomic, assign) UILabel *teamOneNameLabel;
@property (nonatomic, retain) NSString *teamOneCode;
@property (nonatomic, retain) UILabel *teamOnePredictionLabel;
@property (nonatomic, retain) UILabel *teamOneResultLabel;

// Team Two (right)
@property (nonatomic, retain) UILabel *teamTwoNameLabel;
@property (nonatomic, retain) NSString *teamTwoCode;
@property (nonatomic, retain) UILabel *teamTwoPredictionLabel;
@property (nonatomic, retain) UILabel *teamTwoResultLabel;


@property (nonatomic, retain) UIButton *bankerButton;

@property (nonatomic, retain) SUPredictionPickerViewController *predictionPickerView;
@end
