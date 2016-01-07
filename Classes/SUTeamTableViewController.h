//
//  SUTeamTableViewController.h
//  PredictorPro
//
//  Created by Oliver Relph on 13/07/2010.
//  Copyright 2010 Sumac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SUEditTeamTableViewController.h"
#import "SULeagueDetailTableViewController.h"
#import "MBProgressHUD.h"
#import <QuartzCore/QuartzCore.h>
#import "SUTeamDetailView.h"

@interface SUTeamTableViewController : UITableViewController <MBProgressHUDDelegate> {
	
	MBProgressHUD *HUD;
	NSString *teamId;
	NSArray *userLeagues;
	SUTeamDetailView *userDetails;
}

@property (nonatomic, retain) NSArray *userLeagues;
@property (nonatomic, retain) NSString *teamId;
@property (nonatomic, retain) SUTeamDetailView *userDetails;

@end
