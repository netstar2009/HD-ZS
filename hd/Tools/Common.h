//
//  Common.h
//  hd
//
//  Created by hongxianyu on 2016/10/18.
//  Copyright © 2016年 com.hxy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface Common : NSObject
@property UIView *view;

-(id)initWithView:(UIView *)view;

-(BOOL)isConnectionAvailable;
@end
