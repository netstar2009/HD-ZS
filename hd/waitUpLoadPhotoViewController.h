//
//  waitUpLoadPhotoViewController.h
//  hd
//
//  Created by hongxianyu on 2016/10/26.
//  Copyright © 2016年 com.hxy. All rights reserved.
//

#import <UIKit/UIKit.h>


#import "MBProgressHUDManager.h"
#import "LxFTPRequest.h"
#import "JGProgressHUD.h"
#import "JGProgressHUDPieIndicatorView.h"
#import "MBProgressHUDManager.h"
#import "AFNetworkReachabilityManager.h"
#import "AFNetworking.h"
#import "Common.h"
#import "AppDelegate.h"
#define kDocument_Folder [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"]
#define mainW [UIScreen mainScreen].bounds.size.width
#define mainH [UIScreen mainScreen].bounds.size.height

@interface waitUpLoadPhotoViewController : UIViewController<UICollectionViewDelegate,UICollectionViewDataSource,UINavigationControllerDelegate>{

MBProgressHUDManager *HUDManager;
    
    NSString *IN_SABEON;
    NSString *IN_REPORT_CODE;
    NSString *IN_PHOTO_NM;
    NSString *IN_P_LONGITUDE;
    NSString *IN_P_LATITUDE;
    NSString *IN_GPSERRORCODE;
    NSString *IN_GPSERRORMSG;
    NSString *PhotoPath;


}
    //<UIImagePickerControllerDelegate, UINavigationControllerDelegate,  UICollectionViewDataSource,UICollectionViewDelegate>
@property(nonatomic,strong)NSString *waituploadReportCode;
@end
