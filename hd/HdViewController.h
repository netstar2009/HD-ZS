//
//  HdViewController.h
//  hd
//
//  Created by hongxianyu on 2016/10/18.
//  Copyright © 2016年 com.hxy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HdTableViewCell.h"
#import "ReportList.h"
#import "AFNetworkReachabilityManager.h"
#import "AFNetworking.h"
#import "HWDatePicker.h" 
#import "HWDatePicker1.h"
#import "ViewController.h"
#import "MBProgressHUDManager.h"
#import "AppDelegate.h"
#import "Common.h"


#define mainW [UIScreen mainScreen].bounds.size.width
#define mainH [UIScreen mainScreen].bounds.size.height

#define iOS7Later ([UIDevice currentDevice].systemVersion.floatValue >= 7.0f)
#define iOS8Later ([UIDevice currentDevice].systemVersion.floatValue >= 8.0f)
#define iOS9Later ([UIDevice currentDevice].systemVersion.floatValue >= 9.0f)
#define iOS9_1Later ([UIDevice currentDevice].systemVersion.floatValue >= 9.1f)

@interface HdViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,HWDatePickerDelegate,HWDatePickerDelegate1>
{
MBProgressHUDManager *HUDManager;
   
}



@property (nonatomic, weak) HWDatePicker *datePicker;
@property (nonatomic, weak) HWDatePicker1 *datePicker1;
@property (nonatomic, strong) UITextField *startDate;
@property (nonatomic, strong) UITextField *endDate;

@end
