//
//  SUFormTableCellTextFieldView.h
//  PredictorPro
//
//  Created by Justin Small on 09/07/2010.
//  Copyright 2010  Sumac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SUFormTableCellBaseView.h"

typedef enum {
    SUFormTableCellTextFieldViewModeDefault,
	SUFormTableCellTextFieldViewModeEmail,
	SUFormTableCellTextFieldViewModePassword,
	SUFormTableCellTextFieldViewModeNumber
} SUFormTableCellTextFieldViewMode;

@interface SUFormTableCellTextFieldView : SUFormTableCellBaseView <UITextFieldDelegate>  {
	UITextField *textField;
	SUFormTableCellTextFieldViewMode *cellType;
}

@property (assign) SUFormTableCellTextFieldViewMode *cellType;
@property (nonatomic, retain) UITextField *textField;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier cellType:(SUFormTableCellTextFieldViewMode)thisCellType returnKey:(UIReturnKeyType)thisReturnKey;

@end
