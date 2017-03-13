//
//  UIBarButtonItem+Badge.h
//  hd
//
//  Created by hongxianyu on 2016/11/8.
//  Copyright © 2016年 com.hxy. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <UIKit/UIKit.h>

@interface UIBarButtonItem (Badge)

@property (strong, nonatomic) UILabel *badge;

    // Badge value to be display
@property (nonatomic) NSString *badgeValue;
    // Badge background color
@property (nonatomic) UIColor *badgeBGColor;
    // Badge text color
@property (nonatomic) UIColor *badgeTextColor;
    // Badge font
@property (nonatomic) UIFont *badgeFont;
    // Padding value for the badge
@property (nonatomic) CGFloat badgePadding;
    // Minimum size badge to small
@property (nonatomic) CGFloat badgeMinSize;
    // Values for offseting the badge over the BarButtonItem you picked
@property (nonatomic) CGFloat badgeOriginX;
@property (nonatomic) CGFloat badgeOriginY;
    // In case of numbers, remove the badge when reaching zero
@property BOOL shouldHideBadgeAtZero;
    // Badge has a bounce animation when value changes
@property BOOL shouldAnimateBadge;


@end
