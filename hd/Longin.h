//
//  Longin.h
//  hd
//
//  Created by hongxianyu on 2016/10/21.
//  Copyright © 2016年 com.hxy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Longin : NSObject<NSCoding>
@property(nonatomic,strong)NSString *in_login_pwd;

@property(nonatomic,strong)NSString *in_login_id;


//+(Longin *)userWithName:(NSString *)loginid password:(NSString *)loginPwd;

@end
