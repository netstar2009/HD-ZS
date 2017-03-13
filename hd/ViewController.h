//
//  ViewController.h
//  hd
//
//  Created by hongxianyu on 2016/10/17.
//  Copyright © 2016年 com.hxy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUDManager.h"
#import "AFNetworking.h"
#import "UserInfo.h"
#import "AppDelegate.h"
#import "Longin.h"
#import "AFHTTPSessionManager.h"
#import "AFNetworkReachabilityManager.h"
#import "Common.h"

@interface ViewController : UIViewController<UITextFieldDelegate,UINavigationControllerDelegate>{

    MBProgressHUDManager *HUDManager;

}

@property (weak, nonatomic) IBOutlet UITextField *loginId;

@property (weak, nonatomic) IBOutlet UITextField *passWord;
- (IBAction)logIn:(id)sender;

@property (weak, nonatomic) IBOutlet UILabel *version;
@property (weak, nonatomic) IBOutlet UISwitch *rememberPassword;


@end

