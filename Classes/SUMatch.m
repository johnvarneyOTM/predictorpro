//
//  SUMatch.m
//  PredictorPro
//
//  Created by Sumac on 23/07/2010.
//  Copyright 2010 Sumac. All rights reserved.
//

#import "SUMatch.h"


@implementation SUMatch
@synthesize rawMatch;

- (id)initWithMatchDictionary:(NSMutableDictionary *)dict {
	if (dict != nil) {
		NSLog(@"pred %@", dict);
		self.rawMatch = dict;		
	}
	return self;
}

- (NSString *)matchId {
	return [self.rawMatch objectForKey:@"Id"];
}

- (BOOL)hasPrediction {
	BOOL ret = NO;
	if (![[self.rawMatch objectForKey:@"Prediction"] isEqual:[NSNull null]]) {
		ret = YES;
	} 
	return ret;
}

- (BOOL)hasBanker {
	BOOL ret = NO;
	if (self.hasPrediction) {
		ret = [[[self.rawMatch objectForKey:@"Prediction"] objectForKey:@"Banker"] intValue] == 1;
	}
	return ret;
}

- (NSDate *)closesDate {
	
	// if the match is closed... it overrides everything else
	NSString *dateClosesString = [self.rawMatch objectForKey:@"DateClosesString"];
	// Convert string to date object
	NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
	[dateFormat setDateFormat:@"dd/MM/yyyy HH:mm"];
	NSDate *cd = [dateFormat dateFromString:dateClosesString];
	[dateFormat release];
	return cd;
}
- (NSString *)localDateString {
	return [self.rawMatch objectForKey:@"DateLocalString"];
}

- (SUMatchStatus)matchStatus {
	
	SUMatchStatus mode = SUMatchStatusOpen;
	
	NSString *teamOneScore = [self.rawMatch objectForKey:@"ScoreHome"];
	
	NSDictionary *prediction = [self.rawMatch objectForKey:@"Prediction"];
	if (![prediction isEqual:[NSNull null]]) {
		
		mode = SUMatchStatusPredicted;
		
	} 	
		
	NSDate *localDate = [[NSDate alloc] init];	
    if ([closesDate compare:localDate] == NSOrderedAscending || ![teamOneScore isEqual:@"-"]){
		mode = SUMatchStatusClosed;
	}	
	[localDate release];
	
	return mode;
}

- (NSString *)teamOneName {
	return [[self.rawMatch objectForKey:@"TeamHome"] objectForKey:@"Name"];
}

- (NSString *)teamTwoName {
	return [[self.rawMatch objectForKey:@"TeamAway"] objectForKey:@"Name"];
}

- (NSString *)teamOneCode {
	return [[[self.rawMatch objectForKey:@"TeamHome"] objectForKey:@"Code"] lowercaseString];
}

- (NSString *)teamTwoCode {
	return [[[self.rawMatch objectForKey:@"TeamAway"] objectForKey:@"Code"] lowercaseString];
}

- (NSString *)teamOneScore {
	return [self.rawMatch objectForKey:@"ScoreHome"];
}

- (NSString *)teamTwoScore {
	return [self.rawMatch objectForKey:@"ScoreAway"];
}

- (NSString *)teamOnePrediction {
	NSString *ret = @"-";
	if ([self hasPrediction]) {
		ret = [[self.rawMatch objectForKey:@"Prediction"] objectForKey:@"ScoreHome"];
	}
	return ret;
}

- (NSString *)teamTwoPrediction {
	NSString *ret = @"-";
	if ([self hasPrediction]) {
		ret = [[self.rawMatch objectForKey:@"Prediction"] objectForKey:@"ScoreAway"];
	}
	return ret;
}

- (NSString *)points {
	NSString *ret = @"-";
	if ([self hasPrediction]) {
		ret = [[self.rawMatch objectForKey:@"Prediction"] objectForKey:@"Points"];
	}
	return ret;
}

@end
