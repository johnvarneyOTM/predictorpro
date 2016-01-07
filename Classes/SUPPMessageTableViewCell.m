//
//  SUPPMessageTableViewCell.m
//  PredictorPro
//
//  Created by Oliver Relph on 20/07/2010.
//  Copyright 2010 Sumac. All rights reserved.
//

#import "SUPPMessageTableViewCell.h"


@implementation SUPPMessageTableViewCell
@synthesize messageLabel;

- (void)dealloc {
    [super dealloc];
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if ((self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])) {
        // Initialization code
		
		UIImageView *iv = [[[UIImageView alloc] initWithImage:[UIImage imageNamedFallbackToPng:@"ppMessageBg"]] autorelease];	
		[self.contentView addSubview:iv];
		
		self.messageLabel = [[[UILabel alloc] initWithFrame:CGRectMake(30, 10, 260, 60)] autorelease];
		self.messageLabel.backgroundColor = [UIColor clearColor];
		
		self.messageLabel.numberOfLines = 3;
		self.messageLabel.textAlignment = UITextAlignmentCenter;
		self.messageLabel.textColor = [UIColor whiteColor];
		self.messageLabel.font = [UIFont boldSystemFontOfSize:14];
		[self.contentView addSubview:self.messageLabel];
				
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
	[super drawRect:rect];
	

}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {

    //[super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
