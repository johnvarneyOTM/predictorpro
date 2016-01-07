//
//  SUFormTableCellTextViewView.h
//  PredictorPro
//
//  Created by Alexander Bobin on 15/07/2010.
//  Copyright 2010 Sumac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SUFormTableCellBaseView.h"


@interface SUFormTableCellTextViewView : SUFormTableCellBaseView <UITextViewDelegate> {
	UILabel *thisLabel;
	UITextView *thisTextView;
}

@property (nonatomic, retain) UILabel *thisLabel;
@property (nonatomic, retain) UITextView *thisTextView;

@end
