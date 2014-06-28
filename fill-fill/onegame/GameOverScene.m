//
//  GameOverScene.m
//  onegame
//
//  Created by Chenyun on 14-2-10.
//  Copyright (c) 2014年 riadev. All rights reserved.
//

#import "GameOverScene.h"
#import "MyScene.h"
#import "GetData.h"
@implementation GameOverScene
-(id)initWithSize:(CGSize)size won:(BOOL)won {
    if (self = [super initWithSize:size]) {
        self.backgroundColor = [SKColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0];
//        SKLabelNode *label = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
//        label.text = @"Game Over";
//        label.fontSize = 40;
//        label.fontColor = [SKColor blackColor];
//        label.position = CGPointMake(self.size.width/2, self.size.height/2+70);
//        [self addChild:label];
        SKLabelNode *label2 = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
        label2.text = @"Start Game";
        label2.fontSize = 40;
        label2.name = @"Start Game";
        label2.fontColor = [SKColor blackColor];
        label2.position = CGPointMake(self.size.width/2, self.size.height/2-70);
        [self addChild:label2];
        
        
        SKLabelNode *currents = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
        currents.text = @"得分:";
        currents.fontSize = 20;
        currents.fontColor = [SKColor blackColor];
        currents.position = CGPointMake(self.size.width/2-100, self.size.height/2+60);
        [self addChild:currents];
        
        SKLabelNode *Highests = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
        Highests.text = @"最高分:";
        Highests.fontSize = 20;
        Highests.fontColor = [SKColor blackColor];
        Highests.position = CGPointMake(self.size.width/2-100, self.size.height/2);
        [self addChild:Highests];
        
        GetData* da = [GetData sharedInstance];
        SKLabelNode *current = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
        current.text = da.currentsocke;
        current.fontSize = 20;
        current.fontColor = [SKColor blackColor];
        current.position = CGPointMake(self.size.width/2+100, self.size.height/2+60);
        [self addChild:current];
        
        NSUserDefaults* userdefault = [NSUserDefaults standardUserDefaults];
        SKLabelNode *Highest = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
        NSString* str = [NSString stringWithFormat:@"%d",[userdefault integerForKey:@"Highestsocke"]];
        int i = [str intValue];
        str = [NSString stringWithFormat:@"%d",i];
        Highest.text = str;
        Highest.fontSize = 20;
        Highest.fontColor = [SKColor blackColor];
        Highest.position = CGPointMake(self.size.width/2+100, self.size.height/2);
        [self addChild:Highest];
    }
    return self;
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    for (UITouch *touch in touches) {
        CGPoint touchLocation = [touch locationInNode:self];
        SKNode *node = [self nodeAtPoint:touchLocation];
        if ([node.name isEqualToString:@"Start Game"]) {
            SKTransition *reveal = [SKTransition flipHorizontalWithDuration:0.5];
            SKScene * myScene = [[MyScene alloc] initWithSize:self.size];
            [self.view presentScene:myScene transition: reveal];
        }
    }
}
@end
