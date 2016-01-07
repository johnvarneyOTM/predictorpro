//
//  SUUserStats.m
//  PredictorPro
//
//  Created by Sumac on 26/07/2010.
//  Copyright 2010 Sumac. All rights reserved.
//

#import "SUUserStats.h"


@implementation SUUserStats


- (id)initWithUserStatsDictionary:(NSMutableDictionary *)dict {
	if (dict != nil) {
		rawStats = dict;
		
	}
	return self;
}

- (NSInteger)goals {
	NSInteger ret = 0;
	if ([rawStats objectForKey:@"Goals"] != nil) {
		ret = [[rawStats objectForKey:@"Goals"] intValue];
	}
	return ret;
}

- (NSInteger)results {
	NSInteger ret = 0;
	if ([rawStats objectForKey:@"Results"] != nil) {
		ret = [[rawStats objectForKey:@"Results"] intValue];
	}
	return ret;
}

- (NSInteger)scores {
	NSInteger ret = 0;
	if ([rawStats objectForKey:@"Scores"] != nil) {
		ret = [[rawStats objectForKey:@"Scores"] intValue];
	}
	return ret;
}

- (NSInteger)points {
	NSInteger ret = 0;
	if ([rawStats objectForKey:@"Points"] != nil) {
		ret = [[rawStats objectForKey:@"Points"] intValue];
	}
	return ret;
}

- (NSInteger)bankers {
	return [[rawStats objectForKey:@"Bankers"] intValue];
}

- (NSInteger)bankerCount {
	return [[rawStats objectForKey:@"BankerCount"] intValue];
}


@end



