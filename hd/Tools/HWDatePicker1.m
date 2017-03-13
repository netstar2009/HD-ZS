//
//  HWDatePicker1.m
//  hd
//
//  Created by hongxianyu on 2016/10/24.
//  Copyright © 2016年 com.hxy. All rights reserved.
//

#import "HWDatePicker1.h"

    //获得屏幕的宽高
#define mainW [UIScreen mainScreen].bounds.size.width
#define mainH [UIScreen mainScreen].bounds.size.height
@interface HWDatePicker1 ()

@property (nonatomic, strong) UIDatePicker *datePicker;

@end

@implementation HWDatePicker1

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
            //背景色
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width , 250)];
        view.backgroundColor = [UIColor grayColor];
        [self addSubview:view];
            //日期选择器
        _datePicker = [[UIDatePicker alloc] init];
        _datePicker.frame = CGRectMake(0, 0, self.frame.size.width , 120);
        _datePicker.backgroundColor = [UIColor clearColor];
        [_datePicker setDatePickerMode:UIDatePickerModeDate];
        NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
        _datePicker.locale = locale;
        NSDateFormatter *formatter_minDate = [[NSDateFormatter alloc] init];
        [formatter_minDate setDateFormat:@"yyyy-MM-dd"];
        NSDate *minDate = [formatter_minDate dateFromString:@"1900-01-01"];
        formatter_minDate = nil;
        [_datePicker setMinimumDate:minDate];
        [self addSubview:_datePicker];
        
            //确定按钮
        UIButton *sureBtn1 = [[UIButton alloc] initWithFrame:CGRectMake((self.frame.size.width - mainW * 0.36) * 0.5, self.frame.size.height * 0.747, mainW * 0.36, mainW * 0.11)];
        sureBtn1.backgroundColor = [UIColor orangeColor];
        [sureBtn1 setTitle:@"确定" forState:UIControlStateNormal];
        [sureBtn1 addTarget:self action:@selector(sureBtnOnClick1) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:sureBtn1];
    }
    
    return self;
}

- (void)sureBtnOnClick1
{
    [self dismiss1];
    
    if (_delegate1 && [_delegate1 respondsToSelector:@selector(datePickerView1:didClickSureBtnWithSelectDate1:)]) {
        [_delegate1 datePickerView1:self didClickSureBtnWithSelectDate1:[self getDateString]];
    }
}

- (NSString *)getDateString
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *date = [dateFormatter stringFromDate:[self.datePicker date]];
    
    return date;
}

- (void)show1
{
    [UIView animateWithDuration:0.3 animations:^{
        self.frame = CGRectMake(mainW * 0.05, mainH - mainW * 0.75, mainW * 0.9, mainW * 0.5);
    }];
}

- (void)dismiss1
{
    [UIView animateWithDuration:0.3 animations:^{
        self.frame = CGRectMake(mainW * 0.05, mainH, mainW * 0.9, mainW * 0.5);
    }];
}
    // 点击屏幕的时候
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
        // 强制结束所有的编辑(也会调用对应的textFieldDidEndEditing方法)
    [self endEditing:YES];
}

@end