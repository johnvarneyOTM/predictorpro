//
//  SUFormTableCellNavView.m
//  PredictorPro
//
//  Created by Justin Small on 09/07/2010.
//  Copyright 2010  Sumac. All rights reserved.
//

#import "SUFormTableCellNavView.h"


@implementation SUFormTableCellNavView

- (void)dealloc {
    [super dealloc];
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if ((self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])) {
		
        // Initialization code
		self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
		
		//add image for arrow
		self.accessoryView = [[[UIImageView alloc] initWithImage:[UIImage imageNamedFallbackToPng:@"accDisclosureWhite"]] autorelease];
		
		self.textLabel.textColor = [UIColor whiteColor];
		
		self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}


@end
