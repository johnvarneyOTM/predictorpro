//
//  SULeagueDetailBanterTableViewCell.m
//  PredictorPro
//
//  Created by Sumac on 15/07/2010.
//  Copyright 2010 Sumac. All rights reserved.
//

#import "SULeagueDetailBanterTableViewCell.h"


CGFloat const BANTER_LABEL_WIDTH  = 218;
CGFloat const BANTER_FONT_SIZE  = 15.0f;

@implementation SULeagueDetailBanterTableViewCell

@synthesize gradientView, teamNameLabel, dateLabel, messageLabel;


- (void)dealloc {
    self.messageLabel = nil;    
    self.teamNameLabel = nil;
    self.dateLabel = nil;
    
    [super dealloc];
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if ((self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])) {
        // Initialization code
		
		// i'm so sorry.
		
		// add the background image
		UIImageView *avatarImage = [[UIImageView alloc] initWithImage:
									[UIImage imageNamedFallbackToPng:@"leagueBanterImageBackground"]];
		avatarImage.frame = CGRectMake(10,10, 62, 47);
		[self addSubview:avatarImage];
		[avatarImage release];		
		
		// add the label
		self.messageLabel = [[[UILabel alloc] initWithFrame:CGRectMake(82, 35, BANTER_LABEL_WIDTH, 20)] autorelease];
        // inital size is overriden by redraw label.
		self.messageLabel.font = [UIFont systemFontOfSize:BANTER_FONT_SIZE];
		self.messageLabel.numberOfLines = 0; // allow multiline
		self.messageLabel.backgroundColor = [UIColor clearColor];
		self.messageLabel.textColor = [UIColor blackColor];	
		[self addSubview:self.messageLabel];
		
		// add label for team
		self.teamNameLabel = [[[UILabel alloc] initWithFrame:CGRectMake(80,8, 120, 30)]autorelease];
        
        self.teamNameLabel.font = [UIFont boldSystemFontOfSize:12];
		self.teamNameLabel.textColor = UIColorFromRGB(0x6b6b6b);
		self.teamNameLabel.backgroundColor = [UIColor clearColor];
		[self addSubview:self.teamNameLabel];
		
		// add label for date
		self.dateLabel = [[[UILabel alloc] initWithFrame:CGRectMake(200,8, 100, 30)]  autorelease];
        self.dateLabel.font = [UIFont boldSystemFontOfSize:12];
		self.dateLabel.textColor = UIColorFromRGB(0x6b6b6b);
		self.dateLabel.backgroundColor = [UIColor clearColor];
		[self addSubview:self.dateLabel];
		
		// draw in a rect for the comment background.
		self.gradientView = [[[UIView alloc] initWithFrame:CGRectMake(72, 10, (BANTER_LABEL_WIDTH), 20)] autorelease];
		[self addSubview:self.gradientView];	
				
    }
    return self;
}

- (void)redrawLabel:(NSString *)text {
	
	CGSize newLabelSize = [SULeagueDetailBanterTableViewCell getTextSize:text width:BANTER_LABEL_WIDTH];
	
	self.gradientView = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 20+newLabelSize.height)] autorelease];
	CAGradientLayer *layerGradient = [CAGradientLayer layer];
	CGRect myRect = CGRectMake(72, 10, (BANTER_LABEL_WIDTH+20), 35+newLabelSize.height);
	//myRect.origin = CGPointMake(0,0);
	layerGradient.frame = myRect;
	layerGradient.colors = [NSArray arrayWithObjects:(id)[UIColorFromRGB(0xffffff) CGColor], (id)[UIColorFromRGB(0xdbdbdb) CGColor], nil];
	[layerGradient setCornerRadius:5];
	[self.gradientView.layer insertSublayer:layerGradient atIndex:0];
	self.backgroundView = self.gradientView;
	
	CGRect newLabelFrame = self.messageLabel.frame;
	newLabelFrame.size = newLabelSize;
	self.messageLabel.frame = newLabelFrame;
	self.messageLabel.text = text;
	
	self.selectionStyle = UITableViewCellSelectionStyleNone;
	
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {

    //[super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+ (CGFloat)getHeightOfCell:(NSString *)cellText {
	
	CGSize size = [SULeagueDetailBanterTableViewCell getTextSize:cellText width:BANTER_LABEL_WIDTH];
	return size.height + 55.0f;
	
}

+ (CGSize)getTextSize:(NSString *)cellText width:(CGFloat)width {
	
	CGSize constraintSize;
	constraintSize.width = width;
	constraintSize.height = MAXFLOAT;
	CGSize theSize = [cellText sizeWithFont:[UIFont systemFontOfSize:BANTER_FONT_SIZE] constrainedToSize:constraintSize lineBreakMode:UILineBreakModeWordWrap];
	//NSLog(@" calc Size %f", theSize.height);
	theSize.height = theSize.height;
	return theSize;
	
}

@end
