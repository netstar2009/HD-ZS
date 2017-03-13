//
//  HdTableViewCell.h
//  hd
//
//  Created by hongxianyu on 2016/10/18.
//  Copyright © 2016年 com.hxy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HdTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *Number;
@property (weak, nonatomic) IBOutlet UILabel *title;

@property (weak, nonatomic) IBOutlet UILabel *reportCount;

@property (weak, nonatomic) IBOutlet UILabel *photoCount;


@property (weak, nonatomic) IBOutlet UILabel *status;

@end
