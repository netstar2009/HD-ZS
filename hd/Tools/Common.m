//
//  Common.m
//  hd
//
//  Created by hongxianyu on 2016/10/18.
//  Copyright © 2016年 com.hxy. All rights reserved.
//

#import "Common.h"
#import "Reachability.h"
#import "MBProgressHUDManager.h"
@implementation Common
-(id)initWithView:(UIView *)view{

    if (self = [super init]) {
        self.view = view;
    }
    return self;
}

-(BOOL) isConnectionAvailable{
    
    BOOL isExistenceNetwork = YES;
    Reachability *reachability = [Reachability reachabilityWithHostName:@"www.apple.com"];
    switch ([reachability currentReachabilityStatus]) {
        case NotReachable:
            isExistenceNetwork = NO;
            break;
        case ReachableViaWiFi:
            isExistenceNetwork = YES;
            break;
        case ReachableViaWWAN:
            isExistenceNetwork = YES;
            break;
        default:
            break;
    }
    if (!isExistenceNetwork) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.removeFromSuperViewOnHide =YES;
        hud.mode = MBProgressHUDModeText;
        hud.labelText = NSLocalizedString(@"当前网络不可用,请检查网络连接!", nil);
        
        [hud hide:YES afterDelay:2];
        return NO;

    }
    return isExistenceNetwork;

}
@end
