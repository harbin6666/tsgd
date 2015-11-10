//
//  GDInfoVC.h
//  tsgd
//
//  Created by yuan jun on 15/1/15.
//  Copyright (c) 2015年 new. All rights reserved.
//

#import "GDBasedVC.h"
typedef enum _FormState {
    FormState_todo = 2,//未受理理
    FormState_doing = 3,//已受理
    FormState_done = 4//已办功能
}FormState;

@interface GDInfoVC : GDBasedVC

@property(nonatomic,strong)NSDictionary *queryObj;
@property(nonatomic,assign)BOOL isTodo;
@end
