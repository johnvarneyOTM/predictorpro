//
//  SUAPIInterface.m
//  PredictorPro
//
//  Created by Oliver Relph on 07/07/2010.
//  Copyright 2010 Sumac. All rights reserved.
//

#import "SUAPIInterface.h"

				  
@implementation SUAPIInterface
@synthesize secret, baseURL, email, password, teamName, userId, token, errorCode, errorMessage, currentRoundId;

SYNTHESIZE_SINGLETON_FOR_CLASS(SUAPIInterface);

#pragma mark -
#pragma mark getters

-(NSString *) getSecret {
	NSLog(@"SKRT: %@", self.secret);
	if (self.secret == nil) {
		self.secret = [[[SUPrefInterface sharedSUPrefInterface] getDictionary:@"API"] objectForKey:@"secret"];
		NSLog(@"R--SKRT: %@", self.secret);
	}
	return self.secret;
}

-(NSString *) getBaseURL {
	NSLog(@"BSE: %@", self.baseURL);
	if (self.baseURL == nil) {	
		self.baseURL = [[[SUPrefInterface sharedSUPrefInterface] getDictionary:@"API"] objectForKey:@"baseURL"];
		NSLog(@"R--BSE: %@", self.baseURL);
	}
	return self.baseURL;
}

-(NSString *) token {
	if (token == nil) {
		// try to log them in again to refresh the token
		if ([self loginUserWithEmail:self.email password:self.password]) {
		} else {
			// Who knows?
		}
	} 
	
	return token;
		
}


#pragma mark -
#pragma mark static method

- (BOOL)responseHasError:(NSDictionary *)response {
	
	NSString *status = [response objectForKey:@"Status"];
	if ([status isEqualToString:@"ok"]) {
		// we don't have an error
		self.errorCode = nil;
		self.errorMessage = nil;
		return NO;
	} else {
		self.errorCode = [[response objectForKey:@"Error"] objectForKey:@"Code"];
		self.errorMessage = [[response objectForKey:@"Error"] objectForKey:@"Message"];
		return YES;
	}
}

- (NSDictionary *)makeRequest:(NSURL *)url {
	self.errorCode = nil;
	self.errorMessage = nil;	
	
	SBJSON *json = [[SBJSON new] autorelease];	
		
	NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url
												cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData
											timeoutInterval:20];
	// Fetch the JSON response
	NSData *urlData;
	NSURLResponse *response;
	NSError *error = nil;
	
	// Make synchronous request
	urlData = [NSURLConnection sendSynchronousRequest:urlRequest
									returningResponse:&response
												error:&error];
	
	NSString *body = [[[NSString alloc] initWithData:urlData encoding:NSUTF8StringEncoding] autorelease];
	
	NSDictionary *dict = [json objectWithString:body];
	
	
	if (error) {
		self.errorCode = @"999";
		self.errorMessage = [[SUPrefInterface sharedSUPrefInterface] getContentForKey:@"noNetConnection"];
		return nil;
	}
	
	
	if ([self responseHasError:dict]) {
		return nil;
	} else {
		return dict;
	}
}

- (NSString *)urlEncode:(NSString *)s {
	NSString *percentEscapedString = [s stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
	return percentEscapedString;
}


#pragma mark -
#pragma mark class instance methods

- (BOOL)loginUserWithEmail:(NSString *)e password:(NSString *)p {
		
    NSString *baseURLStr = [self getBaseURL];
    
	NSURL *url = [NSURL URLWithString:[NSString stringWithFormat: @"%@method=user.login&email=%@&password=%@&s=%@",  baseURLStr, e, p, [self getSecret]]];
    
	NSDictionary *result = [self makeRequest:url];

	if (result!=nil) {
		self.email = e;
		self.password = p;
		self.userId = (NSString *)[[result objectForKey:@"User"] objectForKey:@"Id"];
		self.teamName = (NSString *)[[result objectForKey:@"User"] objectForKey:@"TeamName"];
		self.token = (NSString *)[result objectForKey:@"Token"];
		return TRUE;
	} else {
		return FALSE;
	}
	
}

- (BOOL)registerUser:(NSString *)t email:(NSString *)e password:(NSString *)p {
	
	NSString *encodedTeamName = [self urlEncode:t];
	NSString *encodedEmail = [self urlEncode:e];
	NSString *encodedPassword = [self urlEncode:p];
	
	NSURL *url = [NSURL URLWithString:[NSString stringWithFormat: @"%@method=user.register&teamName=%@&email=%@&password=%@&s=%@",  [self getBaseURL], encodedTeamName, encodedEmail, encodedPassword, [self getSecret]]];	
	NSDictionary *result = [self makeRequest:url];
	
	if (result!=nil) {
		self.email = e;
		self.password = p;
		self.userId = (NSString *)[[result objectForKey:@"User"] objectForKey:@"Id"];
		self.teamName = (NSString *)[[result objectForKey:@"User"] objectForKey:@"TeamName"];
		self.token = (NSString *)[result objectForKey:@"Token"];
		return YES;
	} else { 
		return NO;
	}
	
}

- (BOOL)editUser:(NSString *)e password:(NSString *)p {
	
	NSString *encodedEmail = [self urlEncode:e];
	NSString *encodedPassword = [self urlEncode:p];
	
	NSURL *url = [NSURL URLWithString:[NSString stringWithFormat: @"%@method=user.edit&token=%@&email=%@&password=%@",  [self getBaseURL], self.token, encodedEmail, encodedPassword]];	
	NSDictionary *result = [self makeRequest:url];
	
	if (result!=nil) {
		self.email = e;
		self.password = p;
		return YES;
	} else {
		return NO;
	}
	
}



- (BOOL)addBanter:(NSString *)leagueId banter:(NSString *)banter {
	
	NSURL *url = [NSURL URLWithString:[NSString stringWithFormat: @"%@method=league.addBanter&token=%@&leagueId=%@&banter=%@",  
									   [self getBaseURL], 
									   self.token, 
									   leagueId, 
									   [self urlEncode:banter]]];	
	NSDictionary *result = [self makeRequest:url];
	
	if (result!=nil) {
		return YES;
	} else {
		return NO;
	}
	
}


- (BOOL)createLeague:(NSString *)n inviteOnly:(NSString *)io description:(NSString *)d {
	
	NSString *encodedName = [self urlEncode:n];
	NSString *encodedDescription = [self urlEncode:d];
	
	NSURL *url = [NSURL URLWithString:[NSString stringWithFormat: @"%@method=league.create&token=%@&name=%@&description=%@&type=%@",  [self getBaseURL], self.token, encodedName, encodedDescription, io]];	
	NSDictionary *result = [self makeRequest:url];
	
	if (result!=nil) {
		return YES;
	} else {
		return NO;
	}	
	
}

- (BOOL)sendInviteForLeague:(NSString *)leagueId email:(NSString *)emailAddress {
		

	NSLog(@"%@ : %@", leagueId, emailAddress);
	NSURL *url = [NSURL URLWithString:[NSString stringWithFormat: @"%@method=league.invite&token=%@&leagueid=%@&email=%@",  [self getBaseURL], self.token, leagueId, emailAddress]];	
	NSDictionary *result = [self makeRequest:url];
	
	if (result!=nil) {
		return YES;
	} else {
		return NO;
	}	
	
}

- (NSDictionary *)getUserDetails:(NSString *)uId {	
	
	NSURL *url = [NSURL URLWithString:[NSString stringWithFormat: @"%@method=user.details&userId=%@&token=%@",  [self getBaseURL], uId, self.token]];
	NSDictionary *user = [self makeRequest:url];
	
	NSLog(@"USER: %@", user);
	
	return user;
}
- (NSDictionary *)getLeaguesForUser:(NSString *)uId {
	
	
	NSLog(@"MY LEAGUES w/ UID: %@", uId);
	
	NSURL *url = [NSURL URLWithString:[NSString stringWithFormat: @"%@method=user.getLeagues&userId=%@&token=%@",  [self getBaseURL], uId, self.token]];

	NSLog(@"URL: %@", url);
	NSDictionary *leagues = [self makeRequest:url];
	
	NSLog(@"MY LEAGUES: %@", leagues);
	
	return leagues;
}

- (NSDictionary *)getLeague:(NSString *)l userId:(NSString *)u {	

	NSURL *url = [NSURL URLWithString:[NSString stringWithFormat: @"%@method=league.getDetails&token=%@&userId=%@&leagueId=%@",  [self getBaseURL], self.token, u, l]];
	NSDictionary *league = [self makeRequest:url];
	
	return league;
}

- (BOOL)editLeague:(NSString *)l name:(NSString *)n inviteOnly:(NSString *)io description:(NSString *)d {	
	
	NSString *newName = [self urlEncode:n];
	NSString *newDescription = [self urlEncode:d];
	NSURL *url = [NSURL URLWithString:[NSString stringWithFormat: @"%@method=league.edit&token=%@&leagueId=%@&type=%@&name=%@&description=%@",  [self getBaseURL], self.token, l, io, newName, newDescription]];
	NSDictionary *result = [self makeRequest:url];
	
	if (result != nil) {
		return YES;
	} else {
		return NO;
	}	
				  
}

- (BOOL)leaveLeague:(NSString *)leagueId {
	NSURL *url = [NSURL URLWithString:[NSString stringWithFormat: @"%@method=league.leave&token=%@&leagueId=%@",  [self getBaseURL], self.token, leagueId]];
	NSDictionary *result = [self makeRequest:url];
	
	if (result != nil) {
		return YES;
	} else {
		return NO;
	}
}

- (BOOL)joinLeague:(NSString *)leagueId {
	NSURL *url = [NSURL URLWithString:[NSString stringWithFormat: @"%@method=league.join&token=%@&leagueId=%@",  [self getBaseURL], self.token, leagueId]];
	NSDictionary *result = [self makeRequest:url];
	
	if (result != nil) {
		return YES;
	} else {
		return NO;
	}
}

- (NSDictionary *)getLatestMatches {	
	
	NSURL *url = [NSURL URLWithString:[NSString stringWithFormat: @"%@method=predictions.getLatestRound&token=%@",  [self getBaseURL], self.token]];
	NSDictionary *matches = [self makeRequest:url];
	
	//NSLog(@"MATCHES: %@", matches);
	
	return matches;
}
- (NSDictionary *)getMatchesForRound:(NSInteger)roundId {	
	
	NSURL *url = [NSURL URLWithString:[NSString stringWithFormat: @"%@method=predictions.getRound&roundId=%i&token=%@",  [self getBaseURL], roundId, self.token]];
	NSDictionary *matches = [self makeRequest:url];
	
	//NSLog(@"MATCHES: %@", matches);
	
	return matches;
}


- (NSDictionary *)getLeagues {	
	
	NSURL *url = [NSURL URLWithString:[NSString stringWithFormat: @"%@method=user.getLeagues&token=%@",  [self getBaseURL], token]];
	NSDictionary *leagues = [self makeRequest:url];
	
	return leagues;
}

- (NSDictionary *)getAllLeagues {	
	
	NSURL *url = [NSURL URLWithString:[NSString stringWithFormat: @"%@method=leagues.getAll&token=%@",  [self getBaseURL], token]];
	NSDictionary *leagues = [self makeRequest:url];
	
	return leagues;
}

- (NSDictionary *)getAllMessages {	
	// 50 messages hard-coded for now:
	NSURL *url = [NSURL URLWithString:[NSString stringWithFormat: @"%@method=user.getNextMessages&token=%@&index=1&length=%@",  
									   [self getBaseURL], 
									   token,
									   [[[SUPrefInterface sharedSUPrefInterface] getDictionary:@"API"] objectForKey:@"messageCount"]]];
	NSDictionary *reponse = [self makeRequest:url];
	
	return reponse;
}

// SETTERS

- (BOOL)updatePredictionMatchId:(NSString *)matchId homeTeam:(NSInteger)homeTeam awayTeam:(NSInteger)awayTeam banker:(BOOL)banker {
	
	NSURL *url = [NSURL URLWithString:[NSString stringWithFormat: @"%@method=prediction.update&token=%@&matchId=%@&homeTeam=%i&awayTeam=%i&banker=%@",  [self getBaseURL], token, matchId, homeTeam, awayTeam, banker ? @"true" : @"false"]];
	NSDictionary *package = [self makeRequest:url];
	
	if (package != nil) {
		return YES;
	} else {
		return NO;
	}

}




@end


