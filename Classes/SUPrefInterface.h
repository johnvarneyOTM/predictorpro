//
//  SUPrefInterface.h
//  PredictorPro
//
//  Created by Oliver Relph on 18/07/2010.
//  Copyright 2010 Sumac. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SynthesizeSingleton.h"


@interface SUPrefInterface : NSObject {

}

+ (SUPrefInterface *)sharedSUPrefInterface;

- (NSArray *)getArray:(NSString *)fileName;
- (NSDictionary *)getDictionary:(NSString *)fileName;
- (void)writePlist:(id)plist fileName:(NSString *)fileName;
- (id)getContentForKey:(NSString *)key;
- (id)readPlist:(NSString *)fileName;
@end
