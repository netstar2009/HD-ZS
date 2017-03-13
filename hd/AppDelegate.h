//
//  AppDelegate.h
//  hd
//
//  Created by hongxianyu on 2016/10/17.
//  Copyright © 2016年 com.hxy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "userInfo.h"
@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

    //全局变量 登入的返回结果
@property UserInfo *userInfo1;

@end

