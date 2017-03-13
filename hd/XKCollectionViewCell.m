//
//  XKCollectionViewCell.m
//  CollectionView1
//
//  Created by QiuTu_macbook on 16/5/17.
//  Copyright © 2016年 QiuTu_macbook. All rights reserved.
//

#import "XKCollectionViewCell.h"

@implementation XKCollectionViewCell

- (void)awakeFromNib {
    self.imageView.layer.borderWidth = 3;
    self.imageView.layer.borderColor = [UIColor whiteColor].CGColor;
    self.imageView.layer.cornerRadius = 5;
    self.imageView.clipsToBounds = YES;
    self.imageView.contentMode =  UIViewContentModeScaleAspectFill;
    self.imageView.clipsToBounds  = YES;
    
}


@end
