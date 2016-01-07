//
//  SUFormTableCellSwitchView.h
//  PredictorPro
//
//  Created by Alexander Bobin on 15/07/2010.
//  Copyright 2010 Sumac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SUFormTableCellBaseView.h"


@interface SUFormTableCellSwitchView : SUFormTableCellBaseView {
	UISwitch *thisSwitch;
}

@property (nonatomic, retain) UISwitch *thisSwitch;

@end
