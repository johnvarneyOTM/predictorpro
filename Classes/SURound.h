//
//  SURound.h
//  PredictorPro
//
//  Created by Sumac on 26/07/2010.
//  Copyright 2010 Sumac. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SUUserStats.h"
#import "SUMatch.h"

@interface SURound : NSObject {
	NSMutableDictionary *rawRound;
	NSMutableArray *rawMatches;
	
	NSMutableArray *matches;
	SUUserStats *userStats;
}

- (id)initWithRoundDictionary:(NSMutableDictionary *)dict;

- (NSInteger)totalBankers;

- (NSInteger)newerRoundId;
- (NSInteger)olderRoundId;

- (NSMutableArray *)rawMatches;
@property (nonatomic, assign) NSMutableArray *matches;
@property (nonatomic, assign) SUUserStats *userStats;
	
@end
