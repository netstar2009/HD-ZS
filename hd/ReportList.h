//
//  ReportList.h
//  hd
//
//  Created by hongxianyu on 2016/10/19.
//  Copyright © 2016年 com.hxy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ReportList : NSObject

    //活动编号
@property(nonatomic,strong)NSString *REPORT_CODE;
    //活动标题
@property(nonatomic,strong)NSString *APPR_TITLE;
    //当前审批状态
@property(nonatomic,strong)NSString *STATUS;
    //照片数量
@property(nonatomic,strong)NSString *PHOTO_COUNT;

@end
