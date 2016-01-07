//
//  SUFormTableCellLabelView.h
//  PredictorPro
//
//  Created by Alexander Bobin on 14/07/2010.
//  Copyright 2010 Sumac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SUFormTableCellBaseView.h"


@interface SUFormTableCellLabelView : SUFormTableCellBaseView {
	UILabel *thisLabel;
}

@property (nonatomic, retain) UILabel *thisLabel;

@end
