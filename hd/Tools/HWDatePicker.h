//
//  HWDatePicker.h
//  hd
//
//  Created by hongxianyu on 2016/10/24.
//  Copyright © 2016年 com.hxy. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HWDatePicker;

@protocol HWDatePickerDelegate <NSObject>

/**
 *  HWDatePicker确定按钮点击代理事件
 *
 *  @param datePickerView HWDatePicker
 *  @param date           选中的日期
 */
- (void)datePickerView:(HWDatePicker *)datePickerView didClickSureBtnWithSelectDate:(NSString *)date;



@end

@interface HWDatePicker : UIView

@property (nonatomic, weak) id<HWDatePickerDelegate> delegate;

- (void)show;
- (void)dismiss;
@end