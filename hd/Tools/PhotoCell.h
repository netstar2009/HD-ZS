//
//  PhotoCell.h
//  hd
//
//  Created by hongxianyu on 2016/10/26.
//  Copyright © 2016年 com.hxy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JKAssets.h"

@interface PhotoCell : UICollectionViewCell
@property (nonatomic, strong) JKAssets  *asset;
@property (nonatomic, strong)UIImageView *imageView;
@end
