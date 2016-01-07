//
//  SUAddBanterTableViewController.h
//  PredictorPro
//
//  Created by Sumac on 16/07/2010.
//  Copyright 2010 Sumac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SUFormTableCellTextViewView.h"
#import "CustomCellBackgroundView.h"
#import "MBProgressHUD.h"


@interface SUAddBanterTableViewController : UITableViewController <MBProgressHUDDelegate> {
	BOOL success;
	MBProgressHUD *HUD;
	NSDictionary *league;
}
@property (nonatomic, retain) NSDictionary *league;
- (void) saveAction:(NSString *)banter;
@end
