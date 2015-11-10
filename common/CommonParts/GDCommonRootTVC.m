//
//  GDCommonRootTVC.m
//  gongdanApp
//
//  Created by 薛翔 on 14-2-23.
//  Copyright (c) 2014年 xuexiang. All rights reserved.
//

#import "GDCommonRootTVC.h"
@interface GDCommonRootTVC ()
@property(nonatomic, strong)UILabel *themeLabel;
@property(nonatomic, strong)UILabel *codeLabel;
@property(nonatomic, strong)UILabel *timeLabel;

@property(nonatomic, strong)UIImageView *stateImgV;
@end

@implementation GDCommonRootTVC

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor redColor];
        self.backgroundView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"normalCell_bg"]];
        
        self.stateImgV = [[UIImageView alloc]initWithFrame:CGRectMake(10, 8, 64, 64)];
        [self.stateImgV setImage:[UIImage imageNamed:@"form_normal"]];
        [self.contentView addSubview:_stateImgV];
        
        self.codeLabel = [[UILabel alloc]initWithFrame:CGRectMake(80, 10, self.frame.size.width-90, 20)];
        self.codeLabel.backgroundColor = [UIColor clearColor];
        self.codeLabel.text = @"";
        self.codeLabel.font = [UIFont systemFontOfSize:15.0];
        [self.contentView addSubview:_codeLabel];
        
        self.themeLabel = [[UILabel alloc]initWithFrame:CGRectMake(80, 32, self.frame.size.width-90, 20)];
        self.themeLabel.backgroundColor = [UIColor clearColor];
        self.themeLabel.text = @"";
        self.themeLabel.font = [UIFont systemFontOfSize:15.0];
        [self.contentView addSubview:_themeLabel];
        
        self.timeLabel = [[UILabel alloc]initWithFrame:CGRectMake(80, 54, self.frame.size.width-90, 20)];
        self.timeLabel.backgroundColor = [UIColor clearColor];
        self.timeLabel.text = @"";
        self.timeLabel.font = [UIFont systemFontOfSize:15.0];
        [self.contentView addSubview:_timeLabel];
        
//        self.codeLabel.translatesAutoresizingMaskIntoConstraints=NO;
//        self.themeLabel.translatesAutoresizingMaskIntoConstraints=NO;
//        self.timeLabel.translatesAutoresizingMaskIntoConstraints=NO;
        
//        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-10-[_codeLabel(==20)]-(>=0)-[_themeLabel(==20)]-(>=0)-[_timeLabel(==20)]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_codeLabel,_timeLabel,_themeLabel)]];
//        
//        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-80-[_codeLabel]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_codeLabel)]];
//        
//        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-80-[_themeLabel]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_themeLabel)]];
//
//        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-80-[_timeLabel]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_timeLabel)]];

//        [self addConstraint:[NSLayoutConstraint constraintWithItem:_currentPageLabel attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
//        [self addConstraint:[NSLayoutConstraint constraintWithItem:_totalNumLabel attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];


    }
    return self;
}

- (NSArray*)getTheShowInfoWithDic:(NSMutableDictionary*)dic {
    NSString *resultStr = [dic objectForKey:@"Result"];
    NSArray *arr = [resultStr componentsSeparatedByString:@"\n"];
    return arr;
}


- (void)updateWithDic:(NSMutableDictionary*)dic {
    NSString *Result=[dic objectForKey:@"Result"];
    Result=[Result stringByReplacingOccurrencesOfString:@"\r" withString:@""];
    Result=[Result stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    Result=[Result stringByReplacingOccurrencesOfString:@"\t" withString:@""];
    NSData *data=[Result dataUsingEncoding:NSUTF8StringEncoding];
    NSError *error=nil;
    NSArray *arr= [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    if (arr==nil) {
        arr = [self getTheShowInfoWithDic:dic];
        
        NSString *codeRangeStr = @"编号";
        NSString *timeRangeStr = @"时限";
        NSString *titleRangeStr = @"主题";
        for (int i=0; i<3; i++) {
            NSString *str = [arr objectAtIndex:i];
            NSRange range1 = [str rangeOfString:codeRangeStr];
            NSRange range2 = [str rangeOfString:titleRangeStr];
            NSRange range3 = [str rangeOfString:timeRangeStr];
            
            if (range1.location != NSNotFound) {
                self.codeLabel.text = str;
            }else if (range2.location != NSNotFound) {
                self.themeLabel.text = str;
            }else if (range3.location != NSNotFound) {
                self.timeLabel.text = str;
            }
        }

    }else{//代办工单
        for (NSDictionary* dic in arr) {
            if ([dic[@"Key"] isEqualToString:@"工单编号"]) {
                self.codeLabel.text=[dic[@"Value"] decodeBase64];
            }
            if ([dic[@"Key"] isEqualToString:@"工单主题"]) {
                self.themeLabel.text=[dic[@"Value"] decodeBase64];
            }
            if ([dic[@"Key"] isEqualToString:@"处理时限"]) {
                self.timeLabel.text=[dic[@"Value"] decodeBase64];
            }
            
        }
        //超时状态（0:正常，1：将要超时的工单:2：已经超时的工单）
        NSNumber *outTimeStatus=[dic objectForKey:@"OutTimeStatus"];
        if (outTimeStatus) {
            if (outTimeStatus.intValue!=0) {
                self.codeLabel.textColor=[UIColor redColor];
                self.themeLabel.textColor=[UIColor redColor];
                self.timeLabel.textColor=[UIColor redColor];
            }else{
                self.codeLabel.textColor=[UIColor blackColor];
                self.themeLabel.textColor=[UIColor blackColor];
                self.timeLabel.textColor=[UIColor blackColor];
                
            }
        }
    }
    
    
    NSNumber* status = [dic objectForKey:@"FormStatus"];
    switch (status.intValue) {
        case 1:
            [self.stateImgV setImage:[UIImage imageNamed:@"form_temp"]];
            break;
        case 2:
            [self.stateImgV setImage:[UIImage imageNamed:@"form_notAccept"]];
            break;
        case 3:
            [self.stateImgV setImage:[UIImage imageNamed:@"form_accept"]];
            break;
        case 4:
            [self.stateImgV setImage:[UIImage imageNamed:@"form_checking"]];
            break;
        case 7:
            [self.stateImgV setImage:[UIImage imageNamed:@"form_force"]];
            break;
        default:
            [self.stateImgV setImage:[UIImage imageNamed:@"form_normal"]];
            break;
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
