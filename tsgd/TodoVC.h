//
//  TodoVC.h
//  tsgd
//
//  Created by yuan jun on 15/1/15.
//  Copyright (c) 2015年 new. All rights reserved.
//

#import "GDBasedVC.h"

@interface TodoVC : GDBasedVC
@property(nonatomic, strong)NSDictionary *searchParam;
- (void)getData;
@end
