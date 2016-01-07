//
//  SUMatch.h
//  PredictorPro
//
//  Created by Sumac on 23/07/2010.
//  Copyright 2010 Sumac. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef enum {
    SUMatchStatusOpen,
	SUMatchStatusPredicted,
	SUMatchStatusClosed
} SUMatchStatus;

@interface SUMatch : NSObject {
	
	NSMutableDictionary *rawMatch;
	
	NSString *matchId;
	SUMatchStatus matchStatus;
	NSDate *closesDate;
	
	NSString *teamOneName;
	NSString *teamTwoName;
	
	BOOL hasPrediction;
	BOOL hasBanker;
	
}

@property (retain, nonatomic) NSMutableDictionary *rawMatch;

- (NSString *)matchId;
- (NSDate *)closesDate;
- (NSString *)localDateString;
- (SUMatchStatus)matchStatus;

- (NSString *)teamOneName;
- (NSString *)teamTwoName;

- (NSString *)teamOneCode;
- (NSString *)teamTwoCode;

- (NSString *)teamOneScore;
- (NSString *)teamTwoScore;

- (NSString *)teamOnePrediction;
- (NSString *)teamTwoPrediction;

- (NSString *)points;
	
- (BOOL)hasPrediction;
- (BOOL)hasBanker;
	

- (id)initWithMatchDictionary:(NSMutableDictionary *)dict;

@end
