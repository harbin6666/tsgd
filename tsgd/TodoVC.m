//
//  TodoVC.m
//  tsgd
//
//  Created by yuan jun on 15/1/15.
//  Copyright (c) 2015年 new. All rights reserved.
//

#import "TodoVC.h"
#import "GDInfoVC.h"
#import "GDLoginVC.h"
@interface TodoVC ()<GDListPageOperationDelegate,UITableViewDataSource,UITableViewDelegate>
@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)GDListPageOperationView*operationView;

@end

@implementation TodoVC

- (void)viewDidLoad {
    [super viewDidLoad];

    if (self.searchParam) {
    }else{
        [self setLeftBtnImage:nil highLightImage:nil];
        GDLoginVC *loginVC = [[GDLoginVC alloc]init];
        [self presentViewController:loginVC animated:NO completion:^{
            //
        }];

    }
    self.tableView=[[UITableView  alloc] initWithFrame:CGRectMake(0, 0, SelfViewWidth, SelfViewHeight-50) style:UITableViewStylePlain];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.backgroundColor = [UIColor clearColor];
    [_tableView registerClass:[GDCommonRootTVC class] forCellReuseIdentifier:@"waittodotvc"];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.translatesAutoresizingMaskIntoConstraints=NO;
    [self.view addSubview:self.tableView];

    self.operationView = [[GDListPageOperationView alloc]initWithFrame:CGRectMake(0, SelfViewHeight-50, SelfViewWidth, 50)];
    self.operationView.delegate = self;
    [self.view addSubview:self.operationView];

//    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_tableView attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeading multiplier:1 constant:1]];
//    
//    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_tableView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1 constant:1]];

    
//    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[_operationView(==50)]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_operationView)]];
//    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[_tableView]-(>=50)-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_tableView)]];
//
//    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[_tableView]-(==0)-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_tableView)]];
//    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[_operationView]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_operationView)]];

//    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
//    [dateFormatter setDateFormat:@"yyyy-MM-dd hh:mm:ss"];
//    self.startDate = [dateFormatter stringFromDate:[NSDate dateWithTimeIntervalSinceNow:-8*60*60]];
//    self.endDate = [dateFormatter stringFromDate:[NSDate date]];
    self.currentPageIndex = 1;
    self.dataArr = [NSMutableArray array];

}
- (void)viewWillAppear:(BOOL)animated {
    [self getData];
    
}

-(void)getClientStatus{
    if (GLOBALVALUE.userZhName==nil||[GLOBALVALUE.userZhName isEqualToString:@""]) {
        return;
    }
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    
    [GDService requestFunc:@"get_client_status" WithParam:dic withCompletBlcok:^(id reObj,NSError* error) {
        if ([reObj isKindOfClass:[NSDictionary class]]) {
            if ([reObj[@"Result"] integerValue]==0) {
                GLOBALVALUE.userZhName=nil;
                GLOBALVALUE.userZhName =@"";
                GDLoginVC *loginVC = [[GDLoginVC alloc]init];
                [self presentViewController:loginVC animated:NO completion:^{
                    //
                }];
            }
        }
    }];
}

- (void)getData{
    [self getClientStatus];
    if (GLOBALVALUE.userZhName==nil||[GLOBALVALUE.userZhName isEqualToString:@""]) {
        return;
    }
    NSNumber *startNo = __INT(1+(self.currentPageIndex-1)*5);
    NSNumber *endNo = __INT(startNo.intValue+4);
    if (endNo.intValue >= self.operationView.totalNum && self.operationView.totalNum > 0) {
        endNo = __INT(self.operationView.totalNum);
    }
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setSafeObject:__INT(1) forKey:@"FormState"];
    [dic setSafeObject:__INT(1) forKey:@"FormStateType"];
    [dic setSafeObject:GLOBALVALUE.loginedUserName forKey:@"Dealor"];
    [dic setSafeObject:self.startDate forKey:@"StartTime"];
    [dic setSafeObject:self.endDate forKey:@"EndTime"];
    [dic setSafeObject:startNo forKey:@"StartNo"];
    [dic setSafeObject:endNo forKey:@"EndNo"];
    [dic setSafeObject:@(-1) forKey:@"NetType"];
    [dic setSafeObject:@(-1) forKey:@"Subject"];
    [dic setSafeObject:@"" forKey:@"FormNo"];
    [dic setSafeObject:@"" forKey:@"FormTitle"];
    if (self.searchParam) {
        [dic addEntriesFromDictionary:self.searchParam];
        [dic setSafeObject:@(3) forKey:@"FormState"];
    }
    if (GLOBALVALUE.targetType==kTs) {
        [dic setSafeObject:@0 forKey:@"FlagWide"];
    }else if (GLOBALVALUE.targetType==kKd){
        [dic setSafeObject:@1 forKey:@"FlagWide"];
    }else{
        
    }
    if (GLOBALVALUE.loginedUserName!=nil) {
        [dic setObject:GLOBALVALUE.loginedUserName forKey:@"Dealor"];
    }
    
    
    [self showLoading];
    [GDService requestFunc:@"get_form_list" WithParam:dic withCompletBlcok:^(id reObj,NSError* error) {
        [self hideLoading];
        if ([reObj isKindOfClass:[NSArray class]]) {
            // 正常返回
            self.dataArr = reObj;
            if (self.dataArr.count > 0 && startNo.intValue == 1) {  // 加载第一页的时候初始化获取总数据
                NSMutableDictionary* dic = [self.dataArr safeObjectAtIndex:0];
                NSNumber *totalCount = [dic objectForKey:@"Count"];
                self.operationView.totalNum = totalCount.intValue;
            }
            [self.operationView updateWithCurrentPage:self.currentPageIndex];
            [self.tableView reloadData];
        }
    }];
}
#pragma mark delegate
- (void)GDListPage:(GDListPageOperationView*)listPage operationAction:(GDListPageOperationTypeTag)tag {
    int totalPage = ceil(listPage.totalNum/5.0);
    self.currentPageIndex = listPage.currentPageIndex;
    switch (tag) {
        case GDListPageOperationType_firstPage:
            self.currentPageIndex = 1;
            break;
        case GDListPageOperationType_formerPage: {
            self.currentPageIndex = self.currentPageIndex-1>=1 ? self.currentPageIndex-1 : 1;
            break;
        }
        case GDListPageOperationType_nextPage: {
            self.currentPageIndex = self.currentPageIndex+1<=totalPage ? self.currentPageIndex+1 : totalPage;
            break;
        }
        case GDListPageOperationType_lastPage: {
            self.currentPageIndex = totalPage;
            break;
        }
        default:
            break;
    }
    self.currentPageIndex = self.currentPageIndex >= 1 ? self.currentPageIndex : 1;
    [self getData];
}

#pragma mark - tableview delegate/datasource -
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArr.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    GDCommonRootTVC *cell = [tableView dequeueReusableCellWithIdentifier:@"waittodotvc" forIndexPath:indexPath];
    
//    GDCommonRootTVC *cell = [tableView dequeueReusableCellWithIdentifier:@"waittodotvc"];
    if (!cell) {
        cell = [[GDCommonRootTVC alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"waittodotvc"];
    }
    
    NSMutableDictionary *dic = [self.dataArr safeObjectAtIndex:indexPath.row];
    [cell updateWithDic:dic];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 80;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSMutableDictionary *dic = [self.dataArr safeObjectAtIndex:indexPath.row];
    
    GDInfoVC *info=[[GDInfoVC alloc] init];
    info.queryObj=dic;
    if (self.searchParam==nil) {
        info.isTodo=YES;
    }
    info.hidesBottomBarWhenPushed=YES;
    [self.navigationController pushViewController:info animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
