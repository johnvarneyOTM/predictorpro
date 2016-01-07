//
//  SUPredictionsTableViewHeader.h
//  PredictorPro
//
//  Created by Oliver Relph on 30/06/2010.
//  Copyright 2010 Sumac. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface SUPredictionsTableViewHeader : UIView {
	
	UILabel *resultsCount;
	UILabel *scoresCount;
	UILabel *goalsCount;	
	UILabel *pointsCount;
	UILabel *bankerSummary;
}
// Used to set data from another class
-(void)setData:(NSDictionary *)dict;

@property (nonatomic, retain) UILabel *resultsCount;
@property (nonatomic, retain) UILabel *scoresCount;
@property (nonatomic, retain) UILabel *goalsCount;
@property (nonatomic, retain) UILabel *pointsCount;
@property (nonatomic, retain) UILabel *bankerSummary;

@end
