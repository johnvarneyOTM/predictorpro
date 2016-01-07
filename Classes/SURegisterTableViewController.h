//
//  SURegisterTableViewController.h
//  PredictorPro
//
//  Created by Alexander Bobin on 12/07/2010.
//  Copyright 2010 Sumac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PredictorProAppDelegate.h"
#import "SUFormTableCellTextFieldView.h"
#import "CustomCellBackgroundView.h"
#import "MBProgressHUD.h"
#import "SUConstants.h"

@interface SURegisterTableViewController : UITableViewController <MBProgressHUDDelegate> {
	MBProgressHUD *HUD;
	BOOL success;
}

@property (assign) BOOL success;
- (void) makeEmailFirstResponder;
@end
