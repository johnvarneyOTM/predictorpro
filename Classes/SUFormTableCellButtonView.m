//
//  SUFormTableCellButtonView.m
//  PredictorPro
//
//  Created by Justin Small on 09/07/2010.
//  Copyright 2010  Sumac. All rights reserved.
//

#import "SUFormTableCellButtonView.h"


@implementation SUFormTableCellButtonView

- (void)dealloc {
    [super dealloc];
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if ((self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])) {
		
		self.textLabel.textAlignment = UITextAlignmentCenter;
		self.textLabel.textColor = [UIColor redColor];
		self.selectionStyle = UITableViewCellSelectionStyleNone;
        
    }
    return self;
}




@end
