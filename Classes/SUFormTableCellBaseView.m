//
//  SUFormTableCellBaseView.m
//  PredictorPro
//
//  Created by Justin Small on 09/07/2010.
//  Copyright 2010  Sumac. All rights reserved.
//

#import "SUFormTableCellBaseView.h"


@implementation SUFormTableCellBaseView

@synthesize baseType, notificationName;

- (void)dealloc {
	[notificationName release];
    [super dealloc];
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if ((self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])) {
        self.backgroundColor = [UIColor blackColor];
		self.textLabel.textColor = UIColorFromRGB(0x81838d);
		
		self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
	
    //[super setSelected:selected animated:animated];
	
    // Configure the view for the selected state
}

@end
