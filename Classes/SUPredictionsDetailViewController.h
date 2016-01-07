//
//  SUPredictionsDetailViewController.h
//  PredictorPro
//
//  Created by Oliver Relph on 05/07/2010.
//  Copyright 2010  Sumac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SUPredictionsTableViewController.h"
#import "SUPredictionsDetailView.h"

@interface SUPredictionsDetailViewController : UIViewController {
	
	SUPredictionsDetailView *detailView;
	
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil data:(NSDictionary *)match maxBankers:(NSInteger)mb remainingBankers:(NSInteger)rb;

@property (nonatomic, retain) SUPredictionsDetailView *detailView;

@end
