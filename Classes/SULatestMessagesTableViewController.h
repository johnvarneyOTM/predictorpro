//
//  SULatestMessagesTableViewController.h
//  PredictorPro
//
//  Created by Oliver Relph on 13/07/2010.
//  Copyright 2010 Sumac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import "MBProgressHUD.h"
#import "SULeagueDetailBanterTableViewCell.h"
#import "SUPredictionsTableViewCell.h"
#import "PredictorProAppDelegate.h"
#import "PullToRefreshTableViewController.h"
#import "SUPPMessageTableViewCell.h"

@interface SULatestMessagesTableViewController : PullToRefreshTableViewController <MBProgressHUDDelegate, UIAlertViewDelegate, MFMailComposeViewControllerDelegate> {
	
	MBProgressHUD *HUD;
	NSMutableArray *messages;
	BOOL success;
    BOOL stopRefresh;

}

@property (nonatomic, retain) NSMutableArray *messages;

- (void)synchingDone:(NSNotification *)notification;
@end
