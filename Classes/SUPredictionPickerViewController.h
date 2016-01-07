//
//  SUPredictionPickerViewController.h
//  PredictorPro
//
//  Created by Oliver Relph on 05/07/2010.
//  Copyright 2010  Sumac. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface SUPredictionPickerViewController : UIViewController <UIPickerViewDataSource, UIPickerViewDelegate> {
	
	@private UIPickerView *teamOnePickerView;
	@private UIPickerView *teamTwoPickerView;
	@private NSMutableArray *arrayScores;
	NSInteger teamOnePrediction;
	NSInteger teamTwoPrediction;
	
	NSString* notificationName;
}
@property (nonatomic, retain) NSString *notificationName;

@property (nonatomic, retain) UIPickerView *teamOnePickerView;
@property (nonatomic, retain) UIPickerView *teamTwoPickerView;
@property (nonatomic, retain) NSMutableArray *arrayScores;

@property (nonatomic) NSInteger teamOnePrediction;
@property (nonatomic) NSInteger teamTwoPrediction;

-(void)setTeamOne:(NSString *)teamOne teamTwo:(NSString *)teamTwo;
@end
