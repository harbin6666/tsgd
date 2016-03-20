//
//  GDService.m
//  gongdanApp
//
//  Created by 薛翔 on 14-2-26.
//  Copyright (c) 2014年 xuexiang. All rights reserved.
//

#import "GDService.h"
#import "MBProgressHUD.h"
#import <CommonCrypto/CommonDigest.h>
#import "ASIFormDataRequest.h"
#import "Global.h"

@implementation GDService

+ (void)requestWithFunctionName:(NSString*)functionName pramaDic:(NSMutableDictionary*)pramaDic requestMethod:(NSString*)method completion:(compBlock)completion{
    GDHttpRequest *req = [[GDHttpRequest alloc]initReqWithFunctionName:functionName pramaDic:pramaDic requestMethod:method completion:completion];
    req.delegate = req;
    
    [req startAsynchronous];
}

+ (void)requestWithFunctionName:(NSString*)functionName uploadData:(NSData*)uploadData completion:(compBlock)completion{
    
    NSString *urlStr = [host1 stringByAppendingString:[NSString stringWithFormat:@"%@/",functionName]];
    
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL: [NSURL URLWithString:urlStr]];
    [request setPostValue: @"MyName" forKey: @"name"];
    [request setData:uploadData withFileName:@"upload.png" andContentType:@"image/png/jpeg/jpg" forKey:@"clientSticker"];
    [request buildRequestHeaders];
    //request.delegate = self;
    NSLog(@"header: %@", request.requestHeaders);
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [request startSynchronous];
        NSLog(@"responseString = %@", request.responseString);
        if (completion) {
            __block NSRange range = [request.responseString rangeOfString:@"Sequenceid"];
            dispatch_async(dispatch_get_main_queue(), ^{
                if (range.location != NSNotFound) {
                    completion(@"成功",nil);
                }else{
                    completion(nil,request.error);
                }
            });
        }
    });
}


+(void)requestFunc:(NSString*)funName WithParam:(NSMutableDictionary*)param withCompletBlcok:(compBlock)block{

    [param setObject:@"2" forKey:@"PfType"];
    [param setObject:[[[UIDevice currentDevice] identifierForVendor] UUIDString] forKey:@"DeviceId"];

    if (GLOBALVALUE.targetType==kRw) {
        [param setObject:@"4" forKey:@"AppType"];
    }else if (GLOBALVALUE.targetType==kTs){
        [param setObject:@"2" forKey:@"AppType"];
    }else{
        [param setObject:@"3" forKey:@"AppType"];
    }
    if (GLOBALVALUE.loginedUserName!=nil) {
        [param setObject:GLOBALVALUE.loginedUserName forKey:@"UserId"];
    }
    
    NSString *ser=nil;
    NSString *fun=nil;
    if (GLOBALVALUE.targetType==kRw) {
        fun=@"mq_pass_6";
        ser=[NSString stringWithFormat:@"task_%@",funName];
    }else{
        fun=@"mq_pass_5";
        ser=[NSString stringWithFormat:@"cpt_%@",funName];
    }
    [param setObject:fun forKey:@"Function"];
    
    [param setObject:ser forKey:@"ServiceName"];
    ASIHTTPRequest *request=[[ASIHTTPRequest alloc] initWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@/",host1,fun]]];
    [request addRequestHeader:@"text/plain;charset=UTF-8 " value:@"Content-Type"];
    NSString *jsonStr;
    NSError *error=nil;
    NSData *jsonData=[NSJSONSerialization dataWithJSONObject:param options:0 error:&error];
    if (error==nil) {
        jsonStr=[[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
//    NSLog(@"request param  %@",jsonStr);
    //    NSMutableData *postData = [[NSMutableData alloc] init];
    //    [postData appendData:[jsonStr dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES]];
    
    request.postBody = jsonData.mutableCopy;
    request.delegate=self;
    request.requestMethod = @"POST";
    request.timeOutSeconds = 20;
    //    [request startAsynchronous];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [request startSynchronous];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if (request.error==nil) {
                NSData *jsonData=request.responseData;
                NSString *responseString=[[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
                //                NSLog(@"%@",responseString);
                responseString = [responseString stringByReplacingOccurrencesOfString : @"\r" withString : @"\\r" ];
                
                responseString = [responseString stringByReplacingOccurrencesOfString : @"\n" withString : @"\\n" ];
                
                responseString = [responseString stringByReplacingOccurrencesOfString : @"\t" withString : @"\\t" ];
                
                
                NSError *parseError=nil;
                id result=[NSJSONSerialization JSONObjectWithData:[responseString dataUsingEncoding:NSUTF8StringEncoding] options:kNilOptions error:&parseError];
                block(result,parseError);
                NSLog(@"url### \n%@ \nparam##\n %@ \n response\n## %@",request.url.absoluteString,jsonStr,result);
            }else{
                NSLog(@"url###\n %@\nparam## \n%@\n error##\n %@",request.url.absoluteString,jsonStr,request.error);

                block(nil,request.error);
                
            }
            
        });
    });
}

@end


@implementation GDHttpRequest
@synthesize comBlock = _comBlock;
- (id)initReqWithFunctionName:(NSString *)funcionName pramaDic:(NSMutableDictionary*)pramaDic requestMethod:(NSString*)method completion:(compBlock)completion{
    NSString *urlStr = [host1 stringByAppendingString:[NSString stringWithFormat:@"%@/",funcionName]];
    [self addRequestHeader:@"text/json" value:@"Content-Type"];
    if ([method isEqualToString:@"GET"] || method == nil) {
        urlStr = [urlStr stringByAppendingString:@"?7B"];
        int i = 1;
        for (NSString* key in pramaDic) {
            id value = [pramaDic objectForKey:key];
            if ([value isKindOfClass:[NSString class]]) {
                if ([key isEqualToString:@"Password"]) {
                    value = [[self md5:value] lowercaseString];
                }
                urlStr = [urlStr stringByAppendingString:[NSString stringWithFormat:@"\"%@\":\"%@\"",key, value]];
            }else{
                urlStr = [urlStr stringByAppendingString:[NSString stringWithFormat:@"\"%@\":%@",key, value]];
            }
            if (i < pramaDic.allKeys.count) {
                urlStr = [urlStr stringByAppendingString:@","];
            }
            i++;
        }
        urlStr = [urlStr stringByAppendingString:@"7D"];
        NSLog(@"the request url is:\n\n\n%@\n\n\n",urlStr);
        urlStr = [urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        
        self = [super initWithURL:[NSURL URLWithString:urlStr]];
        if (self) {
            self.functionName = funcionName;
            self.pramaDic = pramaDic;
            self.comBlock = completion;
            self.timeOutSeconds = 30;
        }
        return self;
    }else{
        NSString *bodyStr = @"{";
        int i = 1;
        for (NSString* key in pramaDic) {
            id value = [pramaDic objectForKey:key];
            if ([value isKindOfClass:[NSString class]]) {
                if ([key isEqualToString:@"Password"]) {
                    value = [[self md5:value] lowercaseString];
                }
                bodyStr = [bodyStr stringByAppendingString:[NSString stringWithFormat:@"\"%@\":\"%@\"",key, value]];
            }else{
                bodyStr = [bodyStr stringByAppendingString:[NSString stringWithFormat:@"\"%@\":%@",key, value]];
            }
            if (i < pramaDic.allKeys.count) {
                bodyStr = [bodyStr stringByAppendingString:@","];
            }
            i++;
        }
        bodyStr = [bodyStr stringByAppendingString:@"}"];
        NSLog(@"the HOST is:\n\n\n%@\n\n\nbody is :\n\n\n%@\n\n\n",urlStr,bodyStr);
        
        self = [super initWithURL:[NSURL URLWithString:urlStr]];
        if (self) {
            NSMutableData *postData = [[NSMutableData alloc] init];
            [postData appendData:[bodyStr dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES]];
            self.postBody = postData;
            self.requestMethod = @"POST";
            self.functionName = funcionName;
            self.pramaDic = pramaDic;
            self.comBlock = completion;
            self.timeOutSeconds = 30;
        }
        return self;
    }
    

}
- (NSString *)md5:(NSString *)str
{
    const char *cStr = [str UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(cStr, strlen(cStr), result); // This is the md5 call
    return [NSString stringWithFormat:
            @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
            result[0], result[1], result[2], result[3],
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]
            ]; 
}

- (void)requestFinished:(ASIHTTPRequest *)arequest {
    
    __block NSData *aJsonData = [[NSData alloc] initWithData:[arequest responseData]];
    

    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSError *aerror = nil;
        id jsonObj = [NSJSONSerialization JSONObjectWithData:aJsonData options:kNilOptions error:&aerror];
        NSLog(@"the functionName is:\n   %@\n jsonData is: \n   %@",self.functionName,jsonObj);
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if (self.comBlock) {
                self.comBlock(jsonObj,aerror);
            }
        });
    });
}
- (void)requestFailed:(ASIHTTPRequest *)aRequest {
    NSLog(@"请求失败");
    //[MBProgressHUD hideHUDForView:SharedDelegate.tabbarController.selectedViewController.view animated:YES];
    if (self.comBlock) {
        self.comBlock(nil,aRequest.error);
    }
    if (aRequest.error.code == 2) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"网络超时" message:@"请稍候再试" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
    }
}

@end