//
//  Longin.m
//  hd
//
//  Created by hongxianyu on 2016/10/21.
//  Copyright © 2016年 com.hxy. All rights reserved.
//

#import "Longin.h"

@implementation Longin
@synthesize in_login_id = _in_login_id;
@synthesize in_login_pwd = _in_login_pwd;

-(id) initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super init]) {
        _in_login_pwd = [aDecoder decodeObjectForKey:@"in_login_pwd"];
        _in_login_id = [aDecoder decodeObjectForKey:@"in_login_id"];
    }
    return self;
}
-(void) encodeWithCoder:(NSCoder *)aCoder{

    [aCoder encodeObject:_in_login_id forKey:@"in_login_id"];
    [aCoder encodeObject:_in_login_pwd forKey:@"in_login_pwd"];
}




@end
