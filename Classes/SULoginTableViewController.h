//
//  SULoginTableViewController.h
//  PredictorPro
//
//  Created by Justin Small on 08/07/2010.
//  Copyright 2010  Sumac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PredictorProAppDelegate.h"
#import "SURegisterTableViewController.h"
#import "SUFormTableCellTextFieldView.h"
#import "SUFormTableCellTextViewView.h"
#import "SUFormTableCellNavView.h"
#import "SUFormTableCellButtonView.h"
#import "CustomCellBackgroundView.h"
#import "MBProgressHUD.h"
#import "SUConstants.h"

@interface SULoginTableViewController : UITableViewController <MBProgressHUDDelegate> {
	MBProgressHUD *HUD;
	BOOL success;
}

@property (assign) BOOL success;

@end
