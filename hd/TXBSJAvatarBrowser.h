//
//  TXBSJAvatarBrowser.h
//  TXB
//
//  Created by QiuTu_macbook on 16/4/9.
//  Copyright © 2016年 QiuTu_macbook. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface TXBSJAvatarBrowser : NSObject
/**
 *  @brief  浏览本地图片
 *
 *  @param  oldImageView    图片所在的imageView
 */
+(void)showImage:(UIImageView*)avatarImageView;

/**
 * 浏览网络图片
 */
+(void)showImageWithUrl:(NSString*)imageUrl imageView:(UIImageView*)avatarImageView;

@end
