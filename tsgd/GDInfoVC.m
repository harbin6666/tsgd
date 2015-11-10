//
//  GDInfoVC.m
//  tsgd
//
//  Created by yuan jun on 15/1/15.
//  Copyright (c) 2015年 new. All rights reserved.
//

#import "GDInfoVC.h"
#import "PhoneViewPoper.h"
#import "RBCustomDatePickerView.h"
#import "FlySpeech.h"
typedef enum {
    bDispose_result=48,
    bContact_method=65,
    bNo_contact_reason=63,
    bSatisfaction=49,
    bCover_test_case_dx=51,
    bCover_test_case_lt=52,
    bMeasure=62,
    bInvolve_major_wide=56,
    bInvolve_major=50,
    kAcceput=101,
    kSubmit=102,
    kPopVC=103,
    dTaskTime=201,
    dEliminate_time=202,
    dComplaint_solve_time=203,
    dComplaint_plan_solve_time=204,
    dContact_time=205,
    dStartTime=206,
    bCauseClassA=302,
    bCauseClassB=303,
    bCauseClassC=304,
    bCauseClassD=305,
    bIs_complaint_solve=306,
    bIs_going_to_solve=307,
    bHow_to_solve=308,
    bIs_affirm=309,
    bIs_contact_client=310,
    bIs_answered=314,
    tTaskTel=401,
    tCompletion=402,
    tTel=403,
    tLinkman=404,
    tLinkman_phone=405,
    tSolution=406,
    tNo_affirm_reason=407,
    tContact_perosn=408,
    tContact_tel=409,
    tMeasure=410,
    tHandle=411
}ResponseTag;



@interface GDInfoVC ()<UITextViewDelegate,UITextFieldDelegate,UIScrollViewDelegate,UIAlertViewDelegate,PhoneViewPoperDelegate>
#pragma mark task回单
@property(nonatomic,strong)NSString *taskTime,*taskTel,*Completion;
#pragma mark 宽带投诉
@property(nonatomic,strong)NSDictionary*Involve_major_wide;
#pragma mark 普通投诉
@property(nonatomic,strong)NSDictionary*Involve_major;
#pragma mark 投诉共用
@property(nonatomic,strong)NSString *Tel,*Linkman,*Linkman_phone,*Eliminate_time,*Solution,*Complaint_solve_time,*Complaint_plan_solve_time,*No_affirm_reason,*Contact_time,*Contact_perosn,*Contact_tel,*StartTime;


@property(nonatomic,strong)NSMutableDictionary *Measure,*Dispose_result,*CauseClassA,*CauseClassB,*CauseClassC,*CauseClassD,*Is_complaint_solve,*Is_going_to_solve,*How_to_solve,*Is_affirm,*Is_contact_client,*Contact_method,*No_contact_reason,*Satisfaction,*Is_answered,*Cover_test_case_dx,*Cover_test_case_lt;


@property(nonatomic,strong)NSArray*list_Is_answered,*list_Is_complaint_solve,*list_Is_affirm,*list_Is_contact_client,*list_Is_going_to_solve;

@property(nonatomic,strong)UIScrollView*scroll,*formFlowView;
@property(nonatomic,strong)NSDictionary *detailDic;
@property(nonatomic,assign)FormState formState;
@property(nonatomic,strong)UIAlertView *alert;
@property(nonatomic,strong)UIImageView *bottomBar;
@property(nonatomic,strong)NSArray *formFlowArr;
@property(nonatomic,strong)NSArray *dataArr;
@property (nonatomic) UIButton *detailBtn;
@property (nonatomic) UIButton *flowBtn;//进程记录
@property(nonatomic,strong) PhoneViewPoper *viewPoper;
@property(nonatomic,strong) RBCustomDatePickerView *datePicker;

@property(nonatomic,strong)GDInputTextView*tvSolution,*tvMeasure,*tvNo_affirm_reason,*tvCompletion;



@end

@implementation GDInfoVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.scroll=[[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SelfViewWidth, SelfViewHeight-49)];
    self.scroll.delegate=self;
    self.scroll.backgroundColor=[UIColor clearColor];
    [self.view addSubview:self.scroll];
    
    self.formFlowView=[[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SelfViewWidth, SelfViewHeight-49)];
    [self.view addSubview:self.formFlowView];
    self.formFlowView.hidden=YES;
    
    UIImageView*bottom=[[UIImageView alloc] initWithFrame:CGRectMake(0, SelfViewHeight-49, SelfViewWidth, 49)];
    bottom.image=[UIImage imageNamed:@"tab_bg"];
    bottom.userInteractionEnabled=YES;
    [self.view addSubview:bottom];
    
    self.detailBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    self.detailBtn.frame=CGRectMake(0, 0, SelfViewWidth/2, 49);
    [self.detailBtn setBackgroundImage:[UIImage imageNamed:@"tab_bg"] forState:UIControlStateNormal];
    [self.detailBtn setBackgroundImage:[UIImage imageNamed:@"tab_bg_main_pressed"] forState:UIControlStateSelected];
    [self.detailBtn setTitle:@"工单详情" forState:UIControlStateNormal];
    [self.detailBtn setTitle:@"工单详情" forState:UIControlStateSelected];

    [self.detailBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.detailBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];

    self.detailBtn.titleLabel.font=[UIFont systemFontOfSize:20];
    [self.detailBtn addTarget:self action:@selector(bottomClick:) forControlEvents:UIControlEventTouchUpInside];
    [bottom addSubview:self.detailBtn];
    
    self.flowBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    self.flowBtn.frame=CGRectMake(SelfViewWidth/2, 0, SelfViewWidth/2, 49);
    [self.flowBtn setBackgroundImage:[UIImage imageNamed:@"tab_bg"] forState:UIControlStateNormal];
    [self.flowBtn setBackgroundImage:[UIImage imageNamed:@"tab_bg_main_pressed"] forState:UIControlStateSelected];
    [self.flowBtn setTitle:@"工单流程" forState:UIControlStateNormal];
    [self.flowBtn setTitle:@"工单流程" forState:UIControlStateSelected];

    [self.flowBtn addTarget:self action:@selector(bottomClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.flowBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.flowBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];

    self.flowBtn.titleLabel.font=[UIFont systemFontOfSize:20];
    [bottom addSubview:self.flowBtn];
    
    [bottom bringSubviewToFront:self.flowBtn];
    [bottom bringSubviewToFront:self.detailBtn];
    [self getInfoData];
    [self bottomClick:self.detailBtn];
    [self initData];
    self.formState=[self.queryObj[@"FormStatus"] intValue];
    // Do any additional setup after loading the view.
}

#pragma mark Data
-(NSDictionary*)taskParm{
    if ([self.taskTel isEmptyStr]||self.taskTel==nil) {
        [self showAlert:@"请填写操作人电话" msg:nil tag:0];
        return nil;

    }
    if ([self.taskTime isEmptyStr]||self.taskTime==nil) {
        [self showAlert:@"请填写操作时间" msg:nil tag:0];
        return nil;
        
    }
    if ([self.Completion isEqualToString:@""]||self.Completion==nil) {
        [self showAlert:@"请填写完成情况" msg:nil tag:0];
        return nil;
        
    }
    NSMutableDictionary*dic=@{}.mutableCopy;
    [dic setSafeObject:self.taskTime forKey:@"StartTime"];
    [dic setSafeObject:self.taskTel forKey:@"Tel"];
    [dic setSafeObject:self.Completion forKey:@"Completion"];
    return dic;
}

-(NSDictionary*)tousuParm{
    NSMutableDictionary*dic=[NSMutableDictionary dictionary];
    
    [dic setSafeObject:GLOBALVALUE.userTelNum forKey:@"Tel"];
    if ([self.Linkman isEmptyStr]||self.Linkman==nil) {
        [self showAlert:@"请填写联系人" msg:nil tag:0];
        return nil;
    }
    
    [dic setSafeObject:self.Linkman forKey:@"linkman"];
    if ([self.Linkman_phone isEmptyStr]||self.Linkman_phone==nil) {
        [self showAlert:@"请填写联系人电话" msg:nil tag:0];
        return nil;
    }
    [dic setSafeObject:self.Linkman_phone forKey:@"Linkman_phone"];
    if (self.Is_answered==nil) {
        [self showAlert:@"请选择是否已答复" msg:nil tag:0];
        return nil;
    }
    [dic setSafeObject:self.Is_answered[@"ID"] forKey:@"Is_answered"];
    [dic setSafeObject:self.Eliminate_time forKey:@"Eliminate_time"];
    if (self.Dispose_result==nil) {
        [self showAlert:@"请选择处理结果" msg:nil tag:0];
        return nil;
    }
    [dic setSafeObject:self.Dispose_result[@"ID"] forKey:@"Dispose_result"];
    if (self.CauseClassA==nil) {
        [self showAlert:@"请选择归因1级" msg:nil tag:0];
        return nil;
    }
    [dic setSafeObject:self.CauseClassA[@"Name"] forKey:@"CauseClassA"];
    
    if (self.CauseClassB==nil) {
        [self showAlert:@"请选择归因2级" msg:nil tag:0];
        return nil;
    }
    [dic setSafeObject:self.CauseClassB[@"Name"] forKey:@"CauseClassB"];
    [dic setSafeObject:self.CauseClassC[@"Name"] forKey:@"CauseClassC"];
    [dic setSafeObject:self.CauseClassD[@"Name"] forKey:@"CauseClassD"];
 
    if (self.Solution==nil) {
        [self showAlert:@"请填写问题原因、解决措施、处理经过" msg:nil tag:0];
        return nil;
    }
    [dic setSafeObject:self.Solution forKey:@"Solution"];
    
    if (self.Is_complaint_solve==nil) {
        [self showAlert:@"请选择问题是否解决" msg:nil tag:0];
        return nil;
    }
    [dic setSafeObject:self.Is_complaint_solve[@"ID"] forKey:@"Is_complaint_solve"];
    
    if ([self.Is_complaint_solve[@"ID"] integerValue]==1) {//已经解决
        if (self.Complaint_solve_time==nil) {
            [self showAlert:@"请填写问题解决时间" msg:nil tag:0];
            return nil;
        }
    }else{//没有解决
        if (self.Is_going_to_solve==nil) {
            [self showAlert:@"请填写是否计划解决" msg:nil tag:0];
            return nil;
        }
        
        if ([self.Is_going_to_solve[@"ID"] integerValue]==1) {//计划解决
            if (self.Complaint_plan_solve_time==nil) {
                [self showAlert:@"请填写计划解决时间" msg:nil tag:0];
                return nil;
            }
            if (self.How_to_solve==nil) {
                [self showAlert:@"请填写解决办法" msg:nil tag:0];
                return nil;
            }
        }else{
            if (self.How_to_solve==nil) {
                [self showAlert:@"请填写解决办法" msg:nil tag:0];
                return nil;
            }

        }
        
    }
    
    [dic setSafeObject:self.Complaint_solve_time forKey:@"Complaint_solve_time"];
#warning 是否计划解决字段，Is_going_to_solve  接口传递时，有计划解决传 1 ，无计划解决传 0
    [dic setSafeObject:self.Is_going_to_solve[@"ID"] forKey:@"Is_going_to_solve"];
    [dic setSafeObject:self.Complaint_plan_solve_time forKey:@"Complaint_plan_solve_time"];
    [dic setSafeObject:self.How_to_solve[@"ID"] forKey:@"How_to_solve"];
    
    if (self.Is_affirm==nil) {
        [self showAlert:@"请填写客户是否确认" msg:nil tag:0];
        return nil;
    }
    [dic setSafeObject:self.Is_affirm[@"ID"] forKey:@"Is_affirm"];
    
    if (self.Is_affirm==nil) {
        [self showAlert:@"请填写客户是否确认" msg:nil tag:0];
        return nil;
    }
    if ([self.Is_affirm[@"ID"] integerValue]==0&&self.No_affirm_reason==nil) {
        [self showAlert:@"请填写客户未确认原因" msg:nil tag:0];
        return nil;
    }
    [dic setSafeObject:self.No_affirm_reason forKey:@"No_affirm_reason"];
    
    if (self.Is_contact_client==nil) {
        [self showAlert:@"请填写是否联系客户" msg:nil tag:0];
        return nil;
    }
    
    if ([self.Is_contact_client[@"ID"] integerValue]==0) {//没联系客户
        if (self.No_contact_reason==nil) {
            [self showAlert:@"请填写未联系客户原因" msg:nil tag:0];
            return nil;
        }
    }else{//联系了
        if (self.Contact_method==nil) {
            [self showAlert:@"请填写联系客户的方式" msg:nil tag:0];
            return nil;
        }
        if (self.Contact_time==nil) {
            [self showAlert:@"请填写联系客户的时间" msg:nil tag:0];
            return nil;
        }
        if (self.Contact_perosn==nil) {
            [self showAlert:@"请填写联系客户的称呼" msg:nil tag:0];
            return nil;
        }
        if (self.Contact_tel==nil) {
            [self showAlert:@"请填写联系客户的号码" msg:nil tag:0];
            return nil;
        }
    }
    [dic setSafeObject:self.Is_contact_client[@"ID"] forKey:@"Is_contact_client"];
    [dic setSafeObject:self.Contact_time forKey:@"Contact_time"];
    [dic setSafeObject:self.Contact_method[@"ID"] forKey:@"Contact_method"];
    [dic setSafeObject:self.Contact_perosn forKey:@"Contact_perosn"];
    [dic setSafeObject:self.Contact_tel forKey:@"Contact_tel"];
    [dic setSafeObject:self.No_contact_reason[@"ID"] forKey:@"No_contact_reason"];
    
    if (self.Satisfaction==nil) {
        [self showAlert:@"请填写联系客户满意情况" msg:nil tag:0];
        return nil;
    }
    [dic setSafeObject:self.Satisfaction[@"ID"] forKey:@"Satisfaction"];

    if (self.Involve_major_wide==nil&&GLOBALVALUE.targetType==kKd) {
        [self showAlert:@"请填写投诉涉及专业" msg:nil tag:0];
        return nil;
    }
    if (self.Involve_major==nil&&GLOBALVALUE.targetType==kTs) {
        [self showAlert:@"请填写投诉涉及专业" msg:nil tag:0];
        return nil;
    }

    [dic setSafeObject:self.Involve_major[@"ID"] forKey:@"Involve_major"];
    [dic setSafeObject:self.Involve_major_wide[@"ID"] forKey:@"Involve_major_wide"];
    if (GLOBALVALUE.targetType!=kKd&&(self.Cover_test_case_dx==nil||self.Cover_test_case_lt==nil)) {
        [self showAlert:@"请填写三网覆盖测试情况" msg:nil tag:0];
        return nil;
    }
    [dic setSafeObject:self.Cover_test_case_dx[@"ID"] forKey:@"Cover_test_case_dx"];
    [dic setSafeObject:self.Cover_test_case_lt[@"ID"] forKey:@"Cover_test_case_lt"];
    
    if (GLOBALVALUE.targetType==kKd&&self.Measure==nil) {
        [self showAlert:@"请填写处理措施" msg:nil tag:0];
        return nil;
    }
        [dic setSafeObject:self.Measure[@"Name"] forKey:@"Measure"];

    
    return dic;
}

-(void)initData{
    self.list_Is_affirm=@[@{@"ID":@1,@"Name":@"是"},@{@"ID":@0,@"Name":@"否"}];
    self.list_Is_answered=@[@{@"ID":@1,@"Name":@"是"},@{@"ID":@0,@"Name":@"否"}];
    self.list_Is_complaint_solve=@[@{@"ID":@1,@"Name":@"是"},@{@"ID":@0,@"Name":@"否"}];
    self.list_Is_contact_client=@[@{@"ID":@1,@"Name":@"是"},@{@"ID":@0,@"Name":@"否"}];
    self.list_Is_going_to_solve=@[@{@"ID":@1,@"Name":@"有计划解决"},@{@"ID":@0,@"Name":@"无计划解决"}];
}

#pragma mark net
-(void)getInfoData{
    NSMutableDictionary*dic=@{@"FormNo":self.queryObj[@"FormNo"]}.mutableCopy;
    [self showLoading];
    WEAK_SELF;
    [GDService requestFunc:@"get_form_info" WithParam:dic withCompletBlcok:^(id reObj, NSError *error) {
        [self hideLoading];
        STRONG_SELF;
            if (error==nil&&[reObj isKindOfClass:[NSDictionary class]]) {
                self.dataArr=((NSDictionary*)reObj)[@"Result"];
                self.detailDic=reObj;
                [self updateDetail];
                
            }else{
                [self showAlert:@"获取信息失败" msg:nil tag:kPopVC];
            }
        [self getFlowData];

    }];
}

-(void)getFlowData{
    NSMutableDictionary*dic=@{@"FormNo":self.queryObj[@"FormNo"]}.mutableCopy;
    WEAK_SELF;
    [GDService requestFunc:@"get_form_flow" WithParam:dic withCompletBlcok:^(id reObj, NSError *error) {
        STRONG_SELF;
        if (error==nil) {
            if ([reObj isKindOfClass:[NSArray class]]) {
                self.formFlowArr=(NSArray*)reObj;
            }
            [self updateFormView];
        }
    }];

}

-(void)setAcceptState{
    NSMutableDictionary*dic=@{@"FormNo":self.queryObj[@"FormNo"]}.mutableCopy;
    [dic setSafeObject:__INT(3) forKey:@"FormState"];
    [dic setSafeObject:[self dateToNSString:[NSDate date]] forKey:@"StartTime"];
    [dic setSafeObject:GLOBALVALUE.loginedUserName forKey:@"Dealor"];

    [self showLoading];
    WEAK_SELF;
    [GDService requestFunc:@"set_accept_state" WithParam:dic withCompletBlcok:^(id reObj, NSError *error) {
        STRONG_SELF;
        [self hideLoading];
        if (error==nil) {
            NSString *str = [reObj objectForKey:@"Flag"];
            if ([str isEqualToString:@"成功"]) {
                [self showAlert:@"操作成功" msg:nil tag:kPopVC];
            }else{
                [self showAlert:@"操作失败" msg:str tag:0];
            }
        }else{
            [self showAlert:@"操作失败" msg:nil tag:0];
        }
    }];

}

-(void)setStateLast{
    NSMutableDictionary*dic=@{@"FormNo":self.queryObj[@"FormNo"]}.mutableCopy;
    [dic setSafeObject:GLOBALVALUE.loginedUserName forKey:@"Dealor"];
    [dic setSafeObject:__INT(4) forKey:@"FormState"];
    [dic setSafeObject:GLOBALVALUE.userGroup forKey:@"UnitName"];
    [dic setSafeObject:self.StartTime forKey:@"StartTime"];
    if (GLOBALVALUE.targetType==kRw) {
        NSDictionary *temp=[self taskParm];
        if (temp==nil) {
            return;
        }
        [dic addEntriesFromDictionary:temp];
    }else{
        NSDictionary *temp=[self tousuParm];
        if (temp==nil) {
            return;
        }
        [dic addEntriesFromDictionary:temp];
    }
    [self showLoading];
    WEAK_SELF;
    [GDService requestFunc:@"set_state_last" WithParam:dic withCompletBlcok:^(id reObj, NSError *error) {
        STRONG_SELF;
        [self hideLoading];
        if (error==nil) {
            NSString *str = [reObj objectForKey:@"Flag"];
            if ([str isEqualToString:@"成功"]) {
                [self showAlert:@"操作成功" msg:nil tag:kPopVC];
            }else{
                [self showAlert:@"操作失败" msg:str tag:0];
            }
        }else{
            [self showAlert:@"操作失败" msg:nil tag:0];
        }
    }];
}

-(void)get_sys_dict:(NSNumber*)typeId complete:(compBlock) block{
    [self showLoading];
    WEAK_SELF;
    [GDService requestWithFunctionName:@"get_sys_dict" pramaDic:@{@"TypeID":typeId,@"FrontFlag":@1}.mutableCopy requestMethod:@"POST" completion:^(id reObj, NSError *error) {
        STRONG_SELF;
        [self hideLoading];
        if (error==nil&&[reObj count]>0) {
            block(reObj,error);
        }else{
            [self showAlert:@"没有结果" msg:nil tag:0];
        }
    }];
    
}
-(void)getCause:(NSNumber*)pId complete:(compBlock)block{

    if (self.CauseClassA==nil) {
        if (GLOBALVALUE.targetType==kKd) {
            pId=@1010626;
        }else{
            pId=@1010615;
        }
    }else if (self.CauseClassB==nil){
        pId=self.CauseClassA[@"No"];
    }else if (self.CauseClassC==nil){
        pId=self.CauseClassB[@"No"];
    }else if (self.CauseClassD==nil){
        pId=self.CauseClassC[@"No"];
    }

    [self showLoading];
    WEAK_SELF;
    [GDService requestWithFunctionName:@"get_question_class" pramaDic:@{@"ParentId":pId}.mutableCopy requestMethod:@"POST" completion:^(id reObj, NSError *error) {
        STRONG_SELF;
        [self hideLoading];
        if (error==nil&&[reObj count]>0) {
            block(reObj,error);
        }else{
            [self showAlert:@"没有结果" msg:nil tag:0];
        }
        
    }];
}

-(void)get_local_dict:(NSInteger)tag complete:(compBlock)block{
    
    switch (tag) {
        case bIs_affirm:
            block(self.list_Is_affirm,nil);
            break;
        case bIs_going_to_solve:
            block(self.list_Is_going_to_solve,nil);
            break;
        case bIs_contact_client:
            block(self.list_Is_contact_client,nil);
            break;
        case bIs_complaint_solve:
            block(self.list_Is_complaint_solve,nil);
            break;
        case bIs_answered:
            block(self.list_Is_answered,nil);
            break;

        default:
            break;
    }
}
#pragma mark action
- (void)acceptBtnClicked {
    [self closeKeyBoard];
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"是否受理工单" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"受理",nil];
    alert.tag = kAcceput;
    [alert show];
}

- (void)submitBtnClick {
    [self closeKeyBoard];
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"是否要提交该工单，等待质检?" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定",nil];
    alert.tag = kSubmit;
    [alert show];
}

-(void)showAlert:(NSString*)tit msg:(NSString*)msg tag:(NSInteger)tag {
    self.alert=[[UIAlertView alloc] initWithTitle:tit message:msg delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
    self.alert.tag=tag;
    [self.alert show];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag==kPopVC) {
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        if (buttonIndex==1) {
            if (alertView.tag==kAcceput) {
                [self setAcceptState];
            }else if (alertView.tag==kSubmit){
                [self setStateLast];
            }
        }
    }
    
}
-(void)bottomClick:(UIButton*)btn{
    self.detailBtn.selected=NO;
    self.flowBtn.selected=NO;
    btn.selected=YES;
    if (self.detailBtn.selected) {
        self.scroll.hidden=NO;
        self.formFlowView.hidden=YES;
    }
    
    if (self.flowBtn.selected) {
        self.scroll.hidden=YES;
        self.formFlowView.hidden=NO;
    }

}

-(void)dateClick:(UIButton*)btn{
    [self closeKeyBoard];
    self.viewPoper=[[PhoneViewPoper alloc] init];
    self.viewPoper.pickerView.tag=btn.tag;
    self.datePicker=[[RBCustomDatePickerView alloc] initWithFrame:CGRectMake(0, 40, 320, 200)];//
    self.datePicker.backgroundColor=[UIColor whiteColor];
    [self.viewPoper.popView addSubview:self.datePicker];
    self.viewPoper.delegate=self;
    [self.viewPoper showPopView];

}
- (void)btnClick:(UIButton*)btn {
    NSNumber *TYPEID=@(btn.tag);
    if (btn.tag==308) {
        if ([self.Is_going_to_solve[@"ID"] integerValue]==0) {
            TYPEID=@60;
        }else{
            TYPEID=@61;
        }
    }
    
    [self closeKeyBoard];
    self.viewPoper=[[PhoneViewPoper alloc] init];
    self.viewPoper.pickerView.tag=btn.tag;
    self.viewPoper.delegate=self;

    if (TYPEID.integerValue<100) {
        WEAK_SELF;
        [self get_sys_dict:TYPEID complete:^(id reObj, NSError *error) {
            STRONG_SELF;
            self.dataArr=reObj;
            [self.viewPoper showPopView];
        }];
    }else if (TYPEID.integerValue>=bCauseClassA&&TYPEID.integerValue<=bCauseClassD){
        WEAK_SELF;
        [self getCause:nil complete:^(id reObj, NSError *error) {
            STRONG_SELF;
            self.dataArr=reObj;
            [self.viewPoper showPopView];
        }];

    } else{
        WEAK_SELF;
        [self get_local_dict:TYPEID.integerValue complete:^(id reObj, NSError *error) {
            STRONG_SELF;
            self.dataArr=reObj;
            [self.viewPoper showPopView];

        }];
    }
    
}

-(void)yuyin:(UIButton*)yuyinBtn{
    [self closeKeyBoard];
    [[FlySpeech sharedInstance] startRecognizer:self.view comletion:^(NSString *yuyingresult) {
        if (self.tvNo_affirm_reason.tag==yuyinBtn.tag) {
            self.No_affirm_reason=yuyingresult;
            self.tvNo_affirm_reason.text=yuyingresult;
        }else if(self.tvSolution.tag==yuyinBtn.tag){
            self.Solution=yuyingresult;
            self.tvSolution.text=yuyingresult;
        }else if(self.tvMeasure.tag==yuyinBtn.tag){
            self.Measure=@{@"Name":yuyingresult}.mutableCopy;
            self.tvMeasure.text=yuyingresult;
        }else if(self.tvCompletion.tag==yuyinBtn.tag){
            self.Completion=yuyingresult;
            self.tvCompletion.text=yuyingresult;
        }
        [[FlySpeech sharedInstance] quitRecgnizer];
    }];

    
}
#pragma mark delegate

-(void)closeKeyBoard{
     [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (scrollView.isDragging) {
        [self closeKeyBoard];
    }
}
- (void)textViewDidBeginEditing:(UITextView *)textView {

    CGRect rec = [textView superview].frame;
    
    CGFloat offset = 216+20 - (self.scroll.frame.size.height - rec.size.height- rec.origin.y);
    [self.scroll setContentOffset:CGPointMake(0, offset) animated:YES];
}
- (BOOL)textViewShouldEndEditing:(UITextView *)textView {
    
    if (self.tvNo_affirm_reason.tag==textView.tag) {
        self.No_affirm_reason=textView.text;
    }else if(self.tvSolution.tag==textView.tag){
        self.Solution=textView.text;
    }else if(self.tvMeasure.tag==textView.tag){
        self.Measure=@{@"Name":textView.text}.mutableCopy;
    }else if(self.tvCompletion.tag==textView.tag){
        self.Completion=textView.text;
    }
    
    [textView resignFirstResponder];
    return YES;
}
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    CGRect rec = [textField superview].frame;
    CGFloat offset = 216+20 - (self.scroll.frame.size.height - rec.size.height- rec.origin.y);
    [self.scroll setContentOffset:CGPointMake(0, offset) animated:YES];
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
    switch (textField.tag) {
        case tTaskTel:
            self.taskTel=textField.text;
            break;
        case tContact_tel:
            self.Contact_tel=textField.text;
            break;
        case tContact_perosn:
            self.Contact_perosn=textField.text;
            break;
        case tLinkman_phone:
            self.Linkman_phone=textField.text;
            break;
        case tLinkman:
            self.Linkman=textField.text;
            break;
        case tTel:
            self.Tel=textField.text;
            break;
        default:
            break;
    }
    [textField resignFirstResponder];
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

- (void)viewPoper:(PhoneViewPoper *)aViewPoper cancelBtnClicked:(id)sender{
    [aViewPoper hidePopView];
}

/**
 *  功能:点击完成按钮
 */
- (void)viewPoper:(PhoneViewPoper *)aViewPoper finishBtnClicked:(id)sender{
    NSInteger row=0;
    NSMutableDictionary *selDic=nil;
    if (self.viewPoper.pickerView.tag>300||self.viewPoper.pickerView.tag<100) {
         row = [self.viewPoper.pickerView selectedRowInComponent:0];
         selDic = [self.dataArr safeObjectAtIndex:row];
    }

    switch (self.viewPoper.pickerView.tag) {
        case dTaskTime:
            self.taskTime=[self dateToNSString:self.datePicker.date];
            break;
            
        case dEliminate_time:
            self.Eliminate_time=[self dateToNSString:self.datePicker.date];
            break;
        case dComplaint_solve_time:
            self.Complaint_solve_time=[self dateToNSString:self.datePicker.date];
            break;
        case dComplaint_plan_solve_time:
            self.Complaint_plan_solve_time=[self dateToNSString:self.datePicker.date];
            break;
        case dContact_time:
            self.Contact_time=[self dateToNSString:self.datePicker.date];
            break;
        case dStartTime:
            self.StartTime=[self dateToNSString:self.datePicker.date];
            break;
        case bDispose_result:
            self.Dispose_result=selDic;
            break;
        case bCauseClassA:
            self.CauseClassA=selDic;
            self.CauseClassB=nil;
            self.CauseClassC=nil;
            self.CauseClassD=nil;
            break;
        case bCauseClassB:
            self.CauseClassB=selDic;
            self.CauseClassC=nil;
            self.CauseClassD=nil;
            break;
        case bCauseClassC:
            self.CauseClassC=selDic;
            self.CauseClassD=nil;
            break;
        case bCauseClassD:
            self.CauseClassD=selDic;
            break;
        case bIs_complaint_solve:
            self.Is_complaint_solve=selDic;
            self.Is_going_to_solve=nil;
            self.How_to_solve=nil;
            self.Complaint_plan_solve_time=nil;
            self.Complaint_solve_time=nil;

            break;
        case bIs_going_to_solve:
            self.Is_going_to_solve=selDic;
            self.How_to_solve=nil;
            self.Complaint_plan_solve_time=nil;
            self.Complaint_solve_time=nil;
            break;
        case bHow_to_solve:
            self.How_to_solve=selDic;
            break;
        case bIs_affirm:
            self.Is_affirm=selDic;
            self.No_affirm_reason=nil;
            break;
        case bIs_contact_client:
            self.Is_contact_client=selDic;
            self.Contact_method=nil;
            self.No_contact_reason=nil;
            self.Contact_perosn=nil;
            self.Contact_tel=nil;
            self.Contact_time=nil;
            break;
        case bContact_method:
            self.Contact_method=selDic;
            break;
        case bNo_contact_reason:
            self.No_contact_reason=selDic;
            break;
        case bSatisfaction:
            self.Satisfaction=selDic;
            break;
        case bIs_answered:
            self.Is_answered=selDic;
            break;
        case bCover_test_case_dx:
            self.Cover_test_case_dx=selDic;
            break;
        case bCover_test_case_lt:
            self.Cover_test_case_lt=selDic;
            break;
        case bMeasure:
            self.Measure=selDic;
            break;
        case bInvolve_major_wide:
            self.Involve_major_wide=selDic;
            break;
        case bInvolve_major:
            self.Involve_major=selDic;
            break;
        default:
            break;
    }
    [self updateDetail];
}
- (NSInteger)viewPoper:(PhoneViewPoper *)aViewPoper numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}

/**
 *  功能:picker view的componet的行数
 */
- (NSInteger)viewPoper:(PhoneViewPoper *)aViewPoper pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return   self.dataArr.count;
}

-(UIView*)viewPoper:(PhoneViewPoper *)aViewPoper pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component{
    NSString *str=@"";
    NSMutableDictionary *dic;

    dic=self.dataArr[row];
    str=dic[@"Name"];

    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 280, 40)];
    label.backgroundColor = [UIColor clearColor];
    label.numberOfLines = 0;
    label.font = [UIFont systemFontOfSize:16.0];
    label.adjustsFontSizeToFitWidth = YES;
    label.adjustsLetterSpacingToFitWidth = YES;
    label.minimumScaleFactor = 0.1;
    label.text = str;
    return label;
}

#pragma mark UI
-(void)updateDetail{
    
    for (UIView* aView in self.scroll.subviews) {
        [aView removeFromSuperview];
    }
    int yPositon = 5;
    int rightXposition = 100;
    GDNameLab *lab=nil;
    GDTextView *txtV=nil;
    for (NSDictionary* dic in self.detailDic[@"Result"]) {
        NSString *left=[NSString stringWithFormat:@"%@:",dic[@"Key"]];
        NSString *right=[dic[@"Value"] decodeBase64];
        NSLog(@"%@",right);
        CGSize  size = [right sizeWithFont:TEXTFONT constrainedToSize:CGSizeMake(SelfViewWidth-rightXposition, 2000)];
        CGSize  size1 = [left sizeWithFont:TEXTFONT constrainedToSize:CGSizeMake(80, 2000)];
        CGFloat height=size.height>size1.height?size.height:size1.height;
        lab = [[GDNameLab alloc]initWithFrame:CGRectMake(10, yPositon, 80, size1.height)];
        lab.text=left;
        
        txtV=[[GDTextView alloc] initWithFrame:CGRectMake(rightXposition, yPositon, SelfViewWidth-rightXposition, height)];
        txtV.text=right;
        [self.scroll addSubview:lab];
        [self.scroll addSubview:txtV];
        
        yPositon+=height+8;
        }
    
    if (!self.isTodo) {
        self.scroll.contentSize = CGSizeMake(SelfViewWidth, yPositon+10);
        return;
    }
    
    
    
    if (self.formState==FormState_doing) {
        if (GLOBALVALUE.targetType==kRw) {
            [self updateTask:yPositon+10];
        }else{
            [self updateDoing:yPositon+10];
        }

    }else if (self.formState==FormState_done){
        self.scroll.contentSize = CGSizeMake(SelfViewWidth, yPositon+10);
    }else if (self.formState==FormState_todo){
        [self updateTodo:yPositon+10];
    }
}

-(void)updateTask:(float)y{
    if (self.taskTime==nil) {
        self.taskTime=[self dateToNSString:[NSDate date]];
    }
    if (self.taskTel==nil) {
        self.taskTel=GLOBALVALUE.userTelNum;
    }

    HandleView*v=[[HandleView alloc] initWithType:kBtn key:@"操作时间" Value:self.taskTime tag:dTaskTime block:^(id sender, UIButton *yuyin) {
        UIButton* btn=(UIButton*)sender;
        [btn addTarget:self action:@selector(dateClick:) forControlEvents:UIControlEventTouchUpInside];
    }];
    v.frame=CGRectMake(0, y, SelfViewWidth, 30);
    [self.scroll addSubview:v];
    y+=35;
    
    v=[[HandleView alloc] initWithType:kTextFeild key:@"联系电话" Value:self.taskTel tag:tTaskTel block:^(id sender, UIButton *yuyin) {
        GDTextField* tf=(GDTextField*)sender;
        tf.delegate=self;
    }];
    v.frame=CGRectMake(0, y, SelfViewWidth, 30);
    [self.scroll addSubview:v];
    y+=35;

    v=[[HandleView alloc] initWithType:kTextView key:@"完成情况" Value:self.Completion tag:tCompletion block:^(id sender, UIButton *yuyin) {
        GDInputTextView* tv=(GDInputTextView*)sender;
        self.tvCompletion=tv;
        tv.delegate=self;
        [yuyin addTarget:self action:@selector(yuyin:) forControlEvents:UIControlEventTouchUpInside];
    }];
    v.frame=CGRectMake(0, y, SelfViewWidth, 50);
    [self.scroll addSubview:v];
    y+=55;
    
    UIButton *acceptBtn = [[UIButton alloc]initWithFrame:CGRectMake(SelfViewWidth/5, y, SelfViewWidth*3/5, 30)];
    [acceptBtn setTitle:@"回单" forState:UIControlStateNormal];
    [acceptBtn setBackgroundImage:[UIImage imageNamed:@"operBtn"] forState:UIControlStateNormal];
    acceptBtn.titleLabel.font = [UIFont systemFontOfSize:16.0];
    [acceptBtn addTarget:self action:@selector(submitBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.scroll addSubview:acceptBtn];
    y+=35;

    
    self.scroll.contentSize = CGSizeMake(SelfViewWidth, y);
}


-(void)updateTodo:(float)y{
    UIButton *acceptBtn = [[UIButton alloc]initWithFrame:CGRectMake(SelfViewWidth/5, y, SelfViewWidth*3/5, 30)];
    [acceptBtn setTitle:@"受理" forState:UIControlStateNormal];
    [acceptBtn setBackgroundImage:[UIImage imageNamed:@"operBtn"] forState:UIControlStateNormal];
    acceptBtn.titleLabel.font = [UIFont systemFontOfSize:16.0];
    [acceptBtn addTarget:self action:@selector(acceptBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.scroll addSubview:acceptBtn];
    y+=35;
    self.scroll.contentSize = CGSizeMake(SelfViewWidth, y);
}

-(void)updateDoing:(float)y{
    
    HandleView* v=[[HandleView alloc] initWithType:kTextFeild key:@"联系人" Value:self.Linkman tag:tLinkman block:^(id sender, UIButton *yuyin) {
        GDTextField* tf=(GDTextField*)sender;
        tf.delegate=self;
    }];
    v.frame=CGRectMake(0, y, SelfViewWidth, 30);
    [self.scroll addSubview:v];
    y+=35;

    v=[[HandleView alloc] initWithType:kTextFeild key:@"联系电话" Value:self.Linkman_phone tag:tLinkman_phone block:^(id sender, UIButton *yuyin) {
        GDTextField* tf=(GDTextField*)sender;
        tf.delegate=self;
    }];
    v.frame=CGRectMake(0, y, SelfViewWidth, 30);
    [self.scroll addSubview:v];
    y+=35;

    v=[[HandleView alloc] initWithType:kBtn key:@"是否已答复" Value:self.Is_answered[@"Name"] tag:bIs_answered block:^(id sender, UIButton *yuyin) {
        UIButton* btn=(UIButton*)sender;
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    }];
    v.frame=CGRectMake(0, y, SelfViewWidth, 30);
    [self.scroll addSubview:v];
    y+=35;
    
    v=[[HandleView alloc] initWithType:kBtn key:@"消除时间" Value:self.Eliminate_time tag:dEliminate_time block:^(id sender, UIButton *yuyin) {
        UIButton* btn=(UIButton*)sender;
        [btn addTarget:self action:@selector(dateClick:) forControlEvents:UIControlEventTouchUpInside];
    }];
    v.frame=CGRectMake(0, y, SelfViewWidth, 30);
    [self.scroll addSubview:v];
    y+=35;
    
    v=[[HandleView alloc] initWithType:kBtn key:@"处理结果" Value:self.Dispose_result[@"Name"] tag:bDispose_result block:^(id sender, UIButton *yuyin) {
        UIButton* btn=(UIButton*)sender;
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    }];
    v.frame=CGRectMake(0, y, SelfViewWidth, 30);
    [self.scroll addSubview:v];
    y+=35;
    
    v=[[HandleView alloc] initWithType:kTextView key:@"问题原因\n处理经过" Value:self.Solution tag:tSolution block:^(id sender, UIButton *yuyin) {
        GDInputTextView* tv=(GDInputTextView*)sender;
        self.tvSolution=tv;
        tv.delegate=self;
        [yuyin addTarget:self action:@selector(yuyin:) forControlEvents:UIControlEventTouchUpInside];
    }];
    v.frame=CGRectMake(0, y, SelfViewWidth, 50);
    [self.scroll addSubview:v];
    y+=55;

    if (GLOBALVALUE.targetType==kKd) {
        v=[[HandleView alloc] initWithType:kBtn key:@"处理措施" Value:self.Measure[@"Name"] tag:bMeasure block:^(id sender, UIButton *yuyin) {
            UIButton* btn=(UIButton*)sender;
            [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        }];
        v.frame=CGRectMake(0, y, SelfViewWidth, 30);
        [self.scroll addSubview:v];
        y+=35;
    }else{
        v=[[HandleView alloc] initWithType:kTextView key:@"处理措施" Value:self.Measure[@"Name"] tag:tMeasure block:^(id sender, UIButton *yuyin) {
            GDInputTextView* tv=(GDInputTextView*)sender;
            self.tvMeasure=tv;
            tv.delegate=self;
            [yuyin addTarget:self action:@selector(yuyin:) forControlEvents:UIControlEventTouchUpInside];
        }];
        v.frame=CGRectMake(0, y, SelfViewWidth, 50);
        [self.scroll addSubview:v];
        y+=55;
    }
    
    v=[[HandleView alloc] initWithType:kBtn key:@"原因一级" Value:self.CauseClassA[@"Name"] tag:bCauseClassA block:^(id sender, UIButton *yuyin) {
        UIButton* btn=(UIButton*)sender;
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    }];
    v.frame=CGRectMake(0, y, SelfViewWidth, 30);
    [self.scroll addSubview:v];
    y+=35;

    v=[[HandleView alloc] initWithType:kBtn key:@"原因二级" Value:self.CauseClassB[@"Name"] tag:bCauseClassB block:^(id sender, UIButton *yuyin) {
        UIButton* btn=(UIButton*)sender;
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    }];
    v.frame=CGRectMake(0, y, SelfViewWidth, 30);
    [self.scroll addSubview:v];
    y+=35;
    v=[[HandleView alloc] initWithType:kBtn key:@"原因三级" Value:self.CauseClassC[@"Name"] tag:bCauseClassC block:^(id sender, UIButton *yuyin) {
        UIButton* btn=(UIButton*)sender;
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    }];
    v.frame=CGRectMake(0, y, SelfViewWidth, 30);
    [self.scroll addSubview:v];
    y+=35;
    
    v=[[HandleView alloc] initWithType:kBtn key:@"原因四级" Value:self.CauseClassD[@"Name"] tag:bCauseClassD block:^(id sender, UIButton *yuyin) {
        UIButton* btn=(UIButton*)sender;
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    }];
    v.frame=CGRectMake(0, y, SelfViewWidth, 30);
    [self.scroll addSubview:v];
    y+=35;

    v=[[HandleView alloc] initWithType:kBtn key:@"是否解决" Value:self.Is_complaint_solve[@"Name"] tag:bIs_complaint_solve block:^(id sender, UIButton *yuyin) {
        UIButton* btn=(UIButton*)sender;
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    }];
    v.frame=CGRectMake(0, y, SelfViewWidth, 30);
    [self.scroll addSubview:v];
    y+=35;

    if (self.Is_complaint_solve!=nil) {
        if ([self.Is_complaint_solve[@"ID"] integerValue]==1) {
            v=[[HandleView alloc] initWithType:kBtn key:@"解决时间" Value:self.Complaint_solve_time tag:dComplaint_solve_time block:^(id sender, UIButton *yuyin) {
                UIButton* btn=(UIButton*)sender;
                [btn addTarget:self action:@selector(dateClick:) forControlEvents:UIControlEventTouchUpInside];
            }];
            v.frame=CGRectMake(0, y, SelfViewWidth, 30);
            [self.scroll addSubview:v];
            y+=35;
        }else{
            v=[[HandleView alloc] initWithType:kBtn key:@"是否计划解决" Value:self.Is_going_to_solve[@"Name"] tag:bIs_going_to_solve block:^(id sender, UIButton *yuyin) {
                UIButton* btn=(UIButton*)sender;
                [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
            }];
            v.frame=CGRectMake(0, y, SelfViewWidth, 30);
            [self.scroll addSubview:v];
            y+=35;
            
            v=[[HandleView alloc] initWithType:kBtn key:@"计划解决办法" Value:self.How_to_solve[@"Name"] tag:bHow_to_solve block:^(id sender, UIButton *yuyin) {
                UIButton* btn=(UIButton*)sender;
                [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
            }];
            v.frame=CGRectMake(0, y, SelfViewWidth, 30);
            [self.scroll addSubview:v];
            y+=35;
            
            if (self.Is_going_to_solve!=nil&&[self.self.Is_going_to_solve[@"ID"] integerValue]==1) {
                v=[[HandleView alloc] initWithType:kBtn key:@"计划解决时间" Value:self.Complaint_plan_solve_time tag:dComplaint_plan_solve_time block:^(id sender, UIButton *yuyin) {
                    UIButton* btn=(UIButton*)sender;
                    [btn addTarget:self action:@selector(dateClick:) forControlEvents:UIControlEventTouchUpInside];
                }];
                v.frame=CGRectMake(0, y, SelfViewWidth, 30);
                [self.scroll addSubview:v];
                y+=35;

            }
        }
    }
    

    v=[[HandleView alloc] initWithType:kBtn key:@"用户是否确认" Value:self.Is_affirm[@"Name"] tag:bIs_affirm block:^(id sender, UIButton *yuyin) {
        UIButton* btn=(UIButton*)sender;
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    }];
    v.frame=CGRectMake(0, y, SelfViewWidth, 30);
    [self.scroll addSubview:v];
    y+=35;
    
    if (self.Is_affirm!=nil&&[self.Is_affirm[@"ID"] integerValue]==0) {
        v=[[HandleView alloc] initWithType:kTextView key:@"未确认原因" Value:self.No_affirm_reason tag:tNo_affirm_reason block:^(id sender, UIButton *yuyin) {
            GDInputTextView* tv=(GDInputTextView*)sender;
            self.tvNo_affirm_reason=tv;
            tv.delegate=self;
            [yuyin addTarget:self action:@selector(yuyin:) forControlEvents:UIControlEventTouchUpInside];
        }];
        v.frame=CGRectMake(0, y, SelfViewWidth, 50);
        [self.scroll addSubview:v];
        y+=55;
    }

    v=[[HandleView alloc] initWithType:kBtn key:@"是否联系客户" Value:self.Is_contact_client[@"Name"] tag:bIs_contact_client block:^(id sender, UIButton *yuyin) {
        UIButton* btn=(UIButton*)sender;
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    }];
    v.frame=CGRectMake(0, y, SelfViewWidth, 30);
    [self.scroll addSubview:v];
    y+=35;
    
    if (self.Is_contact_client!=nil) {
        if ([self.Is_contact_client[@"ID"] integerValue]==1) {//联系了用户
            
            v=[[HandleView alloc] initWithType:kBtn key:@"联系客户时间" Value:self.Contact_time tag:dContact_time block:^(id sender, UIButton *yuyin) {
                UIButton* btn=(UIButton*)sender;
                [btn addTarget:self action:@selector(dateClick:) forControlEvents:UIControlEventTouchUpInside];
            }];
            v.frame=CGRectMake(0, y, SelfViewWidth, 30);
            [self.scroll addSubview:v];
            y+=35;

            v=[[HandleView alloc] initWithType:kBtn key:@"联系客户方式" Value:self.Contact_method[@"Name"] tag:bContact_method block:^(id sender, UIButton *yuyin) {
                UIButton* btn=(UIButton*)sender;
                [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
            }];
            v.frame=CGRectMake(0, y, SelfViewWidth, 30);
            [self.scroll addSubview:v];
            y+=35;
            
            v=[[HandleView alloc] initWithType:kTextFeild key:@"客户称呼" Value:self.Contact_perosn tag:tContact_perosn block:^(id sender, UIButton *yuyin) {
                GDTextField* tf=(GDTextField*)sender;
                tf.delegate=self;
            }];
            v.frame=CGRectMake(0, y, SelfViewWidth, 30);
            [self.scroll addSubview:v];
            y+=35;

            
            v=[[HandleView alloc] initWithType:kTextFeild key:@"客户联系电话" Value:self.Contact_tel tag:tContact_tel block:^(id sender, UIButton *yuyin) {
                GDTextField* tf=(GDTextField*)sender;
                tf.delegate=self;
            }];
            v.frame=CGRectMake(0, y, SelfViewWidth, 30);
            [self.scroll addSubview:v];
            y+=35;

        }else{
            v=[[HandleView alloc] initWithType:kBtn key:@"未联系客户原因" Value:self.No_contact_reason[@"Name"] tag:bNo_contact_reason block:^(id sender, UIButton *yuyin) {
                UIButton* btn=(UIButton*)sender;
                [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
            }];
            v.frame=CGRectMake(0, y, SelfViewWidth, 30);
            [self.scroll addSubview:v];
            y+=35;
            
        }
    }
    
    v=[[HandleView alloc] initWithType:kBtn key:@"客户满意情况" Value:self.Satisfaction[@"Name"] tag:bSatisfaction block:^(id sender, UIButton *yuyin) {
        UIButton* btn=(UIButton*)sender;
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    }];
    v.frame=CGRectMake(0, y, SelfViewWidth, 30);
    [self.scroll addSubview:v];
    y+=35;

    
    NSString *val=nil;
    ResponseTag ta;
    if (GLOBALVALUE.targetType==kKd) {
        val=self.Involve_major_wide[@"Name"];
        ta=bInvolve_major_wide;
    }else{
        val=self.Involve_major[@"Name"];
        ta=bInvolve_major;
    }
    v=[[HandleView alloc] initWithType:kBtn key:@"投诉涉及专业" Value:val tag:ta block:^(id sender, UIButton *yuyin) {
        UIButton* btn=(UIButton*)sender;
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    }];
    v.frame=CGRectMake(0, y, SelfViewWidth, 30);
    [self.scroll addSubview:v];
    y+=35;

    if (GLOBALVALUE.targetType!=kKd) {
        v=[[HandleView alloc] initWithType:kBtn key:@"弱覆盖三网测试_电信" Value:self.Cover_test_case_dx[@"Name"] tag:bCover_test_case_dx block:^(id sender, UIButton *yuyin) {
            UIButton* btn=(UIButton*)sender;
            [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        }];
        v.frame=CGRectMake(0, y, SelfViewWidth, 30);
        [self.scroll addSubview:v];
        y+=35;
        
        v=[[HandleView alloc] initWithType:kBtn key:@"弱覆盖三网测试_联通" Value:self.Cover_test_case_lt[@"Name"] tag:bCover_test_case_lt block:^(id sender, UIButton *yuyin) {
            UIButton* btn=(UIButton*)sender;
            [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        }];
        v.frame=CGRectMake(0, y, SelfViewWidth, 30);
        [self.scroll addSubview:v];
        y+=35;

    }
    
    if (self.StartTime==nil) {
        self.StartTime=[self dateToNSString:[NSDate date]];
    }
    v=[[HandleView alloc] initWithType:kBtn key:@"处理时间" Value:self.StartTime tag:dStartTime block:^(id sender, UIButton *yuyin) {
        UIButton* btn=(UIButton*)sender;
        [btn addTarget:self action:@selector(dateClick:) forControlEvents:UIControlEventTouchUpInside];
    }];
    v.frame=CGRectMake(0, y, SelfViewWidth, 30);
    [self.scroll addSubview:v];
    y+=35;
    
    
    v=[[HandleView alloc] initWithType:kTextFeild key:@"处理人" Value:[NSString stringWithFormat:@"%@ %@",GLOBALVALUE.userZhName,GLOBALVALUE.userTelNum] tag:tHandle block:^(id sender, UIButton *yuyin) {
        GDTextField* tf=(GDTextField*)sender;
        tf.delegate=self;
    }];
    v.frame=CGRectMake(0, y, SelfViewWidth, 30);
    [self.scroll addSubview:v];
    y+=35;

    
    UIButton *acceptBtn = [[UIButton alloc]initWithFrame:CGRectMake(SelfViewWidth/5, y, SelfViewWidth*3/5, 30)];
    [acceptBtn setTitle:@"回单" forState:UIControlStateNormal];
    [acceptBtn setBackgroundImage:[UIImage imageNamed:@"operBtn"] forState:UIControlStateNormal];
    acceptBtn.titleLabel.font = [UIFont systemFontOfSize:16.0];
    [acceptBtn addTarget:self action:@selector(submitBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.scroll addSubview:acceptBtn];
    y+=35;

    self.scroll.contentSize = CGSizeMake(SelfViewWidth, y);

}

- (void)updateFormView {//更新流程视图
    for (UIView* aView in self.formFlowView.subviews) {
        [aView removeFromSuperview];
    }
    int yPositon = 5;
    int rightXposition = 100;
    
    UILabel *theStaticLabel = nil;
    
    UILabel *theRightLabel = nil;
    
    for (NSDictionary *Result in self.formFlowArr) {

        NSData *data=[Result[@"Result"] dataUsingEncoding:NSUTF8StringEncoding];
        NSError *error=nil;
        NSArray *arr= [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];

        for (NSDictionary*dic in arr) {
            NSString *left=dic[@"Key"];
            NSString *right=dic[@"Value"];
            NSString* str = [right decodeBase64];
            CGSize size = [str sizeWithFont:TEXTFONT constrainedToSize:CGSizeMake(SelfViewWidth-100, 2000)];

            theStaticLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, yPositon, 90, size.height)];
            theStaticLabel.font = TEXTFONT;
            theStaticLabel.backgroundColor = [UIColor clearColor];
            theStaticLabel.text = [NSString stringWithFormat:@"%@：",left];
            
            theRightLabel = [[UILabel alloc]initWithFrame:CGRectMake(rightXposition, yPositon, SelfViewWidth-100, size.height)];
            theRightLabel.backgroundColor = [UIColor clearColor];
            theRightLabel.font = TEXTFONT;
            theRightLabel.numberOfLines = 0;
            theRightLabel.text = str;
            
            yPositon += size.height+5;
            [self.formFlowView addSubview:theRightLabel];
            [self.formFlowView addSubview:theStaticLabel];

        }
        yPositon+=20;
    }
    self.formFlowView.contentSize = CGSizeMake(320, yPositon);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
