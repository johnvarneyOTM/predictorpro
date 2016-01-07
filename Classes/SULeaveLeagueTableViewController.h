//
//  SULeaveLeagueTableViewController.h
//  PredictorPro
//
//  Created by Alexander Bobin on 16/07/2010.
//  Copyright 2010 Sumac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SUFormTableCellButtonView.h"
#import "CustomCellBackgroundView.h"
#import "MBProgressHUD.h"


@interface SULeaveLeagueTableViewController : UITableViewController <MBProgressHUDDelegate> {
	MBProgressHUD *HUD;
	NSString *leagueId;
	BOOL success;
}

@property (assign) BOOL success;
@property (nonatomic, retain) NSString *leagueId;

@end
