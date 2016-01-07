//
//  SUAPIInterface.h
//  PredictorPro
//
//  Created by Oliver Relph on 07/07/2010.
//  Copyright 2010 Sumac. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SynthesizeSingleton.h"

@interface SUAPIInterface : NSObject {
	NSString *secret;
	NSString *baseURL;
	
	NSString *email;
	NSString *password;
	NSString *teamName;
	NSString *userId;
	NSString *token;
	NSString *errorCode;
	NSString *errorMessage;
	NSInteger currentRoundId;
}
@property (readwrite, retain) NSString *secret;
@property (readwrite, retain) NSString *baseURL;

@property (readwrite, retain) NSString *email;
@property (readwrite, retain) NSString *password;
@property (readwrite, retain) NSString *teamName;
@property (readwrite, retain) NSString *userId;
@property (readwrite, retain) NSString *token;
@property (readwrite, retain) NSString *errorCode;
@property (readwrite, retain) NSString *errorMessage;
@property (nonatomic, assign) NSInteger currentRoundId;

- (NSString *)urlEncode:(NSString *)s;
- (BOOL)loginUserWithEmail:(NSString *)e password:(NSString *)p;
- (BOOL)registerUser:(NSString *)t email:(NSString *)e password:(NSString *)p;
- (BOOL)editUser:(NSString *)e password:(NSString *)p;
- (BOOL)createLeague:(NSString *)n inviteOnly:(NSString *)io description:(NSString *)d;
- (BOOL)leaveLeague:(NSString *)leagueId;
- (BOOL)joinLeague:(NSString *)leagueId;
- (BOOL)editLeague:(NSString *)l name:(NSString *)n inviteOnly:(NSString *)io description:(NSString *)d;
- (BOOL)addBanter:(NSString *)leagueId banter:(NSString *)banter;
- (NSDictionary *)getLatestMatches;
- (NSDictionary *)getMatchesForRound:(int)roundId;
- (NSDictionary *)getLeagues;
- (NSDictionary *)getLeague:(NSString *)l userId:(NSString *)u;
- (NSDictionary *)getAllLeagues;
- (NSDictionary *)getLeaguesForUser:(NSString *)uId;	
- (NSDictionary *)getUserDetails:(NSString *)uId;	
- (NSDictionary *)getAllMessages;
- (BOOL)updatePredictionMatchId:(NSString *)matchId homeTeam:(NSInteger)homeTeam awayTeam:(NSInteger)awayTeam banker:(BOOL)banker;
- (BOOL)sendInviteForLeague:(NSString *)l email:(NSString *)e;

+ (SUAPIInterface *)sharedSUAPIInterface;

@end
