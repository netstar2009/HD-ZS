//
//  HdDetailViewController.h
//  hd
//
//  Created by hongxianyu on 2016/10/20.
//  Copyright © 2016年 com.hxy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DetailReport.h"
#import "HdDetailTableViewCell.h"
#import "AFNetworkReachabilityManager.h"
#import "AFNetworking.h"
#import "Common.h"
#import "PhotoDetailViewController.h"
#import "UploadViewController.h"
#import "waitUpLoadPhotoViewController.h"

#import "UIBarButtonItem+Badge.h"
#define mainW [UIScreen mainScreen].bounds.size.width
#define mainH [UIScreen mainScreen].bounds.size.height
@interface HdDetailViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)NSString *reportcode;

@property(nonatomic,strong)NSString *reportCode;//上传照片code
@property(nonatomic,strong)NSString *PhotoDetailReportCode;//查看照片code
@property(nonatomic,strong)NSString *waitUploadReportCode;//待上传code
@end
