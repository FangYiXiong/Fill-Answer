//
//  GetData.m
//  Fill answer
//
//  Created by Chenyun on 14-2-13.
//  Copyright (c) 2014年 riadev. All rights reserved.
//

#import "GetData.h"

@implementation GetData
static GetData * getInstance;
+ (id) sharedInstance {
    @synchronized ([GetData class]) {
        if (getInstance == nil) {
            getInstance = [[GetData alloc] init];
        }
    }
    return getInstance;
}
@end
