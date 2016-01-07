//
//  SULeaguesTableViewController.h
//  PredictorPro
//
//  Created by Sumac on 13/07/2010.
//  Copyright 2010 Sumac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"
#import "SULeagueDetailTableViewController.h"
#import "SUEditLeagueTableViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "PullToRefreshTableViewController.h"



@interface SULeaguesTableViewController : PullToRefreshTableViewController <MBProgressHUDDelegate> {
	
	MBProgressHUD *HUD;
	NSArray *userLeagues;
	
}

@property (nonatomic, retain) NSArray *userLeagues;
- (void)loadDetailForLeague:(NSString *)leagueId;
- (void)synchingDone:(NSNotification *)notification;
@end
