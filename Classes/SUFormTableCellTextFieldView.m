//
//  SUFormTableCellTextFieldView.m
//  PredictorPro
//
//  Created by Justin Small on 09/07/2010.
//  Copyright 2010  Sumac. All rights reserved.
//

#import "SUFormTableCellTextFieldView.h"


@implementation SUFormTableCellTextFieldView

@synthesize textField, cellType;

- (void)dealloc {
    [super dealloc];
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier cellType:(SUFormTableCellTextFieldViewMode)thisCellType returnKey:(UIReturnKeyType)thisReturnKey {
    if ((self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])) {
		[self setCellType:(SUFormTableCellTextFieldViewMode *)thisCellType];
		textField = [[[UITextField alloc] initWithFrame:CGRectMake(140, 1, 160, 40) ] autorelease];
		textField.delegate = self;
		textField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
		textField.textColor = [UIColor whiteColor];
		switch ((int)self.cellType) {
			case SUFormTableCellTextFieldViewModeEmail:
				textField.keyboardType = UIKeyboardTypeEmailAddress;
				textField.autocorrectionType = UITextAutocorrectionTypeNo;
				break;
			case SUFormTableCellTextFieldViewModePassword:
				textField.secureTextEntry = YES;
				break;
			default:
				// Do normal text field
				
				break;
		}
		textField.returnKeyType = thisReturnKey;
		
		self.selectionStyle = UITableViewCellSelectionStyleNone;
		[self addSubview:textField];
	}
    return self;
}

- (BOOL)textFieldShouldReturn:(UITextField *)thisTextField
{
	if ((int)cellType==SUFormTableCellTextFieldViewModeEmail) {
		[thisTextField resignFirstResponder];
	} else if ((int)cellType==SUFormTableCellTextFieldViewModePassword) {
		[thisTextField resignFirstResponder];
	} else {
		[thisTextField resignFirstResponder];
	}
	[[NSNotificationCenter defaultCenter] postNotificationName:self.notificationName object:nil];
    return YES;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
	
    //[super setSelected:selected animated:animated];
	
    // Configure the view for the selected state
}



@end
