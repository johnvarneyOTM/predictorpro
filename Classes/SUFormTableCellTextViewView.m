//
//  SUFormTableCellTextViewView.m
//  PredictorPro
//
//  Created by Alexander Bobin on 15/07/2010.
//  Copyright 2010 Sumac. All rights reserved.
//

#import "SUFormTableCellTextViewView.h"


@implementation SUFormTableCellTextViewView

@synthesize thisTextView, thisLabel;


- (void)dealloc {
    [super dealloc];
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier  {
    if ((self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])) {
		
		thisTextView = [[[UITextView alloc] initWithFrame:CGRectMake(15, 35, 280, 100)] autorelease];
		thisTextView.textColor = [UIColor whiteColor];
		thisTextView.backgroundColor = [UIColor clearColor];
		thisTextView.editable = YES;
		thisTextView.delegate = self;
		thisTextView.font = [UIFont systemFontOfSize:14.0f];
		[self addSubview:thisTextView];
		
		thisLabel = [[[UILabel alloc] initWithFrame:CGRectMake(20,10,120,25)] autorelease];
		thisLabel.textColor = UIColorFromRGB(0x81838d);
		thisLabel.backgroundColor = [UIColor clearColor];
		thisLabel.font = [UIFont boldSystemFontOfSize:16.0f];
		[self addSubview:thisLabel];
		
		self.textLabel.hidden = YES;
		
		self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return FALSE;
    }
    return TRUE;
}


@end
