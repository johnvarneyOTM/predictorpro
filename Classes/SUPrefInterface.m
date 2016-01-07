//
//  SUPrefInterface.m
//  PredictorPro
//
//  Created by Oliver Relph on 18/07/2010.
//  Copyright 2010 Sumac. All rights reserved.
//

#import "SUPrefInterface.h"


@implementation SUPrefInterface

SYNTHESIZE_SINGLETON_FOR_CLASS(SUPrefInterface);


- (id)readPlist:(NSString *)fileName {
	NSData *plistData;
	NSString *error;
	NSPropertyListFormat format;
	id plist;
	
	NSString *localizedPath = [[NSBundle mainBundle] pathForResource:fileName ofType:@"plist"];
	plistData = [NSData dataWithContentsOfFile:localizedPath];
	
	plist = [NSPropertyListSerialization propertyListFromData:plistData mutabilityOption:NSPropertyListImmutable format:&format errorDescription:&error];
	if (!plist) {
		NSLog(@"Error reading plist from file '%s', error = '%s'", [localizedPath UTF8String], [error UTF8String]);
		[error release];
	}
	
	return plist;
}

- (NSArray *)getArray:(NSString *)fileName {
	return (NSArray *)[self readPlist:fileName];
}

- (NSDictionary *)getDictionary:(NSString *)fileName {
	return (NSDictionary *)[self readPlist:fileName];
}

- (id)getContentForKey:(NSString *)key {
	NSDictionary *pl = [self readPlist:@"Content"];
	return [pl objectForKey:key];
}

- (void)writePlist:(id)plist fileName:(NSString *)fileName {
	NSData *xmlData;
	NSString *error;
	
	NSString *localizedPath = [[NSBundle mainBundle] pathForResource:fileName ofType:@"plist"];
	xmlData = [NSPropertyListSerialization dataFromPropertyList:plist format:NSPropertyListXMLFormat_v1_0 errorDescription:&error];
	if (xmlData) {
		[xmlData writeToFile:localizedPath atomically:YES];
	} else {
		NSLog(@"Error writing plist to file '%s', error = '%s'", [localizedPath UTF8String], [error UTF8String]);
		[error release];
	}
}

@end
