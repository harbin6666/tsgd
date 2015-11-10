//
//  Global.h
//  tsgd
//
//  Created by yuan jun on 15/1/15.
//  Copyright (c) 2015年 new. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef enum tar{
    kTs=0,
    kKd=1,
    kRw=2
} TargetType;
@interface Global : NSObject
AS_SINGLETON(Global)
@property (nonatomic, copy)NSString *loginedUserName,*userZhName;
@property (nonatomic, copy)NSString *userGroup;
@property (nonatomic, copy)NSString *userGroupId;
@property (nonatomic, assign)BOOL reject;//驳回权限
@property (nonatomic, strong)NSNumber *todoFreshTime;
@property (nonatomic, strong)NSString *userTelNum;
@property (nonatomic, strong)NSString *dept,*company;
@property (nonatomic,assign) TargetType targetType;
@end
