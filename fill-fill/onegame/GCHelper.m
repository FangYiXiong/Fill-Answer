//
//  GCHelper.m
//  Fill answer
//
//  Created by Chenyun on 14-6-28.
//  Copyright (c) 2014年 riadev. All rights reserved.
//

#import "GCHelper.h"

static GCHelper * shareHelper = nil;

@implementation GCHelper

+ (GCHelper *)sharedInstance
{
	@synchronized(self)
	{
		if ( !shareHelper )
		{
			shareHelper = [[GCHelper alloc] init];
		}
	}
	return shareHelper;
}

- (BOOL)isGameCenterAvailable
{
	Class gcClass = (NSClassFromString(@"GKLocalPlayer"));
	
	NSString * reqSysVer = @"4.1";
	NSString *currSysVer = [[UIDevice currentDevice] systemVersion];
	BOOL osVersionSupported = ([currSysVer compare:reqSysVer
										   options:NSNumericSearch] != NSOrderedAscending);
	
	return (gcClass && osVersionSupported);
}

- (id)init
{
	if ( self = [super init] )
	{
		gameCenterAvailable = [self isGameCenterAvailable];
		if ( gameCenterAvailable )
		{
			NSLog(@"支持游戏中心");
			NSNotificationCenter * nc = [NSNotificationCenter defaultCenter];
			[nc addObserver:self selector:@selector(authenticationChanged) name:GKPlayerAuthenticationDidChangeNotificationName object:nil];
		}
	}
	return self;
}

- (void)authenticationChanged
{
	if ( [GKLocalPlayer localPlayer].isAuthenticated && !userAuthenticated )
	{
		userAuthenticated = TRUE;
		NSLog(@"通过检测");
	}
	else if (![GKLocalPlayer localPlayer].isAuthenticated && userAuthenticated)
	{
		userAuthenticated = FALSE;
		NSLog(@"未通过检测");
	}
}

- (void)authenticateLocalUser
{
	if ( !gameCenterAvailable ) return;
	
	if ( [GKLocalPlayer localPlayer].authenticated == NO )
	{
		[[GKLocalPlayer localPlayer] authenticateWithCompletionHandler:nil];
	}
}

// 上传一个分数
- (void) reportScore: (int64_t) score forCategory: (NSString*) category
{
	 GKScore *scoreReporter = [[GKScore alloc] initWithCategory:category];
	 scoreReporter.value = score;
	 
	[scoreReporter reportScoreWithCompletionHandler:^(NSError *error) {
		
		
		if (error != nil)
		{
			// handle the reporting error
			NSLog(@"上传分数出错.");
			//If your application receives a network error, you should not discard the score.
			//Instead, store the score object and attempt to report the player’s process at
			//a later time.
		}
		else
		{
			NSLog(@"上传分数成功");
		}
	}];
}

- (void) retrieveTopTenScores
{
	GKLeaderboard *leaderboardRequest = [[GKLeaderboard alloc] init];
	if (leaderboardRequest != nil)
	{
		leaderboardRequest.playerScope = GKLeaderboardPlayerScopeGlobal;
		leaderboardRequest.timeScope = GKLeaderboardTimeScopeAllTime;
		leaderboardRequest.range = NSMakeRange(1,10);
		leaderboardRequest.category = @"fenshu";
		[leaderboardRequest loadScoresWithCompletionHandler: ^(NSArray *scores, NSError *error) {
			if (error != nil)
			{
				// handle the error.
				NSLog(@"下载失败");
			}
			if (scores != nil)
			{
				// process the score information.
				NSLog(@"下载成功....");
				NSArray *tempScore = [NSArray arrayWithArray:leaderboardRequest.scores];
			
			
			
			}
		}];
	}
}

@end
