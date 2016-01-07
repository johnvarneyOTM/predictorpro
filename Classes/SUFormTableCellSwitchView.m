//
//  SUFormTableCellSliderView.m
//  PredictorPro
//
//  Created by Alexander Bobin on 15/07/2010.
//  Copyright 2010 Sumac. All rights reserved.
//

#import "SUFormTableCellSwitchView.h"


@implementation SUFormTableCellSwitchView

@synthesize thisSwitch;

- (void)dealloc {
    [super dealloc];
}


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if ((self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])) {
        thisSwitch = [[[UISwitch alloc] initWithFrame:CGRectMake(140, 10, 160, 40)] autorelease];
		[self addSubview:thisSwitch];
		
		self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}
@end

