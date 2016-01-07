//
//  SUEditTeamTableViewController.h
//  PredictorPro
//
//  Created by Oliver Relph on 14/07/2010.
//  Copyright 2010 Sumac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SUTeamTableViewController.h"
#import "SUFormTableCellLabelView.h"
#import "SUFormTableCellTextFieldView.h"
#import "CustomCellBackgroundView.h"
#import "MBProgressHUD.h"
#import "SUConstants.h"

@interface SUEditTeamTableViewController : UITableViewController <MBProgressHUDDelegate> {
	MBProgressHUD *HUD;
	BOOL success;
}

@property (assign) BOOL success;

- (void) editAction:(NSString *)email password:(NSString *)password;

@end