//
//  UploadViewController.h
//  hd
//
//  Created by hongxianyu on 2016/10/26.
//  Copyright © 2016年 com.hxy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <BaiduMapAPI_Base/BMKBaseComponent.h>//引入base相关所有的头文件
#import <BaiduMapAPI_Location/BMKLocationComponent.h>
#import "PhotoCell.h"
#import "JKImagePickerController.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "MBProgressHUDManager.h"
#import "LxFTPRequest.h"
#import "JGProgressHUD.h"
#import "JGProgressHUDPieIndicatorView.h"
#import "MBProgressHUDManager.h"
#import "AFNetworkReachabilityManager.h"
#import "AFNetworking.h"
#import "Common.h"
#import "ViewController.h"
#import "HdViewController.h"
#import "Date.h"
#import "HdDetailViewController.h"
#define kDocument_Folder [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"]
#define mainW [UIScreen mainScreen].bounds.size.width
#define mainH [UIScreen mainScreen].bounds.size.height

#define iOS7Later ([UIDevice currentDevice].systemVersion.floatValue >= 7.0f)
#define iOS8Later ([UIDevice currentDevice].systemVersion.floatValue >= 8.0f)
#define iOS9Later ([UIDevice currentDevice].systemVersion.floatValue >= 9.0f)
#define iOS9_1Later ([UIDevice currentDevice].systemVersion.floatValue >= 9.1f)


@protocol PassTrendValueDelegate12

-(void)passTrendValues:(UIImage *)values;//1.1定义协议与方法

@end


@interface UploadViewController : UIViewController<BMKLocationServiceDelegate,UIImagePickerControllerDelegate, UINavigationControllerDelegate,  UICollectionViewDataSource,UICollectionViewDelegate>{
    
MBProgressHUDManager *HUDManager;
}
    ///1.定义向趋势页面传值的委托变量
@property (retain,nonatomic) id <PassTrendValueDelegate12> trendDelegate;
@property (nonatomic,strong) NSString *UploadReportcode;
@end
