//
//  GDBasedVC.m
//  gongdanApp
//
//  Created by 薛翔 on 14-2-21.
//  Copyright (c) 2014年 xuexiang. All rights reserved.
//

#import "GDBasedVC.h"
#import "AppDelegate.h"
#import "MBProgressHUD.h"
#define TextBoxBorder [UIColor colorWithRed:108.0/255 green:208.0/255 blue:223.0/255 alpha:1.0]
@implementation HandleView
-(id)initWithType:(HandleType)type
              key:(NSString*)left
            Value:(NSString*)right
              tag:(NSInteger)tag
            block:(HandleBlock)block{
    self=[super init];
    self.backgroundColor=[UIColor clearColor];
    CGSize  size = [left sizeWithFont:TEXTFONT constrainedToSize:CGSizeMake(90, 2000)];

    UILabel *lab=[[UILabel alloc] initWithFrame:CGRectMake(10, 0, 90, size.height)];
    lab.backgroundColor=[UIColor clearColor];
    lab.numberOfLines=2;
    lab.font=TEXTFONT;
    lab.text=[NSString stringWithFormat:@"%@:",left];
    [self addSubview:lab];
    if (type==kBtn) {
        UIButton*but=[UIButton buttonWithType:UIButtonTypeCustom];
        [but setBackgroundImage:[UIImage imageNamed:@"equitFrame"] forState:UIControlStateNormal];
        but.tag=tag;
        if (right==nil) {
            right=@"请选择";
        }
        [but setTitle:right forState:UIControlStateNormal];
        [but setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        but.titleLabel.font=TEXTFONT;
        but.titleLabel.numberOfLines=0;
        but.frame=CGRectMake(100, 0, SharedDelegate.window.frame.size.width-100-30, 30);
        [self addSubview:but];
        
        float h=size.height;
        if (30>size.height) {
            h=30;
        }
        self.frame=CGRectMake(0, self.frame.origin.y, SharedDelegate.window.frame.size.width, h);
        block(but,nil);
    }else if (type==kTextFeild){
        GDTextField*handlerTF = [[GDTextField alloc]initWithFrame:CGRectMake(100, 0, SharedDelegate.window.frame.size.width-100-30, 30)];
        handlerTF.backgroundColor = [UIColor clearColor];
        handlerTF.layer.borderColor=TextBoxBorder.CGColor;
        handlerTF.layer.borderWidth=1.0f;
        handlerTF.font = TEXTFONT;
        handlerTF.text = right;
        handlerTF.tag=tag;
        [self addSubview:handlerTF];
        float h=size.height;
        if (30>size.height) {
            h=30;
        }
        self.frame=CGRectMake(0, self.frame.origin.y, SharedDelegate.window.frame.size.width, h);
        block(handlerTF,nil);
    }else if (type==kTextView){
        GDInputTextView*tv = [[GDInputTextView alloc]initWithFrame:CGRectMake(100, 0, SharedDelegate.window.frame.size.width-100-30, 50)];
        tv.layer.borderColor=TextBoxBorder.CGColor;
        tv.layer.borderWidth=1.0f;
        tv.text = right;
        tv.tag = tag;
        tv.font = TEXTFONT;
        tv.backgroundColor = [UIColor clearColor];
        [self addSubview:tv];
        
        UIButton *yuyin=[UIButton buttonWithType:UIButtonTypeCustom];
        yuyin.tag=tag;
        [yuyin setBackgroundImage:[UIImage imageNamed:@"yuyin"] forState:UIControlStateNormal];
        yuyin.frame=CGRectMake(SharedDelegate.window.frame.size.width-30, 0, 15, 24);
        [self addSubview:yuyin];
        self.frame=CGRectMake(0, self.frame.origin.y, SharedDelegate.window.frame.size.width, 50);

        block(tv,yuyin);

    }
    return self;
}
@end
@implementation GDTextField

-(id)initWithFrame:(CGRect)frame{
    if (self=[super initWithFrame:frame]) {
        
    }
    return self;
}

@end
@implementation GDInputTextView
-(id)initWithFrame:(CGRect)frame{
    if (self=[super initWithFrame:frame]) {
        
    }
    return self;
}

@end

@implementation GDTextView
-(id)initWithFrame:(CGRect)frame{
    self=[super initWithFrame:frame];
    if (self) {
        self.contentInset=UIEdgeInsetsZero;
        self.textContainer.lineFragmentPadding=0;
        self.textContainerInset=UIEdgeInsetsZero;
        self.editable=NO;
        self.scrollEnabled=NO;
        self.font=TEXTFONT;
        self.textColor=[UIColor blackColor];
        self.backgroundColor=[UIColor clearColor];
    }
    return self;
}
/* 选中文字后是否能够呼出菜单 */
- (BOOL)canBecameFirstResponder {
    return YES;
}

/* 选中文字后的菜单响应的选项 */
- (BOOL)canPerformAction:(SEL)action withSender:(id)sender {
    if (action == @selector(copy:)) {
        return YES;
    }
    
    return NO;
}
@end
@implementation GDNameLab
-(id)initWithFrame:(CGRect)frame{
    self=[super initWithFrame:frame];
    if (self) {
        self.textColor=[UIColor blackColor];
        self.backgroundColor=[UIColor clearColor];
        self.font=TEXTFONT;
        self.numberOfLines=2;
    }
    return self;
}
@end

@implementation NSMutableDictionary (GD)

- (void)setSafeObject:(id)anObject forKey:(id<NSCopying>)aKey {
    if (anObject == nil) {
        anObject = @"";
    }
    [self setObject:anObject forKey:aKey];
}
@end

@implementation NSMutableArray (GD)

- (id)safeObjectAtIndex:(NSUInteger)index {
    if (self.count > index ) {
        return [self objectAtIndex:index];
    }else{
        return nil;
    }
}
@end

@implementation NSArray (GD)

- (id)safeObjectAtIndex:(NSUInteger)index {
    if (self.count > index ) {
        return [self objectAtIndex:index];
    }else{
        return nil;
    }
}

@end
@implementation NSString (GD)

-(BOOL)isEmptyStr{
    if ([self isEqualToString:@""]) {
        return YES;
    }
    return NO;
}

@end

@interface GDBasedVC ()
@property(nonatomic, strong)UIButton *rightButton;
@property(nonatomic, strong)UIButton *leftButton;
@end

@implementation GDBasedVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 70000
        if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)
        {
            self.edgesForExtendedLayout = UIRectEdgeNone;
            self.extendedLayoutIncludesOpaqueBars = NO;
            self.modalPresentationCapturesStatusBarAppearance = NO;
        }
#endif
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:self.leftButton];
        UILabel *lab=[[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 40)];
        lab.textColor=[UIColor whiteColor];
        lab.font=[UIFont boldSystemFontOfSize:20];
        lab.textAlignment=NSTextAlignmentCenter;
        NSString *t=@"";
        if (GLOBALVALUE.targetType==kTs) {
            t=@"投诉工单处理";
        }else if (GLOBALVALUE.targetType==kRw){
            t=@"任务工单处理";
        }else if (GLOBALVALUE.targetType==kKd){
            t=@"宽带投诉处理";
        }
        lab.text=t;
        self.navigationItem.titleView=lab;
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd hh:mm:ss"];
        self.startDate = [dateFormatter stringFromDate:[NSDate dateWithTimeIntervalSinceNow:-8*60*60]];
        self.endDate = [dateFormatter stringFromDate:[NSDate date]];

    }
    return self;
}
- (void)setLeftBtnImage:(UIImage*)image highLightImage:(UIImage*)hImage{
    //获取需要改变样式的按钮
    UIButton *theButton;
    if (self.navigationItem.leftBarButtonItem == nil) {
        UIBarButtonItem *btnItem = [[UIBarButtonItem alloc] initWithCustomView:self.leftButton];
        self.navigationItem.leftBarButtonItem = btnItem;
    }
    theButton = (UIButton *)self.navigationItem.leftBarButtonItem.customView;
    [theButton setBackgroundImage:image forState:UIControlStateNormal];
    [theButton setBackgroundImage:hImage forState:UIControlStateHighlighted];
}
- (void)setRightBtnImage:(UIImage*)image highLightImage:(UIImage*)hImage{
    UIButton *theButton;
    if (self.navigationItem.rightBarButtonItem == nil) {
        UIBarButtonItem *btnItem = [[UIBarButtonItem alloc] initWithCustomView:self.rightButton];
        self.navigationItem.rightBarButtonItem = btnItem;
    }
    theButton = (UIButton *)self.navigationItem.rightBarButtonItem.customView;
    [theButton setBackgroundImage:image forState:UIControlStateNormal];
    [theButton setBackgroundImage:hImage forState:UIControlStateHighlighted];
}
- (UIButton *)leftButton
{
	if (_leftButton == nil) {
		_leftButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 13, 22)];
		[_leftButton setBackgroundImage:[UIImage imageNamed:@"backBtn"] forState:UIControlStateNormal];
		[_leftButton setBackgroundImage:[UIImage imageNamed:@"backBtn"] forState:UIControlStateHighlighted];
		[_leftButton addTarget:self action:@selector(leftBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
	}
	return _leftButton;
}

- (UIButton *)rightButton
{
	if (_rightButton == nil) {
		_rightButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
		[_rightButton setBackgroundImage:[UIImage imageNamed:@"title_left_btn"] forState:UIControlStateNormal];
		[_rightButton setBackgroundImage:[UIImage imageNamed:@"title_left_btn_sel"] forState:UIControlStateHighlighted];
		[_rightButton addTarget:self action:@selector(rightBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
	}
	return _rightButton;
}
/**
 *  功能:左按钮点击行为，可在子类重写此方法
 */
- (void)leftBtnClicked:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

/**
 *  功能:右按钮点击行为，可在子类重写此方法
 */
- (void)rightBtnClicked:(id)sender
{
    
}

- (void)showLoading {
    [self showHUD:nil];
}
- (void)hideLoading {
    [self hideHUD];
}
/**
 *  功能:显示hud
 */
- (void)showHUD:(NSString *)aMessage
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.labelText = aMessage;
}
/**
 *  功能:隐藏hud
 */
- (void)hideHUD
{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
}

- (NSString*)dateToNSString:(NSDate*)date
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd hh:mm:ss"];
    NSString *strDate = [dateFormatter stringFromDate:date];
    return strDate;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    //frame
    NSLog(@"%@",[self description]);
    self.view.backgroundColor=[UIColor whiteColor];
    CGRect thisRc = [UIScreen mainScreen].applicationFrame;
    float naviHeight = self.navigationController.navigationBar.frame.size.height;
	
    float tabHeight = SharedDelegate.tabbarController.tabBar.frame.size.height;
    if (self.hidesBottomBarWhenPushed) {
        thisRc.size.height -= naviHeight;
    } else {
        thisRc.size.height -= naviHeight + tabHeight;
    }
    self.view.frame = thisRc;
    self.view.bounds = CGRectMake(0, 0, thisRc.size.width, thisRc.size.height);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
