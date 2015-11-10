//
//  GDBasedVC.h
//  gongdanApp
//
//  Created by 薛翔 on 14-2-21.
//  Copyright (c) 2014年 xuexiang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GDService.h"
#import "NSString+Base64Decode.h"
#import "GDListPageOperationView.h"
#import "Global.h"
#import "GDService.h"
#import "GDCommonRootTVC.h"
#define SelfViewWidth self.view.frame.size.width
#define SelfViewHeight self.view.frame.size.height
#define TEXTFONT [UIFont systemFontOfSize:14]
@interface GDBasedVC : UIViewController

@property(nonatomic, strong)NSMutableArray *dataArr;
@property(nonatomic, strong)NSNumber *currentPage;
@property(nonatomic, strong)NSNumber *totalPage;

@property(nonatomic, strong)NSString *startDate;
@property(nonatomic, strong)NSString *endDate;

@property(nonatomic)int currentPageIndex;

/**
 *  功能:左按钮点击行为，可在子类重写此方法
 */
- (void)leftBtnClicked:(id)sender;

/**
 *  功能:右按钮点击行为，可在子类重写此方法
 */
- (void)rightBtnClicked:(id)sender;

- (void)setLeftBtnImage:(UIImage*)image highLightImage:(UIImage*)hImage;
- (void)setRightBtnImage:(UIImage*)image highLightImage:(UIImage*)hImage;
- (void)showLoading;
- (void)hideLoading;
- (NSString*)dateToNSString:(NSDate*)date;
@end

@interface NSMutableDictionary (GD)
- (void)setSafeObject:(id)anObject forKey:(id<NSCopying>)aKey;
@end

@interface NSArray (GD)
- (id)safeObjectAtIndex:(NSUInteger)index;
@end

@interface NSMutableArray (GD)
- (id)safeObjectAtIndex:(NSUInteger)index;
@end

@interface NSString (GD)
-(BOOL)isEmptyStr;
@end

@interface GDTextView:UITextView
@end
@interface GDNameLab : UILabel
@end
@interface GDInputTextView : UITextView

@end
@interface GDTextField : UITextField

@end

typedef void(^HandleBlock)(id sender,UIButton*yuyin);
typedef enum {
    kBtn=0,
    kTextView=1,
    kTextFeild=2,
    k2Btn=3
}HandleType;
@interface HandleView : UIView
-(id)initWithType:(HandleType)handleType key:(NSString*)left Value:(NSString*)right tag:(NSInteger)tag block:(HandleBlock)block;
@end
