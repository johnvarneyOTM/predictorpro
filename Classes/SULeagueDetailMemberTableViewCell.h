//
//  SULeagueDetailMemberTableViewCell.h
//  PredictorPro
//
//  Created by Sumac on 15/07/2010.
//  Copyright 2010 Sumac. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface SULeagueDetailMemberTableViewCell : UITableViewCell {
	
	UILabel *memberPlace;
	UILabel *memberPoints;
	UIImageView *memberImage;
}


@property (nonatomic, retain) UILabel *memberPlace;
@property (nonatomic, retain) UILabel *memberPoints;
@property (nonatomic, retain) UIImageView *memberImage;

@end
