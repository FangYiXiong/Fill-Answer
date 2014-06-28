//
//  MyScene.m
//  onegame
//
//  Created by Chenyun on 14-2-10.
//  Copyright (c) 2014年 riadev. All rights reserved.
//

#import "MyScene.h"
#import "GetData.h"
#import "GameOverScene.h"
#import "GCHelper.h"

@interface MyScene () <SKPhysicsContactDelegate>
@property (nonatomic) SKSpriteNode* player;
@property (nonatomic) NSTimeInterval lastSpawnTimeInterval;
@property (nonatomic) NSTimeInterval lastUpdateTimeInterval;
@property (nonatomic) int monstersDestroyed;
@property (nonatomic)SKLabelNode *myLabel;
@property (strong,nonatomic)NSMutableArray* monsters;
@property (strong,nonatomic)NSDictionary* shuxuetihedaan;
@property (strong,nonatomic)NSArray* shuxueti;
@property (strong,nonatomic)NSTimer* timeone;
@end


@implementation MyScene
-(id)initWithSize:(CGSize)size {
    if (self = [super initWithSize:size]) {
        GetData* da = [GetData sharedInstance];
        da.currentsocke =@"0";
        /* Setup your scene here */
        self.monsters = [NSMutableArray array];
        self.shuxueti = [NSArray array];
        self.backgroundColor = [SKColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0];
        self.physicsWorld.gravity = CGVectorMake(0,0);
        self.physicsWorld.contactDelegate = self;
        //分数
        self.myLabel = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
        self.myLabel.text = @"0";
        self.myLabel.fontSize = 20;
        self.myLabel.fontColor = [SKColor colorWithRed:15/255.0 green:15/255.0 blue:15/255.0 alpha:1.0];
        self.myLabel.position = CGPointMake(CGRectGetMidX(self.frame),280);
        [self addChild:self.myLabel];
        
        //键盘
        for (int i =0; i<10; i++) {
            NSString* str = [NSString stringWithFormat:@"_%d_",i];
            SKLabelNode* select = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
            select.text = str;
            select.name = str;
            select.fontSize = 20;
            select.fontColor = [SKColor colorWithRed:15/255.0 green:15/255.0 blue:15/255.0 alpha:1.0];
            select.position = CGPointMake((self.frame.size.width/10-20+i*(self.frame.size.width/10)-20)+15,10);
            [self addChild:select];
        }
        self.shuxuetihedaan = @{@"1+1": @"_2_",
                                @"2+2":@"_4_",
                                @"0+1":@"_1_",
                                @"3*3":@"_9_",
                                @"NSlog(@“9”)":@"_9_",
                                @"7%3":@"_1_",
                                @"根号4":@"_2_",
                                @"√9":@"_3_",
                                @"0/2":@"_0_",
                                @"4x=24":@"_6_",
                                @"死":@"_4_",
                                @"1 3 x 7":@"_5_",
                                @"3+3":@"_6_",
                                @"int i=7.3;i=?":@"_7_",
                                @"int i=8.2;i=?;":@"_8_",
                                @"7-1+2":@"_8_",
                                @"1*1*1":@"_1_",
                                @"4/2*3":@"_6_"
                                };
        self.shuxueti = [self.shuxuetihedaan allKeys];
    }
    return self;
}
//设置怪物
-(void)addMonster{
    //创建怪物
    SKLabelNode* monster = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
    int timu = arc4random()%self.shuxueti.count;
    monster.text = self.shuxueti[timu];
    monster.fontSize = 20;
    monster.fontColor = [SKColor colorWithRed:15/255.0 green:15/255.0 blue:15/255.0 alpha:1.0];
    //决定怪物在屏幕上出现的位置
    int minY = monster.frame.size.height /2+10;
    int maxY = self.frame.size.height - monster.frame.size.height / 2-10;
    int rangeY = maxY-minY;
    int actualY = (arc4random()%rangeY) +minY;
//    monster.position = CGPointMake(self.frame.size.width + monster.frame.size.width/2, actualY);
    monster.position = CGPointMake(-monster.frame.size.width/2, actualY);
    [self addChild:monster];
    [self.monsters addObject:monster];
    //设置怪物的速度
    int minDuration = 2.0;
    int maxDuration = 4.0;
    int rangeDuration = maxDuration - minDuration;
    int actualDuration = (arc4random() % rangeDuration) + minDuration;
//    SKAction* actionMove = [SKAction moveTo:CGPointMake(-monster.frame.size.width/2, actualY) duration:actualDuration];
    SKAction* actionMove = [SKAction moveTo:CGPointMake(self.frame.size.width + monster.frame.size.width/2, actualY) duration:actualDuration];
    SKAction* actionMoveDone = [SKAction removeFromParent];;
    SKAction * loseAction = [SKAction runBlock:^{
        SKTransition *reveal = [SKTransition flipHorizontalWithDuration:0.5];
        SKScene * gameOverScene = [[GameOverScene alloc] initWithSize:self.size won:NO];
        [self.view presentScene:gameOverScene transition: reveal];
    }];
    [monster runAction:[SKAction sequence:@[actionMove, loseAction, actionMoveDone]]];
}
- (void)updateWithTimeSinceLastUpdate:(CFTimeInterval)timeSinceLast {
    self.lastSpawnTimeInterval += timeSinceLast;
    if (self.lastSpawnTimeInterval > 1) {
        self.lastSpawnTimeInterval=0;
        [self addMonster];
    }
}
- (void)update:(NSTimeInterval)currentTime {
    // 获取时间增量
    // 如果我们运行的每秒帧数低于60，我们依然希望一切和每秒60帧移动的位移相同
    CFTimeInterval timeSinceLast = currentTime - self.lastUpdateTimeInterval;
    self.lastUpdateTimeInterval = currentTime;

    if (timeSinceLast > 1) {
        timeSinceLast = 1.0 / 60.0;
        self.lastUpdateTimeInterval = currentTime;
    }
    [self updateWithTimeSinceLastUpdate:timeSinceLast];
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
	
    for (UITouch *touch in touches) {
        CGPoint touchLocation = [touch locationInNode:self];
        SKNode *node = [self nodeAtPoint:touchLocation];
        NSMutableArray* montesToDelete = [[NSMutableArray alloc]init];

        for (SKLabelNode* label in self.monsters) {
            if ([node.name isEqualToString:[self.shuxuetihedaan objectForKey:label.text]]) {
                [montesToDelete addObject:label];
            }
        }
		
		GetData* da;
		
        for (SKLabelNode* labe in montesToDelete)
		{
			
            [self.monsters removeObject:labe];
            [labe removeFromParent];
			
            NSString* str = self.myLabel.text;
            int i = [str intValue];
            i = i+1;
            str = [NSString stringWithFormat:@"%d",i];
            self.myLabel.text = str;
			
            da = [GetData sharedInstance];
            da.currentsocke = self.myLabel.text;
			
            NSUserDefaults* userdefault = [NSUserDefaults standardUserDefaults];
			
			NSInteger highestsock = [[userdefault objectForKey:@"Highestsocke"] integerValue];
			
            if (highestsock < [self.myLabel.text intValue])
			{
				[userdefault setObject:self.myLabel.text forKey:@"Highestsocke"];
				[[GCHelper sharedInstance] reportScore:[self.myLabel.text intValue] forCategory:@"fenshu"];
            }

        }

		if ( da.currentsocke == nil && node.name && node.name.length )
		{
			SKTransition *reveal = [SKTransition flipHorizontalWithDuration:0.5];
			SKScene * gameOverScene = [[GameOverScene alloc] initWithSize:self.size won:NO];
			[self.view presentScene:gameOverScene transition: reveal];
		}
    }
}
@end
