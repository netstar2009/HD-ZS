//
//  HdDetailViewController.m
//  hd
//
//  Created by hongxianyu on 2016/10/20.
//  Copyright © 2016年 com.hxy. All rights reserved.
//

#import "HdDetailViewController.h"

@interface HdDetailViewController ()
{
    UITableView   *tableView1;
    NSMutableArray *detailArray;
    
}

@end

@implementation HdDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    detailArray = [[NSMutableArray alloc]init];
    
    tableView1=[[UITableView alloc] initWithFrame:CGRectMake(0, 0,[UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
    tableView1.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:tableView1];
    
    tableView1.dataSource=self;
    tableView1.delegate=self;

        //查看照片
    UIButton *seeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [seeButton setFrame:CGRectMake(10, mainH - 110, mainW / 2 -20, 40)];
    [seeButton setTitle:@"查看照片" forState:UIControlStateNormal];        //设置button在没有选中的时候显示的字体
    seeButton.titleLabel.font = [UIFont systemFontOfSize:14.0f];         //设置button显示字体的大小
    [seeButton setBackgroundImage:[UIImage imageNamed:@"Button01.png"] forState:UIControlStateNormal];    //设置button背景显示图片
    [seeButton addTarget:self action:@selector(see:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:seeButton];
    
        //上传照片
    UIButton *uploadButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [uploadButton setFrame:CGRectMake(mainW / 2 + 10, mainH - 110, mainW / 2 -20 , 40)];
    [uploadButton setTitle:@"上传照片" forState:UIControlStateNormal];        //设置button在没有选中的时候显示的字体
    uploadButton.titleLabel.font = [UIFont systemFontOfSize:14.0f];         //设置button显示字体的大小
    [uploadButton setBackgroundImage:[UIImage imageNamed:@"Button01.png"] forState:UIControlStateNormal];    //设置button背景显示图片
    [uploadButton addTarget:self action:@selector(upload:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:uploadButton];


    
    [self getDetail];
    
}

-(void)see:(UIButton *)sender{
    
    self.PhotoDetailReportCode = self.reportcode;
    NSLog(@"PhotoDetailReportCode:========%@",self.PhotoDetailReportCode);
    [self performSegueWithIdentifier:@"photoDetail" sender:self];
}

-(void)upload:(UIButton *)sender{
    self.reportCode = self.reportcode;
    NSLog(@"%@",self.reportCode);
    
[self performSegueWithIdentifier:@"Upload" sender:self];

}

-(void)waitUpLoadPhoto{

    self.waitUploadReportCode = self.reportcode;
    NSLog(@"waitUploadReportCode:=========%@",self.waitUploadReportCode);
    
    [self performSegueWithIdentifier:@"waitupload" sender:self];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if( [segue.identifier isEqualToString:@"Upload"]){
        id uploadViewController = segue.destinationViewController;
        [uploadViewController setValue:self.reportCode forKey:@"UploadReportcode"];
    }
    if ([ segue.identifier isEqualToString:@"photoDetail"]) {
        id photoDetailViewController = segue.destinationViewController;
        [photoDetailViewController setValue:self.PhotoDetailReportCode forKey:@"phtotDetailRrportCode"];
    }

    if ([segue.identifier isEqualToString:@"waitupload"]) {
        id waituploadViewControllr = segue.destinationViewController;
        [waituploadViewControllr setValue:self.waitUploadReportCode forKey:@"waituploadReportCode"];
    }
}

-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
        //    if (!self.serviceHelper) {
        //
        //        self.serviceHelper=[[ServiceHelper alloc] initWithDelegate:self];
        //    }
    
    [self.navigationItem setTitle:@"审批状态"];
    
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    
    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:66/255.0 green:135/255.0 blue:178/255.0 alpha:1.0]];
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],NSForegroundColorAttributeName,nil]];
        //[self addTopNotice];
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc] initWithTitle:@"待上传" style:UIBarButtonItemStylePlain target:self action:@selector(waitUpLoadPhoto)];

    
}


///**
// *  添加角标
// */
//-(void)addTopNotice{
//    UIImage *image = [UIImage imageNamed:@"Button02"];
//    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
//    button.frame = CGRectMake(0,0,10, 10);
//    [button addTarget:self action:@selector(buttonPress:) forControlEvents:UIControlEventTouchDown];
//    [button setBackgroundImage:image forState:UIControlStateNormal];
//    
//        // 角标测试写1
//    UIBarButtonItem *navLeftButton = [[UIBarButtonItem alloc] initWithCustomView:button];
//    self.navigationItem.rightBarButtonItem = navLeftButton;
//    self.navigationItem.rightBarButtonItem.badgeValue = @"1";
//    self.navigationItem.rightBarButtonItem.badgeBGColor = [UIColor redColor];
//    
//}

-(void)getDetail{

   Common *common=[[Common alloc] initWithView:self.view];
    if (common.isConnectionAvailable) {
        
        NSDictionary *dic = @{
                              @"IN_REPORT_CODE":self.reportcode
                              };
        //post提交
        NSString *string = @"http://118.102.25.56:8080/HM/approval/reportappr.do";
        
        [[AFHTTPRequestOperationManager manager] POST:string parameters:dic success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
           
            NSLog(@"----%@----",string);
            NSLog(@"%@",responseObject);
            detailArray = responseObject[@"open_cursor"];
            NSLog(@"%lu",(unsigned long)detailArray.count);
            NSLog(@"reportList的数组内容为--》%@",detailArray);
            [tableView1 reloadData];
        }failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
            NSLog(@"error:%@----%@",error.localizedFailureReason,error.localizedDescription);
            
        }];
        
        }
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return detailArray.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 45;
}



-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    HdDetailTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"HdDetailTableViewCell"];
    
    if (!cell)
        {
        [tableView registerNib:[UINib nibWithNibName:@"HdDetailTableViewCell" bundle:nil] forCellReuseIdentifier:@"HdDetailTableViewCell"];
        cell = [tableView dequeueReusableCellWithIdentifier:@"HdDetailTableViewCell"];
        }
    if (indexPath.row%2==0) {
        cell.backgroundColor=[UIColor whiteColor];
    }
    else
        {
        cell.backgroundColor=[UIColor colorWithWhite:0.95 alpha:1.0];
        }
    
    cell.layer.masksToBounds=YES;
    return cell;
}


-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    HdDetailTableViewCell *tempCell = (HdDetailTableViewCell *)cell;
    NSDictionary *dic = [detailArray objectAtIndex:indexPath.row];
    NSLog(@"%lu==========",(unsigned long)dic.count);
    
    NSNumber *appr_ord = [detailArray objectAtIndex:indexPath.row][@"APPR_ORD"];
    NSLog(@"%@",appr_ord);
    NSString *string = appr_ord.description;
    tempCell.appr_ord.text = string;
    
    NSString *appr_tm = [detailArray objectAtIndex:indexPath.row][@"APPR_TM"];
    NSLog(@"%@",appr_tm);
    
    tempCell.appr_tm.text = appr_tm;
    
    NSString *buseo_nm = [detailArray objectAtIndex:indexPath.row][@"BUSEO_NM"];
    
    NSLog(@"%@",buseo_nm);
    
    tempCell.useo_nm.text =  buseo_nm;
    
    NSString *appr_user = [detailArray objectAtIndex:indexPath.row][@"APPR_USER"];
    NSLog(@"%@",appr_user);
    tempCell.appr_user.text = appr_user;
    
    NSString *appr_class = [detailArray objectAtIndex:indexPath.row][@"APPR_CLASS"];
    NSLog(@"%@",appr_class);
    tempCell.appr_class.text = appr_class;
}


@end
