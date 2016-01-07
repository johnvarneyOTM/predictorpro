//
//  SUFormTableCellLabelView.m
//  PredictorPro
//
//  Created by Alexander Bobin on 14/07/2010.
//  Copyright 2010 Sumac. All rights reserved.
//

#import "SUFormTableCellLabelView.h"


@implementation SUFormTableCellLabelView

@synthesize thisLabel;

- (void)dealloc {
    [super dealloc];
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if ((self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])) {
        thisLabel = [[[UILabel alloc] initWithFrame:CGRectMake(140, 1, 160, 40) ] autorelease];
		thisLabel.textColor = UIColorFromRGB(0x81838d);
		thisLabel.backgroundColor = [UIColor clearColor];
		[self addSubview:thisLabel];
		
		self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}


@end
