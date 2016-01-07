//
//  SULeagueDetailTableViewController.h
//  PredictorPro
//
//  Created by Oliver Relph on 15/07/2010.
//  Copyright 2010 Sumac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SULeagueDetailMemberTableViewCell.h"
#import "SULeagueDetailBanterTableViewCell.h"
#import "SUEditLeagueTableViewController.h"
#import "SULeaveLeagueTableViewController.h"
#import "SUAddBanterTableViewController.h"
#import "SUTeamTableViewController.h"
#import "SUTextViewController.h"
#import "PullToRefreshTableViewController.h"

typedef enum {
    SULeagueDetailTableViewControllerModeLeague,
    SULeagueDetailTableViewControllerModeBanter,
    SULeagueDetailTableViewControllerModeInfo
} SULeagueDetailTableViewControllerMode;

typedef enum {
    SULeagueDetailTableViewControllerAPIModeLoadLeague,
    SULeagueDetailTableViewControllerAPIModeJoinLeague
} SULeagueDetailTableViewControllerAPIMode;

@interface SULeagueDetailTableViewController : PullToRefreshTableViewController <MBProgressHUDDelegate> {
	SULeagueDetailTableViewControllerMode viewMode;
	SULeagueDetailTableViewControllerAPIMode apiMode;
	UIView *segBar;
	NSString *leagueId;
	NSDictionary *league;
	MBProgressHUD *HUD;
	BOOL success;
	BOOL currentUserIsPartOfLeague;
	BOOL currentUserIsCreatorOfLeague;
	UISegmentedControl *detailControl;
}

- (NSString *)banterTextForIndex:(NSInteger)indexNo;
- (void) loadLeague;
- (void)synchingDone:(NSNotification *)notification;
@property(assign) BOOL success;
@property(nonatomic) SULeagueDetailTableViewControllerMode viewMode;
@property(nonatomic) SULeagueDetailTableViewControllerAPIMode apiMode;
@property(nonatomic, retain) NSString *leagueId;
@property(nonatomic, retain) NSDictionary *league;
@property(nonatomic, retain) UIView *segBar;
@property(assign) BOOL currentUserIsPartOfLeague;
@property(assign) BOOL currentUserIsCreatorOfLeague;
@property(nonatomic, retain) UISegmentedControl *detailControl;

@end
