//
//  SUEditLeagueTableViewController.h
//  PredictorPro
//
//  Created by Alexander Bobin on 15/07/2010.
//  Copyright 2010 Sumac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SUTeamTableViewController.h"
#import "SUFormTableCellLabelView.h"
#import "SUFormTableCellTextFieldView.h"
#import "SUFormTableCellNavView.h"
#import "SUFormTableCellSwitchView.h"
#import "SUFormTableCellTextViewView.h"
#import "CustomCellBackgroundView.h"
#import "MBProgressHUD.h"
#import "SUConstants.h"
#import "SUFriendPickerTableViewController.h"

typedef enum {
    SUEditLeagueTableViewModeCreate,
	SUEditLeagueTableViewModeEdit
} SUEditLeagueTableViewMode;

@interface SUEditLeagueTableViewController : UITableViewController <MBProgressHUDDelegate, UITableViewDelegate> {
	SUEditLeagueTableViewMode *thisMode;
	MBProgressHUD *HUD;
	UIView *footerView;
	NSDictionary *league;
	BOOL success;
}

@property (assign) SUEditLeagueTableViewMode *thisMode;
@property (nonatomic, retain) NSDictionary *league;
@property (assign) BOOL success;
- (void) saveAction:(NSString *)name inviteOnly:(BOOL)inviteOnly description:(NSString *)description;
- (id) initWithStyle:(UITableViewStyle)style viewMode:(SUEditLeagueTableViewMode)thisViewMode;
- (void) saveLeague:(NSArray *)leagueDetails;
- (void) sendSaveAction;

@end
