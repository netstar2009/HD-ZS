//
//  HWDatePicker1.h
//  hd
//
//  Created by hongxianyu on 2016/10/24.
//  Copyright © 2016年 com.hxy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class HWDatePicker1;

@protocol HWDatePickerDelegate1 <NSObject>

/**
 *  HWDatePicker确定按钮点击代理事件
 *
 *  @param datePickerView HWDatePicker
 *  @param date           选中的日期
 */
- (void)datePickerView1:(HWDatePicker1 *)datePickerView didClickSureBtnWithSelectDate1:(NSString *)date;



@end

@interface HWDatePicker1 : UIView

@property (nonatomic, weak) id<HWDatePickerDelegate1> delegate1;

- (void)show1;
- (void)dismiss1;
@end