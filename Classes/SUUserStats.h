//
//  SUUserStats.h
//  PredictorPro
//
//  Created by Sumac on 26/07/2010.
//  Copyright 2010 Sumac. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface SUUserStats : NSObject {
	NSMutableDictionary *rawStats;
}

- (id)initWithUserStatsDictionary:(NSMutableDictionary *)dict;

- (NSInteger)goals;
- (NSInteger)results;
- (NSInteger)scores;
- (NSInteger)points;
- (NSInteger)bankers;
- (NSInteger)bankerCount;

@end
