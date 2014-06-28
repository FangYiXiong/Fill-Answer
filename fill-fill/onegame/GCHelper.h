//
//  GCHelper.h
//  Fill answer
//
//  Created by Chenyun on 14-6-28.
//  Copyright (c) 2014年 riadev. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GameKit/GameKit.h>

@interface GCHelper : NSObject
{
	BOOL gameCenterAvailable;
	BOOL userAuthenticated;
}

@property (assign,readonly) BOOL gameCenterAvailable;

+ (GCHelper *)sharedInstance;
- (void)authenticateLocalUser;

- (void) reportScore: (int64_t) score forCategory: (NSString*) category;

- (void) retrieveTopTenScores;

@end
