//
//  HdViewController.m
//  hd
//
//  Created by hongxianyu on 2016/10/18.
//  Copyright © 2016年 com.hxy. All rights reserved.
//

#import "HdViewController.h"
#import "MJRefresh.h"
#import <AVFoundation/AVCaptureDevice.h>
#import <AVFoundation/AVMediaFormat.h>
#import "UIView+SDAutoLayout.h"
@interface HdViewController (){

    NSString *startDate1;
    NSString *endDate1;
    NSMutableArray *reportList;
    UITableView   *tableView1;
    NSString *reportcode;
    UITextField *numebrFiled;
    
    UIButton *searchButton;
//    NSString *pernr1;
    }


@end

@implementation HdViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    reportList = [[NSMutableArray alloc]init];
    tableView1=[[UITableView alloc] initWithFrame:CGRectMake(0, 140,mainW, mainH - 202)];
    tableView1.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:tableView1];
        //tableView1.backgroundColor = [UIColor grayColor];
    tableView1.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView1.dataSource=self;
    tableView1.delegate=self;
    
//    AppDelegate *delegate = [UIApplication sharedApplication].delegate;
//    NSLog(@"%ld",(long)delegate.userInfo1.out_RESULT);
//    pernr1 = delegate.userInfo1.pernr;
    
    numebrFiled.delegate = self;
    HUDManager = [[MBProgressHUDManager alloc] initWithView:self.navigationController.view];
    [self createUI];
    Common *common=[[Common alloc] initWithView:self.view];
    if (common.isConnectionAvailable) {
    __weak __typeof(self) weakSelf = self;
    
        // 设置回调（一旦进入刷新状态就会调用这个refreshingBlock）
  tableView1.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        [weakSelf getReports];
    }];
    
        // 马上进入刷新状态
    [tableView1.mj_header beginRefreshing];
    }else{
    
         [tableView1.mj_header endRefreshing];
    }
}

-(void)createUI{
    
        //时间选择器
    HWDatePicker *dataPicker = [[HWDatePicker alloc] initWithFrame:CGRectMake(mainW * 0.05, mainH, mainW * 0.9, mainW * 0.5)];
    dataPicker.delegate = self;
    [self.view addSubview:dataPicker];
    self.datePicker = dataPicker;
    
        //时间选择器1
    HWDatePicker1 *dataPicker1 = [[HWDatePicker1 alloc] initWithFrame:CGRectMake(mainW * 0.05, mainH, mainW * 0.9, mainW * 0.5)];
    dataPicker1.delegate1 = self;
    [self.view addSubview:dataPicker1];
    self.datePicker1 = dataPicker1;
    
    NSDate *date = [NSDate date];
    NSDateFormatter *fmt=[[NSDateFormatter alloc] init];
    fmt.dateFormat=@"yyyy-MM-dd";
        //开始日期
    NSTimeInterval secondsPerDay1 = 24*60*60*7;
    NSDate *now = [NSDate date];
    NSDate *lastWeek = [now dateByAddingTimeInterval:-secondsPerDay1];
    
        // UILabel *startDate = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 90, 40)];
        //UILabel *startDate = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, mainW * 0.3, mainW * 0.15)];
    UILabel *startDate = [[UILabel alloc]init];
            startDate.text = @"开始日期:";
            [self.view addSubview:startDate];

                //_startDate = [[UITextField alloc]initWithFrame:CGRectMake(90, 0, 100, 40)];
                //_startDate = [[UITextField alloc]initWithFrame:CGRectMake(mainW * 0.3, 0, mainW * 0.35, mainW * 0.15)];
    _startDate = [[UITextField alloc]init];
         _startDate.delegate = self;
            _startDate.text = [fmt stringFromDate:lastWeek];
            [self.view addSubview:_startDate];
    
    startDate.sd_layout
    .leftSpaceToView(self.view,0)
    .topSpaceToView(self.view,5)
    .widthIs(80)
    .heightIs(40);
    
    _startDate.sd_layout
    .leftSpaceToView(startDate,10)
    .topSpaceToView(self.view,5)
    .widthIs(100)
    .heightIs(40);
    
    
                //结束日期
                //UILabel *endDate = [[UILabel alloc]initWithFrame:CGRectMake(0, mainW * 0.15, mainW * 0.3, mainW * 0.15)];
          UILabel *endDate = [[UILabel alloc]init];
            endDate.text = @"结束日期:";
            [self.view addSubview:endDate];
    
        //_endDate = [[UITextField alloc]initWithFrame:CGRectMake(mainW * 0.3, mainW * 0.15, mainW * 0.35, mainW * 0.15)];
    _endDate = [[UITextField alloc]init];
            _endDate.delegate = self;
            _endDate.text = [fmt stringFromDate:date];
            [self.view addSubview:_endDate];
    
     endDate.sd_layout
    .leftSpaceToView(self.view,0)
    .topSpaceToView(startDate,5)
    .widthIs(80)
    .heightIs(40);
    
    _endDate.sd_layout
    .leftSpaceToView(endDate,10)
    .topSpaceToView(_startDate,5)
    .widthIs(100)
    .heightIs(40);

    
    
        // 编号
        //UILabel *number = [[UILabel alloc]initWithFrame:CGRectMake(0, mainW * 0.3, mainW * 0.3, mainW * 0.15)];
    UILabel *number = [[UILabel alloc]init];
            number.text = @"编        号:";
            [self.view addSubview:number];
        
        //numebrFiled = [[UITextField alloc]initWithFrame:CGRectMake(mainW * 0.3, mainW * 0.3, mainW * 0.4, mainW * 0.15)];
    numebrFiled = [[UITextField alloc]init];
            numebrFiled.placeholder = @"请输入编号";
            [self.view addSubview:numebrFiled];
    
    number.sd_layout
    .leftSpaceToView(self.view,0)
    .topSpaceToView(endDate,5)
    .widthIs(80)
    .heightIs(40);
    
    numebrFiled.sd_layout
    .leftSpaceToView(number,10)
    .topSpaceToView(_endDate,5)
    .widthIs(100)
    .heightIs(40);
    
    
    
        //查询
    searchButton = [UIButton buttonWithType:UIButtonTypeCustom];
        //[searchButton setFrame:CGRectMake(mainW * 0.7, mainH * 0.02, mainW * 0.28, mainW * 0.35)];
    [searchButton setTitle:@"查询" forState:UIControlStateNormal];        //设置button在没有选中的时候显示的字体
    searchButton.titleLabel.font = [UIFont systemFontOfSize:17.0f];         //设置button显示字体的大小
    [searchButton setBackgroundImage:[UIImage imageNamed:@"Button02.png"] forState:UIControlStateNormal];    //设置button背景显示图片
    [searchButton addTarget:self action:@selector(search) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:searchButton];
    searchButton.sd_layout
    .topSpaceToView(self.view,17)
        //.leftSpaceToView(_startDate,15)
    .rightSpaceToView(self.view,5)
    .widthIs(100)
    .heightIs(100);
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
#pragma clang diagnostic pop
    if (buttonIndex == 1) { // 去设置界面，开启相机访问权限
        if (iOS8Later) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
        } else {
            NSURL *privacyUrl;
            privacyUrl = [NSURL URLWithString:@"prefs:root=Privacy&path=CAMERA"];
            
            if ([[UIApplication sharedApplication] canOpenURL:privacyUrl]) {
                [[UIApplication sharedApplication] openURL:privacyUrl];
            } else {
                UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"抱歉" message:@"无法跳转到隐私设置页面，请手动前往设置页面，谢谢" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
                [alert show];
            }
        }
    }
}

//-(void)passTrendValues:(NSString *)values{
//    pernr1 = values;
//    NSLog(@"pernr:---------%@",pernr1);
//}

-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.navigationItem setTitle:@"活 动"];
    
        [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    
    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:66/255.0 green:135/255.0 blue:178/255.0 alpha:1.0]];
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],NSForegroundColorAttributeName,nil]];
    Common *common=[[Common alloc] initWithView:self.view];
    if (common.isConnectionAvailable) {
        // 马上进入刷新状态
        [tableView1.mj_header beginRefreshing];
    }else{
     [tableView1.mj_header endRefreshing];
    
    }
}
-(void)backMenu{
  [self.navigationController popViewControllerAnimated:YES];
}




#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if (_datePicker.frame.origin.y != mainH && _datePicker != nil) {
        [_datePicker dismiss];
        return NO;
        
    }else if (textField == _startDate) {
        [_datePicker show];
        return NO;
    }else if(textField == _endDate){
        [_datePicker1 show1];
        return NO;
    }
    
    return YES;
}

#pragma mark - HWDatePickerDelegate
- (void)datePickerView:(HWDatePicker *)datePickerView didClickSureBtnWithSelectDate:(NSString *)date
{
    _startDate.text = date;
}

- (void)datePickerView1:(HWDatePicker *)datePickerView didClickSureBtnWithSelectDate1:(NSString *)date
{
    _endDate.text = date;
}

-(void)getReports{
   
     startDate1 = [[[_startDate.text substringToIndex:4] stringByAppendingString:[_startDate.text substringWithRange:NSMakeRange(5, 2)]]stringByAppendingString:[_startDate.text substringWithRange:NSMakeRange(8, 2)]];
    NSLog(@"%@",startDate1);
    
    endDate1 = [[[_endDate.text substringToIndex:4] stringByAppendingString:[_endDate.text substringWithRange:NSMakeRange(5, 2)]]stringByAppendingString:[_endDate.text substringWithRange:NSMakeRange(8, 2)]];
    NSLog(@"%@",endDate1);
    
    Common *common=[[Common alloc] initWithView:self.view];
    if (common.isConnectionAvailable) {
        AppDelegate *delegate = [UIApplication sharedApplication].delegate;
        NSLog(@"%@",delegate.userInfo1.pernr);
    NSDictionary *dic = @{
                          @"IN_SABEON":delegate.userInfo1.pernr,
                          @"IN_SDATE" :startDate1,
                          @"IN_EDATE" :endDate1,
                          @"IN_KEY_WORD":numebrFiled.text
                          };
    
    NSString *string = @"http://118.102.25.56:8080/HM/photo/reportlist.do";
    
    [[AFHTTPRequestOperationManager manager] POST:string parameters:dic success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        NSLog(@"----%@----",string);
        NSLog(@"%@",responseObject);
        reportList = responseObject[@"open_cursor"];
        NSLog(@"%lu",(unsigned long)reportList.count);
        NSLog(@"reportList的数组内容为--》%@",reportList);
        
        [tableView1 reloadData];

            // 拿到当前的下拉刷新控件，结束刷新状态
        [tableView1.mj_header endRefreshing];
        
           } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        NSLog(@"error:%@----%@",error.localizedFailureReason,error.localizedDescription);
                   //[HUDManager showMessage:@"网络或服务器错误,请稍候..." duration:1];
                   // 拿到当前的下拉刷新控件，结束刷新状态
               [tableView1.mj_header endRefreshing];
        
    }];

 }

}


-(void)search{
        // 马上进入刷新状态
    [tableView1.mj_header beginRefreshing];
//    if ([numebrFiled.text isEqualToString:@""]) {
//        [HUDManager showMessage:@"请输入编号" duration:1];
//    }else{
        Common *common=[[Common alloc] initWithView:self.view];
        if (common.isConnectionAvailable) {
            AppDelegate *delegate = [UIApplication sharedApplication].delegate;
            
            NSDictionary *dic = @{
                                  @"IN_SABEON":delegate.userInfo1.pernr,
                                  @"IN_SDATE" :startDate1,
                                  @"IN_EDATE" :endDate1,
                                  @"IN_KEY_WORD":numebrFiled.text
                                  };
            NSString *string = @"http://118.102.25.56:8080/HM/photo/reportlist.do";
            
            [[AFHTTPRequestOperationManager manager] POST:string parameters:dic success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
                NSLog(@"----%@----",string);
                NSLog(@"%@",responseObject);
                reportList = responseObject[@"open_cursor"];
                NSLog(@"%lu",(unsigned long)reportList.count);
                NSLog(@"reportList的数组内容为--》%@",reportList);
                [tableView1 reloadData];
                    // 拿到当前的下拉刷新控件，结束刷新状态
                [tableView1.mj_header endRefreshing];
            } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
                NSLog(@"error:%@----%@",error.localizedFailureReason,error.localizedDescription);
                
            }];
            
            [self.view endEditing:YES];
        }
    }
    //}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return reportList.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 55;
}



-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    HdTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"HdTableViewCell"];
    
    if (!cell)
        {
        [tableView registerNib:[UINib nibWithNibName:@"HdTableViewCell" bundle:nil] forCellReuseIdentifier:@"HdTableViewCell"];
        cell = [tableView dequeueReusableCellWithIdentifier:@"HdTableViewCell"];
        }
    if (indexPath.row%2==0) {
        cell.backgroundColor=[UIColor whiteColor];
    }
    else
        {
        cell.backgroundColor=[UIColor colorWithWhite:0.95 alpha:1.0];
        }
    cell.Number.text = [NSString stringWithFormat:@"%@",@(indexPath.row + 1)];
    cell.layer.masksToBounds=YES;
    return cell;
}


-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    HdTableViewCell *tempCell = (HdTableViewCell *)cell;
    NSDictionary *dic = [reportList objectAtIndex:indexPath.row];
    NSLog(@"%lu==========",(unsigned long)dic.count);

    NSString *status = [reportList objectAtIndex:indexPath.row][@"STATUS"];
    NSLog(@"%@",status);
    tempCell.status.text =status;
    
    NSString *reportCount = [reportList objectAtIndex:indexPath.row][@"REPORT_CODE"];
      NSLog(@"%@",reportCount);
    NSString *string11 = [NSString stringWithFormat:@"编号:"];
    NSString *string22 = [string11 stringByAppendingString:reportCount];
   tempCell.reportCount.text = string22;
    
    NSNumber *photoCount = [reportList objectAtIndex:indexPath.row][@"PHOTO_COUNT"];
    NSString *String = photoCount.description;

    NSLog(@"%@",String);
    NSString *string1 = [NSString stringWithFormat:@"图片:"];
    NSString *string2 = [string1 stringByAppendingString:String];
    tempCell.photoCount.text =  string2;
    
    NSString *title = [reportList objectAtIndex:indexPath.row][@"APPR_TITLE"];
    NSLog(@"%@",title);
    tempCell.title.text = title;
    

}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    reportcode = [reportList objectAtIndex:indexPath.row][@"REPORT_CODE"];
    NSLog(@"%@",reportcode);
     [self performSegueWithIdentifier:@"HdDetail" sender:self];

}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if( [segue.identifier isEqualToString:@"HdDetail"]){
        id detailViewController = segue.destinationViewController;
        [detailViewController setValue:reportcode forKey:@"reportcode"];
    }
    
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


@end
