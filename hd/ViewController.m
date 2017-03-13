//
//  ViewController.m
//  hd
//
//  Created by hongxianyu on 2016/10/17.
//  Copyright © 2016年 com.hxy. All rights reserved.
//

#import "ViewController.h"

#define SCREEN_HEIGHT self.view.frame.size.height
#define SCREEN_WIDTH  self.view.frame.size.width
@interface ViewController ()

@end

@implementation ViewController
NSUserDefaults *userDefaultes;
NSString *result1;

- (void)viewDidLoad {
    [super viewDidLoad];
    [self updateApp];
    if (!userDefaultes) {
        userDefaultes = [NSUserDefaults standardUserDefaults];
    }
    
        //设置背景图片
    UIImage *imageBg=[UIImage imageNamed:@"bg.jpg"];
    self.view.layer.contents=(id)imageBg.CGImage;
    self.view.layer.backgroundColor = [UIColor clearColor].CGColor;
    
    NSDictionary *infoDict = [[NSBundle mainBundle] infoDictionary];
    NSString *myVersion = [infoDict objectForKey:@"CFBundleShortVersionString"];
    self.version.text=[NSString stringWithFormat:@"当前版本: %@",myVersion];

    UIImageView *imageViewUserName=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 20, 20)];
    imageViewUserName.image=[UIImage imageNamed:@"icon_01.png"];
    self.loginId.leftView=imageViewUserName;
    self.loginId.leftViewMode=UITextFieldViewModeAlways; //此处用来设置leftview现实时机
    
    UIImageView *imageViewUserName1=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 20, 20)];
    imageViewUserName1.image=[UIImage imageNamed:@"icon_01_1.png"];
    self.passWord.leftView=imageViewUserName1;
    self.passWord.leftViewMode=UITextFieldViewModeAlways; //此处用来设置leftview现实时机
    
        // 设置导航控制器的代理为self
    self.navigationController.delegate = self;

        // 设置代理为当前视图控制器
    self.loginId.delegate = self;
    self.passWord.delegate = self;
     HUDManager = [[MBProgressHUDManager alloc] initWithView:self.navigationController.view];
}

-(void)updateApp{
    
    NSDictionary *dict = [NSDictionary dictionaryWithContentsOfURL:[NSURL URLWithString:@"https://raw.githubusercontent.com/tangyanbin0951/hd/master/hd.plist"]];
    if (dict) {
        NSArray *list = [dict objectForKey:@"items"];
        NSDictionary *dict2 = [list objectAtIndex:0];
        NSDictionary *dict3 = [dict2 objectForKey:@"metadata"];
        NSString *newVersion = [dict3 objectForKey:@"bundle-version"];
        NSLog(@"新版本%@",newVersion);
        NSDictionary *infoDict = [[NSBundle mainBundle] infoDictionary];
        NSString *myVersion = [infoDict objectForKey:@"CFBundleShortVersionString"];
        NSLog(@"本地版本%@",myVersion);
        
        if ([newVersion compare:myVersion]== NSOrderedDescending) {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"" message:@"本次更新内容：调整优化了页面兼容性！请注意：为了保证您的数据安全，请先将待上传中的照片上传完毕再进行升级更新，详情请见CES公告！" delegate:self cancelButtonTitle:@"立即更新" otherButtonTitles:@"暂不更新", nil];
            [alert show];
        }
    }
}

    //提示框代理
-(void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (buttonIndex == 0) {
        NSLog(@"更新");
        [[UIApplication sharedApplication]openURL:[NSURL URLWithString:@"itms-services://?action=download-manifest&url=https://raw.githubusercontent.com/tangyanbin0951/hd/master/hd.plist"]];
    } else if(buttonIndex == 1){
        NSLog(@"不更新");
    }else{
        
        UIAlertView *alert =[[UIAlertView alloc]initWithTitle:@"提示" message:@"已经是最新版" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        
        [alert show];
    }
}

-(void)viewWillAppear:(BOOL)animated{
    NSData *data = [userDefaultes objectForKey:@"loginInfo"];
    
        //从nsdata对象中恢复EVECTION_LOGIN
    Longin *info = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    
        //记住账号时，界面显示账号密码
    if ([@"0" isEqualToString:[userDefaultes objectForKey:@"remember_state"]]) {
        self.rememberPassword.on = YES;
        
            //保存账号密码
        [self.loginId setText:info.in_login_id];
        [self.passWord setText:info.in_login_pwd];
    }else{
        
        self.rememberPassword.on = NO;
        [self.loginId setText:info.in_login_id];
        [self.passWord setText:@""];
        
    
    }
}

#pragma mark - UINavigationControllerDelegate
    // 将要显示控制器
- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
        // 判断要显示的控制器是否是自己
    BOOL isShowHomePage = [viewController isKindOfClass:[self class]];
    
    [self.navigationController setNavigationBarHidden:isShowHomePage animated:YES];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

    // 点击return的时候
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
        // 强制结束所有的编辑(也会调用对应的textFieldDidEndEditing方法)
    [self.view endEditing:YES];
    return YES;
}

    // 点击屏幕的时候
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
        // 强制结束所有的编辑(也会调用对应的textFieldDidEndEditing方法)
    [self.view endEditing:YES];
}



- (IBAction)logIn:(id)sender {
    [self.view endEditing:YES];
    if([@"" isEqualToString:self.loginId.text]||[@"" isEqualToString:self.passWord.text])
        {
        [HUDManager showMessage:@"请输入用户名或密码" duration:1];
        }
    else{
        Common *common = [[Common alloc] initWithView:self.view];
        if (common.isConnectionAvailable) {
        
//            Longin *loginParm = [[Longin alloc]init];
//            [loginParm setIn_login_id:self.loginId.text];
//            [loginParm setIn_login_pwd:self.passWord.text];
            
                //post提交
            NSDictionary *dic = @{
                                  @"in_login_pwd":self.passWord.text,
                                  @"in_login_id" :self.loginId.text
                                  };
            NSString *string = @"http://118.102.25.56:8080/HM/login/login.do";
            
            [[AFHTTPRequestOperationManager manager] POST:string parameters:dic success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
                NSLog(@"----%@----",string);
                NSLog(@"%@",responseObject);
                NSLog(@"%@",responseObject[@"open_cursor"][0][@"out_RESULT"]);
                
                UserInfo *info = [[UserInfo alloc]init];
                info.pernr = responseObject[@"open_cursor"][0][@"pernr"];
                info.zcesid = responseObject[@"open_cursor"][0][@"zcesid"];
                info.zcespw =responseObject[@"open_cursor"][0][@"zcespw"];
                NSLog(@"%ld,%@",(long)info.out_RESULT,info.pernr);
                
                NSNumber *result = responseObject[@"open_cursor"][0][@"out_RESULT"];
                result1 = result.description;
                
                if ([result1 isEqualToString:@"0"]) {
                    
                        //保存用户信息
                    AppDelegate *delegate = [UIApplication sharedApplication].delegate;
                    delegate.userInfo1 = [[UserInfo alloc]init];
                    [delegate.userInfo1 setPernr:[info pernr]];
                    [delegate.userInfo1 setLogtime:[info logtime]];
                    [delegate.userInfo1 setOut_RESULT:[info out_RESULT]];
                    
                    [HUDManager showMessage:@"登录成功" duration:1 complection:^{
                        if (self.rememberPassword.on) {
                            Longin *info = [[Longin alloc]init];
                            [info setIn_login_id:self.loginId.text];
                            [info setIn_login_pwd:self.passWord.text];
                            
                                //自定义对象归档
                            NSData *data = [NSKeyedArchiver archivedDataWithRootObject:info];
                            [userDefaultes setObject:@"0" forKey:@"remember_state"];
                            [userDefaultes setObject:data forKey:@"loginInfo"];
                                //NSLog(@"%@==---======",data);
                            
                        }else{
                            [userDefaultes removeObjectForKey:@"remember_state"];
                        }
                       [self log];
                        [self performSegueWithIdentifier:@"hd" sender:self];
                        }];
                }else{
                    
                    [HUDManager showMessage:@"用户名或密码不正确!" duration:1];
                }
            } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
                NSLog(@"error:%@----%@",error.localizedFailureReason,error.localizedDescription);
                [HUDManager showMessage:@"网络或服务器错误,请稍候..." duration:2];
            }];
        }

        }
    
 }
-(void)log{
    
    Common *common=[[Common alloc] initWithView:self.view];
    if (common.isConnectionAvailable) {
        
        
        AppDelegate *delegate = [UIApplication sharedApplication].delegate;
        NSLog(@"%@",delegate.userInfo1.pernr);
        NSString *identifierForVendor = [[UIDevice currentDevice].identifierForVendor UUIDString];
        NSLog(@"%@",identifierForVendor);
        
        NSDictionary *infoDict = [[NSBundle mainBundle]infoDictionary];
        NSString *Version = [infoDict objectForKey:@"CFBundleShortVersionString"];
        
        NSDictionary *dic = @{
                              @"IN_SABEON":delegate.userInfo1.pernr,
                              @"IN_IMEI_CODE":identifierForVendor,
                              @"IN_VERSION" :Version,
                              @"IN_COMPANY":@"HD",
                              };
        NSString *string = @"http://118.102.25.56:8080/HM/login/log.do";
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        [manager POST:string parameters:dic success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
            NSString *result = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
            NSLog(@"s----%@----",result);
            NSLog(@"%@",[self objectFromJSONString:result]);
           NSNumber *b = [self objectFromJSONString:result][@"open_cursor"][0][@"OUT_RESULT"];
            NSLog(@"%@",b);
            NSString *a = b.description;
            if ([a isEqualToString:@"0"]) {
                NSLog(@"添加成功");
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSLog(@"e---%@----",error);
        }];
        
    }
}
- (id)objectFromJSONString:(NSString *)jsonString
{
    if(!jsonString || jsonString.length <= 0){
        return nil;
    }
    NSError * error = nil;
    NSData * data = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    return dic;
}

@end
    