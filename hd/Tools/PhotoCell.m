//
//  PhotoCell.m
//  hd
//
//  Created by hongxianyu on 2016/10/26.
//  Copyright © 2016年 com.hxy. All rights reserved.
//

#import "PhotoCell.h"
#import "UploadViewController.h"
#import <AssetsLibrary/AssetsLibrary.h>
@interface PhotoCell()

@end

@implementation PhotoCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
            // Create a image view
        self.backgroundColor = [UIColor clearColor];
        [self imageView];
        
    }
    
    return self;
}

//- (void)setAsset:(JKAssets *)asset{
//    if (_asset != asset) {
//        _asset = asset;
//        
//        ALAssetsLibrary   *lib = [[ALAssetsLibrary alloc] init];
//        [lib assetForURL:_asset.assetPropertyURL resultBlock:^(ALAsset *asset) {
//            if (asset) {
//                self.imageView.image = [UIImage imageWithCGImage:[[asset defaultRepresentation] fullScreenImage]];
//            }
//        } failureBlock:^(NSError *error) {
//            
//        }];
//    }
//}
- (UIImageView *)imageView{
    if (!_imageView) {
        _imageView = [[UIImageView alloc] initWithFrame:self.contentView.bounds];
        _imageView.backgroundColor = [UIColor clearColor];
        _imageView.clipsToBounds = YES;
        _imageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _imageView.layer.cornerRadius = 0.0f;
        _imageView.layer.borderColor = [UIColor grayColor].CGColor;
        _imageView.layer.borderWidth = 0.5;
        [self.contentView addSubview:_imageView];
    }
    return _imageView;
}

@end

