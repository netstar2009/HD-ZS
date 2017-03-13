//
//  PhotoDetailViewController.h
//  hd
//
//  Created by hongxianyu on 2016/10/26.
//  Copyright © 2016年 com.hxy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Common.h"
#import "AFNetworkReachabilityManager.h"
#import "AFNetworking.h"
#import "PhtotPath.h"
#import "MBProgressHUDManager.h"
#define mainW [UIScreen mainScreen].bounds.size.width
#define mainH [UIScreen mainScreen].bounds.size.height



@interface PhotoDetailViewController : UIViewController<UICollectionViewDataSource, UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>
{
MBProgressHUDManager *HUDManager;

}

@property(nonatomic,strong)NSString *phtotDetailRrportCode;
@property(nonatomic,strong)UICollectionView *collectionView;
@end
