//
//  SULeagueDetailBanterTableViewCell.h
//  PredictorPro
//
//  Created by Sumac on 15/07/2010.
//  Copyright 2010 Sumac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>


@interface SULeagueDetailBanterTableViewCell : UITableViewCell {
	UIView *gradientView;
	UILabel *messageLabel;
	UILabel *teamNameLabel;
	UILabel *dateLabel;
}
+ (CGFloat)getHeightOfCell:(NSString *)cellText;
+ (CGSize)getTextSize:(NSString *)cellText width:(CGFloat)width;
- (void)redrawLabel:(NSString *)text;

@property (nonatomic, retain) UIView *gradientView;
@property (nonatomic, retain) UILabel *teamNameLabel;
@property (nonatomic, retain) UILabel *dateLabel;
@property (nonatomic, retain) UILabel *messageLabel;


@end
