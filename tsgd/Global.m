//
//  Global.m
//  tsgd
//
//  Created by yuan jun on 15/1/15.
//  Copyright (c) 2015年 new. All rights reserved.
//

#import "Global.h"

@implementation Global
DEF_SINGLETON(Global)
-(id)init{
    self=[super init];
    if (self) {
        NSLog(@"%@",[NSBundle mainBundle].bundleIdentifier);
        if ([[NSBundle mainBundle].bundleIdentifier isEqualToString:@"inspur.tsgd"]) {
            self.targetType=kTs;
        }else if ([[NSBundle mainBundle].bundleIdentifier isEqualToString:@"inspur.kdts"]){
            self.targetType=kKd;
        }else if ([[NSBundle mainBundle].bundleIdentifier isEqualToString:@"inspur.rwgd"]){
            self.targetType=kRw;
        }
    }
    return self;
}
@end
