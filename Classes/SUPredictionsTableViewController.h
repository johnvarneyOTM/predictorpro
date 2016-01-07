//
//  SUPredictionsTableViewController.h
//  PredictorPro
//
//  Created by Oliver Relph on 28/06/2010.
//  Copyright 2010 Sumac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"
#import "PullToRefreshTableViewController.h"
#import "SUPredictionsTableViewHeader.h"

@interface SUPredictionsTableViewController : PullToRefreshTableViewController <MBProgressHUDDelegate> {
	NSInteger olderRoundId;
	NSInteger newerRoundId;
	
	MBProgressHUD *HUD;
	NSMutableArray *sectionHeaders;
	NSMutableArray *rowsForSection;
	SUPredictionsTableViewHeader *tableHeader;
	
	NSInteger totalBankers;
	NSInteger remainingBankers;
}

-(void)synchingDone:(NSNotification *)notification;
-(BOOL)loadDataForRound:(NSInteger)roundId;
//@property (nonatomic) NSInteger currentRoundId;
@property (nonatomic) NSInteger olderRoundId;
@property (nonatomic) NSInteger newerRoundId;

@property (nonatomic, retain) NSMutableArray *sectionHeaders;
@property (nonatomic, retain) NSMutableArray *rowsForSection;
@property (nonatomic, retain) SUPredictionsTableViewHeader *tableHeader;

@property (nonatomic) NSInteger totalBankers;
@property (nonatomic) NSInteger remainingBankers;
@end
