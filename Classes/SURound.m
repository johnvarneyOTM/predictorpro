//
//  SURound.m
//  PredictorPro
//
//  Created by Sumac on 26/07/2010.
//  Copyright 2010 Sumac. All rights reserved.
//

#import "SURound.h"


@implementation SURound
@synthesize matches, userStats;

- (id)initWithRoundDictionary:(NSMutableDictionary *)dict {
	if (dict != nil) {
		rawRound = dict;
		rawMatches = [dict objectForKey:@"Matches"];
		
		userStats = [[SUUserStats alloc] initWithUserStatsDictionary:[rawRound objectForKey:@"UserStats"]];
		
		matches = [[NSMutableArray alloc] initWithCapacity:[rawMatches count]];
		// lets parse the matches here too
		for (NSMutableDictionary *m in rawMatches) {
			[matches addObject:[[SUMatch alloc] initWithMatchDictionary:m]];
		}		
	}
	return self;
}
- (NSInteger)totalBankers {
	return [[rawRound objectForKey:@"BankerCount"] intValue];
}

- (NSInteger)newerRoundId {
	return [[rawRound objectForKey:@"NextRoundId"] intValue];
}

- (NSInteger)olderRoundId {
	return [[rawRound objectForKey:@"PreviousRoundId"] intValue];
}

- (NSMutableArray *)rawMatches {
	return [[rawRound objectForKey:@"Round"] objectForKey:@"Matches"];
}

@end
