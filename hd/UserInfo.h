//
//  UserInfo.h
//  hd
//
//  Created by hongxianyu on 2016/10/26.
//  Copyright © 2016年 com.hxy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserInfo : NSObject
    //id
@property(nonatomic,strong)NSString *zcesid;
    //密码
@property(nonatomic,strong)NSString *zcespw;
    //部门名称
@property(nonatomic,strong)NSString *orgtx;
    //联系电话
@property(nonatomic,strong)NSString *ztelnr2;
    //状态信息，成功；失败
@property(nonatomic,strong)NSString *out_RESULT_NM;
    //部门代码
@property(nonatomic,strong)NSString *orgeh;
    //登陆日期
@property(nonatomic,strong)NSString *logtime;
    //职位代码
@property(nonatomic,strong)NSString *ztitel;
    //员工代码
@property(nonatomic,strong)NSString *pernr;
    //状态码，0,1
@property(nonatomic)NSInteger *out_RESULT;


@end
