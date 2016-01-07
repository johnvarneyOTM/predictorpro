//
//  SUTeamDetailView.h
//  PredictorPro
//
//  Created by Oliver Relph on 13/07/2010.
//  Copyright 2010 Sumac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SUTextViewController.h"

@interface SUTeamDetailView : UIView {
	
	UIImageView *avatarView;
	
	UILabel *fullNameLabel;
	UILabel *medalCountLabel;
	UILabel *trophyCountLabel;
	UILabel *rankedValueLabel;	
	UILabel *ratingValueLabel;
	UILabel *ppgValueLabel;
	UILabel *gpgValueLabel;
	UILabel *resultsValueLabel;
	UILabel *scoresValueLabel;
	UILabel *goalsValueLabel;
	
	
	UIButton *rankedHelpButton;
	UIButton *ratingHelpButton;
	UIButton *ppgHelpButton;
	UIButton *gpgHelpButton;
	UIButton *resultsHelpButton;
	UIButton *scoresHelpButton;
	UIButton *goalsHelpButton;
	
	UITableViewController *parentController;
	
}
@property (nonatomic, retain) UIImageView *avatarView;

@property (nonatomic, retain) UILabel *fullNameLabel;
@property (nonatomic, retain) UILabel *medalCountLabel;
@property (nonatomic, retain) UILabel *trophyCountLabel;
@property (nonatomic, retain) UILabel *rankedValueLabel;
@property (nonatomic, retain) UILabel *ratingValueLabel;
@property (nonatomic, retain) UILabel *ppgValueLabel;
@property (nonatomic, retain) UILabel *gpgValueLabel;
@property (nonatomic, retain) UILabel *resultsValueLabel;
@property (nonatomic, retain) UILabel *scoresValueLabel;
@property (nonatomic, retain) UILabel *goalsValueLabel;

@property (nonatomic, retain) UIButton *rankedHelpButton;
@property (nonatomic, retain) UIButton *ratingHelpButton;
@property (nonatomic, retain) UIButton *ppgHelpButton;
@property (nonatomic, retain) UIButton *gpgHelpButton;
@property (nonatomic, retain) UIButton *resultsHelpButton;
@property (nonatomic, retain) UIButton *scoresHelpButton;
@property (nonatomic, retain) UIButton *goalsHelpButton;

@property (nonatomic, retain) UITableViewController *parentController;

-(void)setData:(NSDictionary *)dict;

@end
