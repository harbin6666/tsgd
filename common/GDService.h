//
//  GDService.h
//  gongdanApp
//
//  Created by 薛翔 on 14-2-26.
//  Copyright (c) 2014年 xuexiang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ASIHTTPRequest.h"

//typedef void(^comp)(id reObj);
typedef void(^compBlock)(id reObj,NSError* error);

@interface GDService : NSObject
@property(nonatomic, strong)NSMutableDictionary *pramaDic;
+ (void)requestWithFunctionName:(NSString*)functionName pramaDic:(NSMutableDictionary*)pramaDic requestMethod:(NSString*)method completion:(compBlock)completion;

+ (void)requestWithFunctionName:(NSString*)functionName uploadData:(NSData*)uploadData completion:(compBlock)completion;



+(void)requestFunc:(NSString*)funName WithParam:(NSMutableDictionary*)param withCompletBlcok:(compBlock)block;

@end




@interface GDHttpRequest : ASIHTTPRequest
@property(nonatomic, strong)NSString *functionName;
@property(nonatomic, strong)NSMutableDictionary* pramaDic;
@property(nonatomic, copy)compBlock comBlock;
- (id)initReqWithFunctionName:(NSString *)funcionName pramaDic:(NSMutableDictionary*)pramaDic requestMethod:(NSString*)method completion:(compBlock)completion;
@end