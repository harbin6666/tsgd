//
//  SearchVC.m
//  tsgd
//
//  Created by yuan jun on 15/1/15.
//  Copyright (c) 2015年 new. All rights reserved.
//

#import "SearchVC.h"
#import "RBCustomDatePickerView.h"
#import "PhoneViewPoper.h"
#import "TodoVC.h"
@interface SearchVC ()<PhoneViewPoperDelegate,UITextFieldDelegate>
@property(nonatomic,strong)NSString *formTit,*formNo;
@property(nonatomic,strong) PhoneViewPoper *viewPoper;
@property(nonatomic,strong) RBCustomDatePickerView *datePicker;
@property(nonatomic,weak)UIButton*startBtn,*endBtn;
@property(nonatomic,strong)UITextField*titTf,*noTf;
@end

@implementation SearchVC

- (void)viewDidLoad {
    [super viewDidLoad];
    float y=10;
    [self setLeftBtnImage:nil highLightImage:nil];

    // Do any additional setup after loading the view.
    HandleView *hand=[[HandleView alloc] initWithType:kBtn key:@"开始时间" Value:self.startDate tag:1 block:^(id sender, UIButton *yuyin) {
        self.startBtn=(UIButton*)sender;
        [self.startBtn addTarget:self action:@selector(dateClick:) forControlEvents:UIControlEventTouchUpInside];
    }];
    hand.frame=CGRectMake(0, y, SelfViewWidth, 30);
    [self.view addSubview:hand];
    y+=35;

    hand=[[HandleView alloc] initWithType:kBtn key:@"结束时间" Value:self.endDate tag:2 block:^(id sender, UIButton *yuyin) {
        self.endBtn=(UIButton*)sender;
        [self.endBtn addTarget:self action:@selector(dateClick:) forControlEvents:UIControlEventTouchUpInside];
    }];
    hand.frame=CGRectMake(0, y, SelfViewWidth, 30);
    [self.view addSubview:hand];
    y+=35;

    hand=[[HandleView alloc] initWithType:kTextFeild key:@"工单编号" Value:self.formNo tag:1 block:^(id sender, UIButton *yuyin) {
        self.noTf=(UITextField*)sender;
        self.noTf.delegate=self;
    }];
    hand.frame=CGRectMake(0, y, SelfViewWidth, 30);
    [self.view addSubview:hand];
    y+=35;

    hand=[[HandleView alloc] initWithType:kTextFeild key:@"工单主题" Value:self.formTit tag:2 block:^(id sender, UIButton *yuyin) {
        self.titTf=(UITextField*)sender;
        self.titTf.delegate=self;
    }];
    hand.frame=CGRectMake(0, y, SelfViewWidth, 30);
    [self.view addSubview:hand];
    y+=35;
    
    UIButton *acceptBtn = [[UIButton alloc]initWithFrame:CGRectMake(SelfViewWidth/5, y, SelfViewWidth*3/5, 30)];
    [acceptBtn setTitle:@"查询" forState:UIControlStateNormal];
    [acceptBtn setBackgroundImage:[UIImage imageNamed:@"operBtn"] forState:UIControlStateNormal];
    acceptBtn.titleLabel.font = [UIFont systemFontOfSize:16.0];
    [acceptBtn addTarget:self action:@selector(queryclick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:acceptBtn];
    y+=35;

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

-(void)queryclick:(id)sendr{
    [self closeKeyBoard];
    TodoVC *searchresult=[[TodoVC alloc] init];
    NSMutableDictionary*parm=[NSMutableDictionary dictionary];
    [parm setSafeObject:self.formTit forKey:@"FormTitle"];
    [parm setSafeObject:self.formNo forKey:@"FormNo"];
    [parm setSafeObject:self.startDate forKey:@"StartTime"];
    [parm setSafeObject:self.endDate forKey:@"EndTime"];
    searchresult.searchParam=parm;
    [self.navigationController pushViewController:searchresult animated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark delegate

-(void)closeKeyBoard{
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
    if (textField.tag==1) {
        self.formNo=textField.text;
    }else{
        self.formTit=textField.text;
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
    if (self.viewPoper.pickerView.tag==1) {
        self.startDate=[self dateToNSString:self.datePicker.date];
        [self.startBtn setTitle:self.startDate forState:UIControlStateNormal];
    }else{
        self.endDate=[self dateToNSString:self.datePicker.date];
        [self.endBtn setTitle:self.endDate forState:UIControlStateNormal];
    }

}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
