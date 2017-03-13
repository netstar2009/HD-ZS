//
//  waitUpLoadPhotoViewController.m
//  hd
//
//  Created by hongxianyu on 2016/10/26.
//  Copyright © 2016年 com.hxy. All rights reserved.
//

#import "waitUpLoadPhotoViewController.h"
#import "TXBSJAvatarBrowser.h"
    //#import "UIViewController+BackButtonHandler.h"
static NSString * const FTP_ADDRESS = @"ftp://118.102.25.25:21";
static NSString * const USERNAME = @"SFAAdmin";
static NSString * const PASSWORD = @"1234";
static NSString * const PHOTOPATH= @"/./photo/";

@interface waitUpLoadPhotoViewController (){
    NSString *photofilepath1;
    NSArray *array1;
    
    NSMutableArray *photoName;
    NSMutableArray *photoPath;
    NSMutableArray *lat;
    NSMutableArray *lon;
    NSMutableArray *code;
    NSMutableArray *msg;
    UIButton *uploadButton;
    
    JGProgressHUD * _progressHUD;
      dispatch_source_t _timer;
    
    UILabel *dayLabel;
    UILabel *hourLabel;
    UILabel *minuteLabel;
    UILabel *secondLabel;
    
    UIImageView *imageView;
    
    UILabel *lable1;

}
@property (nonatomic, retain) UICollectionView *collectionView;
@end

@implementation waitUpLoadPhotoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    NSLog(@"%@1233333333",_waituploadReportCode);
        //self.edgesForExtendedLayout = UIRectEdgeNone;

        //ftp上照片存储路径
    photofilepath1=[NSString stringWithFormat:@"/./photo/"];

        //确定上传照片
    uploadButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [uploadButton setFrame:CGRectMake(30 , mainH - 50, mainW - 60, 40)];
    [uploadButton setTitle:@"确定上传" forState:UIControlStateNormal];        //设置button在没有选中的时候显示的字体
    uploadButton.titleLabel.font = [UIFont systemFontOfSize:14.0f];         //设置button显示字体的大小
    [uploadButton setBackgroundImage:[UIImage imageNamed:@"Button01.png"] forState:UIControlStateNormal];    //设置button背景显示图片
    [uploadButton addTarget:self action:@selector(uploadPhoto1) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:uploadButton];

        //确定是水平滚动，还是垂直滚动
    UICollectionViewFlowLayout *flowLayout=[[UICollectionViewFlowLayout alloc] init];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    
    self.collectionView=[[UICollectionView alloc] initWithFrame:CGRectMake(0, 104, mainW, mainH - 200) collectionViewLayout:flowLayout];
    self.collectionView.dataSource=self;
    self.collectionView.delegate=self;
    [self.collectionView setBackgroundColor:[UIColor clearColor]];
    
        //注册Cell，必须要有
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"UICollectionViewCell"];
        //self.collectionView.backgroundColor = [UIColor redColor];
    [self.view addSubview:self.collectionView];

    
    
    NSArray *paths1=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    NSString *path1=[paths1 lastObject];
    NSString *filename1=[path1 stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.plist",_waituploadReportCode]];
    array1=[NSArray arrayWithContentsOfFile:filename1];
    NSLog(@"%@,%lu@",array1,(unsigned long)array1.count);
    for (int i = 0;  i < array1.count; i++) {
        NSLog(@"%@\n",array1[i]);
    }
    
    if (array1.count / 8 >= 1) {
        lable1 = [[UILabel alloc]initWithFrame:CGRectMake(20, 64, 90, 40)];
        lable1.text = @"上传倒计时:";
           
            //天数
        dayLabel = [[UILabel alloc]initWithFrame:CGRectMake(120,64, 40, 40)];
        dayLabel.textColor = [UIColor redColor];
        
            //小时
        hourLabel = [[UILabel alloc]initWithFrame:CGRectMake(160,64, 40, 40)];
        hourLabel.textColor = [UIColor redColor];
        
            //分钟
        minuteLabel = [[UILabel alloc]initWithFrame:CGRectMake(200,64, 40, 40)];
        minuteLabel.textColor = [UIColor redColor];
        
            //秒
        secondLabel = [[UILabel alloc]initWithFrame:CGRectMake(240,64, 40, 40)];
        secondLabel.textColor = [UIColor redColor];
        
        [self.view addSubview:lable1];
        [self.view addSubview:secondLabel];
        
        [self.view addSubview:minuteLabel];
        [self.view addSubview:hourLabel];
        [self.view addSubview:dayLabel];
        

        [self time];
    }
    if (array1.count == 8) {
//        IN_PHOTO_NM = array1[2];
//        IN_P_LONGITUDE = array1[3];
//        IN_P_LATITUDE = array1[4];
//        IN_GPSERRORCODE = array1[5];
//        IN_GPSERRORMSG = array1[6];
//        PhotoPath = array1[7] ;
        photoName = [NSMutableArray arrayWithObjects:array1[2],nil];
        lon = [NSMutableArray arrayWithObjects:array1[3],nil];
        lat = [NSMutableArray arrayWithObjects:array1[4],nil];
        code = [NSMutableArray arrayWithObjects:array1[5],nil];
        msg = [NSMutableArray arrayWithObjects:array1[6],nil];
        photoPath = [NSMutableArray arrayWithObjects:array1[7],nil];
        NSLog(@"u=============%@",photoPath);
    }
    if (array1.count == 16) {
//        IN_PHOTO_NM = array1[10];
//        IN_P_LONGITUDE = array1[11];
//        IN_P_LATITUDE = array1[12];
//        IN_GPSERRORCODE = array1[13];
//        IN_GPSERRORMSG = array1[14];
//        PhotoPath = array1[15];
        
        photoName = [NSMutableArray arrayWithObjects:array1[2],array1[10], nil];
        lon = [NSMutableArray arrayWithObjects:array1[3],array1[11], nil];
        lat = [NSMutableArray arrayWithObjects:array1[4],array1[12], nil];
        code = [NSMutableArray arrayWithObjects:array1[5],array1[13], nil];
        msg = [NSMutableArray arrayWithObjects:array1[6],array1[14], nil];
        photoPath = [NSMutableArray arrayWithObjects:array1[7],array1[15], nil];
    }
    
    if (array1.count == 24) {
//        IN_PHOTO_NM = array1[18];
//        IN_P_LONGITUDE = array1[19];
//        IN_P_LATITUDE = array1[20];
//        IN_GPSERRORCODE = array1[21];
//        IN_GPSERRORMSG = array1[22];
//        PhotoPath = array1[23];
        
        photoName = [NSMutableArray arrayWithObjects:array1[2],array1[10],array1[18], nil];
        lon = [NSMutableArray arrayWithObjects:array1[3],array1[11],array1[19], nil];
        lat = [NSMutableArray arrayWithObjects:array1[4],array1[12],array1[20], nil];
        code = [NSMutableArray arrayWithObjects:array1[5],array1[13],array1[21], nil];
        msg = [NSMutableArray arrayWithObjects:array1[6],array1[14], array1[22],nil];
        photoPath = [NSMutableArray arrayWithObjects:array1[7],array1[15],array1[23], nil];
    }
    if (array1.count == 32) {
//        IN_PHOTO_NM = array1[26];
//        IN_P_LONGITUDE = array1[27];
//        IN_P_LATITUDE = array1[28];
//        IN_GPSERRORCODE = array1[29];
//        IN_GPSERRORMSG = array1[30];
//        PhotoPath = array1[31];
        
        photoName = [NSMutableArray arrayWithObjects:array1[2],array1[10],array1[18],array1[26], nil];
        lon = [NSMutableArray arrayWithObjects:array1[3],array1[11],array1[19],array1[27], nil];
        lat = [NSMutableArray arrayWithObjects:array1[4],array1[12],array1[20],array1[28], nil];
        code = [NSMutableArray arrayWithObjects:array1[5],array1[13],array1[21],array1[29], nil];
        msg = [NSMutableArray arrayWithObjects:array1[6],array1[14], array1[22],array1[30],nil];
        photoPath = [NSMutableArray arrayWithObjects:array1[7],array1[15],array1[23],array1[31], nil];

    }
    if (array1.count == 40) {
        photoName = [NSMutableArray arrayWithObjects:array1[2],array1[10],array1[18],array1[26],array1[34], nil];
        lon = [NSMutableArray arrayWithObjects:array1[3],array1[11],array1[19],array1[27],array1[35], nil];
        lat = [NSMutableArray arrayWithObjects:array1[4],array1[12],array1[20],array1[28],array1[36], nil];
        code = [NSMutableArray arrayWithObjects:array1[5],array1[13],array1[21],array1[29],array1[37], nil];
        msg = [NSMutableArray arrayWithObjects:array1[6],array1[14], array1[22],array1[30],array1[38],nil];
        photoPath = [NSMutableArray arrayWithObjects:array1[7],array1[15],array1[23],array1[31],array1[39], nil];
    }
    if (array1.count == 48) {
//        IN_PHOTO_NM = array1[42];
//        IN_P_LONGITUDE = array1[43];
//        IN_P_LATITUDE = array1[44];
//        IN_GPSERRORCODE = array1[45];
//        IN_GPSERRORMSG = array1[46];
//        PhotoPath = array1[47];
        
        photoName = [NSMutableArray arrayWithObjects:array1[2],array1[10],array1[18],array1[26],array1[34],array1[42], nil];
        lon = [NSMutableArray arrayWithObjects:array1[3],array1[11],array1[19],array1[27],array1[35],array1[43], nil];
        lat = [NSMutableArray arrayWithObjects:array1[4],array1[12],array1[20],array1[28],array1[36],array1[44], nil];
        code = [NSMutableArray arrayWithObjects:array1[5],array1[13],array1[21],array1[29],array1[37],array1[45], nil];
        msg = [NSMutableArray arrayWithObjects:array1[6],array1[14], array1[22],array1[30],array1[38],array1[46],nil];
        photoPath = [NSMutableArray arrayWithObjects:array1[7],array1[15],array1[23],array1[31],array1[39],array1[47], nil];
    }
    if (photoPath == nil) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:@"照片不存在，是否清除无效的待上传图片信息？" preferredStyle:UIAlertControllerStyleAlert];
        [alert loadViewIfNeeded];
        [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
                // 点击确定按钮的时候, 会调用这个block
            NSFileManager *manager=[NSFileManager defaultManager];
                //文件路径
            NSString *filepath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)objectAtIndex:0]stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.plist",_waituploadReportCode]];
            if ([manager removeItemAtPath:filepath error:nil]) {
                NSLog(@"文件删除成功");
                for (NSInteger i = 0; i < array1.count / 8; i ++) {
                    [self deleteFile:photoPath[i]];
                }

            }
                //[self deletePhoto];
            uploadButton.userInteractionEnabled = NO;
        }]];
        [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
        
    }

    [_collectionView reloadData];
        HUDManager = [[MBProgressHUDManager alloc] initWithView:self.navigationController.view];
    
}


-(void)time{

    NSArray *paths2=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    NSString *path2=[paths2 lastObject];
    NSString *filename2=[path2 stringByAppendingPathComponent:[NSString stringWithFormat:@"1%@.plist",_waituploadReportCode]];
   NSArray *array2=[NSArray arrayWithContentsOfFile:filename2];
    NSLog(@"%@,%@",array2,array2[0]);
    
    
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
   NSDate *uploadDate = [dateFormatter dateFromString:array2[0]];
    
    NSCalendar *cal = [NSCalendar currentCalendar];
    
    unsigned int unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
    
    
//    NSDate *date = [NSDate date]; // 获得时间对象
//    
//    NSTimeZone *zone = [NSTimeZone systemTimeZone]; // 获得系统的时区
//    
//    NSTimeInterval time = [zone secondsFromGMTForDate:date];// 以秒为单位返回当前时间与系统格林尼治时间的差
//    
//    NSDate *dateNow = [date dateByAddingTimeInterval:time];// 然后把差的时间加上,就是当前系统准确的时间
//    NSLog(@"-----------%@",dateNow);

   
    
    NSDateComponents *d = [cal components:unitFlags fromDate:uploadDate toDate:[NSDate date] options:0];
    NSLog(@"%@",d);
     NSLog(@"second = %ld",[d hour]*3600+[d minute]*60+[d second]);
    long sec = [d month]*30 * 24 * 3600 + [d day]*24*3600 + [d hour]*3600+[d minute]*60 + [d second];
    NSLog(@"%@",[NSDate date]);
    NSLog(@"%ld",sec);
   
    if (sec < 0) {
        
        lable1.text = @"";
        dayLabel.text = @"";
        hourLabel.text = @"";
        minuteLabel.text = @"";
        secondLabel.text = @"";

        NSFileManager *manager=[NSFileManager defaultManager];
            //文件路径
        NSString *filepath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)objectAtIndex:0]stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.plist",_waituploadReportCode]];
        
        NSString *filepath1 = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)objectAtIndex:0]stringByAppendingPathComponent:[NSString stringWithFormat:@"1%@.plist",_waituploadReportCode]];
        
        if ([manager removeItemAtPath:filepath error:nil]) {
            NSLog(@"图片文件删除成功1");
            for (NSInteger i = 0; i < array1.count / 8; i ++) {
                [self deleteFile:photoName[i]];
            }
            
        }
        if ([manager removeItemAtPath:filepath1 error:nil]) {
            NSLog(@"1");
        }

    }
    
    if (sec > 30 * 24 * 3600) {
        
        lable1.text = @"";
        dayLabel.text = @"";
        hourLabel.text = @"";
        minuteLabel.text = @"";
        secondLabel.text = @"";
        
        NSFileManager *manager=[NSFileManager defaultManager];
            //文件路径
        NSString *filepath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)objectAtIndex:0]stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.plist",_waituploadReportCode]];
        
        NSString *filepath1 = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)objectAtIndex:0]stringByAppendingPathComponent:[NSString stringWithFormat:@"1%@.plist",_waituploadReportCode]];
        
        if ([manager removeItemAtPath:filepath error:nil]) {
            NSLog(@"图片文件删除成功1");
            for (NSInteger i = 0; i < array1.count / 8; i ++) {
                [self deleteFile:photoName[i]];
            }
            
        }
        if ([manager removeItemAtPath:filepath1 error:nil]) {
            NSLog(@"1");
        }
        
    }

    
    if (_timer==nil) {
        __block long timeout = 30 * 24 *3600 - sec; //倒计时时间
        
        if (timeout!=0) {
            dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
            _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
            dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
            dispatch_source_set_event_handler(_timer, ^{
                if(timeout<=0){ //倒计时结束，关闭
                    dispatch_source_cancel(_timer);
                    _timer = nil;
                    
                    NSFileManager *manager=[NSFileManager defaultManager];
                        //文件路径
                    NSString *filepath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)objectAtIndex:0]stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.plist",_waituploadReportCode]];
                    
                    NSString *filepath1 = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)objectAtIndex:0]stringByAppendingPathComponent:[NSString stringWithFormat:@"1%@.plist",_waituploadReportCode]];
                    
                    if ([manager removeItemAtPath:filepath error:nil]) {
                        NSLog(@"图片文件删除成功1");
                        for (NSInteger i = 0; i < array1.count / 8; i ++) {
                            [self deleteFile:photoName[i]];
                        }
                        
                    }
                    if ([manager removeItemAtPath:filepath1 error:nil]) {
                        NSLog(@"1");
                    }

                    dispatch_async(dispatch_get_main_queue(), ^{
                        lable1.text = @"";
                        dayLabel.text = @"";
                        hourLabel.text = @"";
                        minuteLabel.text = @"";
                        secondLabel.text = @"";
                            //[self deletePhoto];
                        
                    });
                }else if (timeout > 0 && timeout < 30 * 24 * 3600){
                    int days = (int)(timeout/(3600*24));
                    if (days==0) {
                        dayLabel.text = @"00天";
                    }
                    int hours = (int)((timeout-days*24*3600)/3600);
                    int minute = (int)(timeout-days*24*3600-hours*3600)/60;
                    long second = timeout-days*24*3600-hours*3600-minute*60;
                    dispatch_async(dispatch_get_main_queue(), ^{
                        if (days==0) {
                            dayLabel.text = @"00天";
                        }else{
                            dayLabel.text = [NSString stringWithFormat:@"%.2d天",days];
                        }
                        if (hours<10) {
                            hourLabel.text = [NSString stringWithFormat:@"%.2d时",hours];
                        }else{
                            hourLabel.text = [NSString stringWithFormat:@"%d时",hours];
                        }
                        if (minute<10) {
                            minuteLabel.text = [NSString stringWithFormat:@"%.2d分",minute];
                        }else{
                            minuteLabel.text = [NSString stringWithFormat:@"%d分",minute];
                        }
                        if (second<10) {
                          secondLabel.text = [NSString stringWithFormat:@"%.2ld秒",second];
                        }else{
                            secondLabel.text = [NSString stringWithFormat:@"%ld秒",second];
                        }
                        
                    });
                    timeout--;
                }
            });
            dispatch_resume(_timer);
        }
    }

}




-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    [self.navigationItem setTitle:@"待上传"];
    
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    
    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:66/255.0 green:135/255.0 blue:178/255.0 alpha:1.0]];
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],NSForegroundColorAttributeName,nil]];
    
}

-(void)deleteFile:(NSString *)imageName {
    NSFileManager* fileManager=[NSFileManager defaultManager];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    
        //文件名
    NSString *uniquePath=[[paths objectAtIndex:0] stringByAppendingPathComponent:imageName];
    BOOL blHave=[[NSFileManager defaultManager] fileExistsAtPath:uniquePath];
    if (!blHave) {
        NSLog(@"no  have");
        return ;
    }else {
        NSLog(@" have");
        BOOL blDele= [fileManager removeItemAtPath:uniquePath error:nil];
        if (blDele) {
            NSLog(@"dele success");
        }else {
            NSLog(@"dele fail");
        }
        
    }
}

//-(void)deletePhoto{
//    
//    NSFileManager *fileManager = [NSFileManager defaultManager];
//    NSArray *fileListArray = [fileManager contentsOfDirectoryAtPath:kDocument_Folder error:nil];
//    for (NSString *file in fileListArray)
//        {
//        NSString *path = [kDocument_Folder stringByAppendingPathComponent:file];
//        NSString *extension = [path pathExtension];
//        if (([extension compare:@"jpg" options:NSCaseInsensitiveSearch] == NSOrderedSame))
//            {
//            [fileManager removeItemAtPath:path error:nil];
//            }
//        
//        }
//    NSLog(@"清空了");
//}


    //上传照片
-(void)uploadPhoto1
{
   
    Common *common=[[Common alloc] initWithView:self.view];
    if (common.isConnectionAvailable) {
    
    if((array1.count / 8) >0)
        {
        @try {
                // didUpdateBMKUserLocation
            
            __block NSString *PHOTO_NM1 ;
            __block NSString *LONGITUDE1;
            __block NSString *LATITUDE1;
            __block NSString *GPSERRORCODE1;
            __block NSString *GPSERRORMSG1;
            __block NSUInteger number = 0;
            PHOTO_NM1=@"";//图片名字
            LONGITUDE1=@""; //经度
            LATITUDE1 =@"";//纬度
            GPSERRORCODE1 = @"";//gps采点状态码
            GPSERRORMSG1 = @"";//gps采点状态说明
            for (int i = 0; i < (array1.count / 8); i++) {
                               //for (NSString *PhotoName in photoName) {
                               __block NSString *imagePath=nil;
                
                imagePath=[photofilepath1 stringByAppendingString:photoName[i]];
                
                    //typeof(self) __weak weakSelf = self;
                
                
                LxFTPRequest * request = [LxFTPRequest uploadRequest];
                request.username = USERNAME;
                request.password = PASSWORD;
                
                request.serverURL = [[NSURL URLWithString:FTP_ADDRESS]URLByAppendingPathComponent:imagePath];
                    // NSString *localFilePath = [NSString stringWithFormat:@"%@",photoPath[i]];
                NSString *localFilePath = [NSString stringWithFormat:@"%@/Documents/%@",NSHomeDirectory(),photoName[i]];
                NSLog(@"%@",localFilePath);

                request.localFileURL = [NSURL fileURLWithPath:localFilePath];
                [request start];
                _progressHUD = [JGProgressHUD progressHUDWithStyle:JGProgressHUDStyleDark];
                _progressHUD.indicatorView = [[JGProgressHUDPieIndicatorView alloc]init];
                
                request.progressAction = ^(NSInteger totalSize, NSInteger finishedSize, CGFloat finishedPercent) {
                    NSLog(@"totalSize = %ld, finishedSize = %ld, finishedPercent = %f", (long)totalSize, (long)finishedSize, finishedPercent);  //
                    totalSize = MAX(totalSize, finishedSize);
                    _progressHUD.progress = (CGFloat)finishedSize / (CGFloat)totalSize;
                    [_progressHUD showInView:self.view animated:YES];
                };
                request.successAction = ^(Class resultClass, id result) {
                    PHOTO_NM1 = [PHOTO_NM1 stringByAppendingString:[NSString stringWithFormat:@"%@AA",photoName[i]]];
                    LONGITUDE1=[LONGITUDE1 stringByAppendingString:[NSString stringWithFormat:@"%@AA",lon[i]]];
                    
                    LATITUDE1=[LATITUDE1 stringByAppendingString:[NSString stringWithFormat:@"%@AA",lat[i]]];
                    GPSERRORCODE1=[GPSERRORCODE1 stringByAppendingString:[NSString stringWithFormat:@"%@AA",code[i]]];
                    GPSERRORMSG1 = [GPSERRORMSG1 stringByAppendingString:[NSString stringWithFormat:@"%@AA",msg[i]]];
                    NSLog(@"%@,%@,%@,%@,%@======================",PHOTO_NM1,LONGITUDE1,LATITUDE1,GPSERRORCODE1,GPSERRORMSG1);
                    [_progressHUD dismissAnimated:YES];
                    number = number + 1;
                    NSLog(@"y---------%@----------",result);
                    if ((array1.count / 8) == number  ) {
                        NSLog(@"成功");
                            //图片上传成功！ 关联数据表中数据
                        [self communicateServiceWithIN_PHOTO_NM1:PHOTO_NM1 andIN_P_LONGITUDE1:LONGITUDE1 andIN_P_LATITUDE1:LATITUDE1 andIN_GPSERRORCODE1:GPSERRORCODE1 andIN_GPSERRORMSG1:GPSERRORCODE1];
                    }else{
                        [_progressHUD dismissAnimated:YES];
                        [_progressHUD dismiss];
                        }
                };
                request.failAction = ^(CFStreamErrorDomain domain, NSInteger error, NSString * errorMessage) {
                    
                    [_progressHUD dismissAnimated:YES];
                    NSLog(@"domain = %ld, error = %ld, errorMessage = %@", domain, (long)error, errorMessage);    //
                };
                
            }
        }
        @catch (NSException *exception) {
            [HUDManager showErrorWithMessage:exception.description duration:2];
        }
        @finally {
            return;
        }
        }
    
    else
        {
            //[HUDManager showMessage:@"请添加照片" duration:1];
        
        
//        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:@"照片不存在，是否清除无效的待上传图片信息？" preferredStyle:UIAlertControllerStyleAlert];
//        [alert loadViewIfNeeded];
//        [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
//                // 点击确定按钮的时候, 会调用这个block
//            NSFileManager *manager=[NSFileManager defaultManager];
//                //文件路径
//            NSString *filepath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)objectAtIndex:0]stringByAppendingPathComponent:@"Date.plist"];
//            if ([manager removeItemAtPath:filepath error:nil]) {
//                NSLog(@"文件删除成功");
//            }
//            [self deletePhoto];
//
//        }]];
//        [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
        
        
        }
    }
}


- (void)showMessage:(NSString *)message
{
    NSLog(@"message = %@", message);//
    
    JGProgressHUD * hud = [JGProgressHUD progressHUDWithStyle:JGProgressHUDStyleDark];
    hud.indicatorView = nil;
    hud.textLabel.text = [message stringByAppendingString:@"文件已存在"];
    [hud showInView:self.view];
    [hud dismissAfterDelay:1];
}

    //ftp上传成功后，数据库中关联照片信息
-(void) communicateServiceWithIN_PHOTO_NM1:(NSString *) PHOTO_NM1 andIN_P_LONGITUDE1:(NSString *) P_LONGITUDE1 andIN_P_LATITUDE1:(NSString *) P_LATITUDE1 andIN_GPSERRORCODE1:(NSString *) GPSERRORCODE1 andIN_GPSERRORMSG1:(NSString *) GPSERRORMSG1{
    
    Common *common=[[Common alloc] initWithView:self.view];
    if (common.isConnectionAvailable) {
        AppDelegate *delegate = [UIApplication sharedApplication].delegate;
        NSLog(@"%@,%@",delegate.userInfo1.pernr,self.waituploadReportCode);
        NSDictionary *dic = @{
                              @"IN_SABEON":delegate.userInfo1.pernr,
                              @"IN_REPORT_CODE":self.waituploadReportCode,
                              @"IN_PHOTO_NM" :PHOTO_NM1,
                              @"IN_P_LONGITUDE":P_LONGITUDE1,
                              @"IN_P_LATITUDE":P_LATITUDE1,
                              @"IN_GPSERRORCODE":GPSERRORCODE1,
                              @"IN_GPSERRORMSG" :GPSERRORMSG1
                              };
        NSLog(@"%@",dic);
        NSString *string = @"http://118.102.25.56:8080/HM/photo/report_photoinfo.do";
        [[AFHTTPRequestOperationManager manager] POST:string parameters:dic success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
            
            NSLog(@"%@",responseObject[@"open_cursor"][0][@"OUT_RESULT"]);
            NSNumber *result = responseObject[@"open_cursor"][0][@"OUT_RESULT"];
            NSString *result1 = result.description;
            if ([result1 isEqualToString:@"0"]) {
                [HUDManager showSuccessWithMessage:@"图片上传成功" duration:1 complection:^{
                       
                        //[self deletePhoto];
                    NSFileManager *manager=[NSFileManager defaultManager];
                        //文件路径 @"Date.plist"
                    NSString *filepath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)objectAtIndex:0]stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.plist",_waituploadReportCode]];
                    if ([manager removeItemAtPath:filepath error:nil]) {
                        for (NSInteger i = 0; i < array1.count / 8; i ++) {
                            [self deleteFile:photoName[i]];
                        }
                        NSLog(@"图片文件删除成功3");
                    }
                    
                    NSString *filepath1 = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)objectAtIndex:0]stringByAppendingPathComponent:[NSString stringWithFormat:@"1%@.plist",_waituploadReportCode]];
                    if ([manager removeItemAtPath:filepath1 error:nil]) {
                        NSLog(@"3");
                    }
                    [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:1] animated:YES];
                }];
            }
            
        } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
            NSLog(@"error:%@----%@",error.localizedFailureReason,error.localizedDescription);
//            [HUDManager showSuccessWithMessage:@"" duration:1 complection:^{
//                    //[self deletePhoto];
//                [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:1] animated:YES];
//            }];
            [HUDManager showMessage:@"图片上传失败" duration:1];
        }];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

    //定义展示的UICollectionViewCell的个数
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    NSLog(@"%lu",(unsigned long)array1.count / 8);
    return array1.count / 8;
}
    //定义展示的Section的个数
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

    //每个UICollectionView展示的内容
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * CellIdentifier = @"UICollectionViewCell";
    UICollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    UIImageView *imgView = (UIImageView *)[cell viewWithTag:200] ;
    
        // UIImageView *imgView = (UIImageView *)cell ;
    if (array1.count == 8) {
            //NSString *localFilePath = [NSString stringWithFormat:@"%@/Documents/%@",NSHomeDirectory(),photoName[indexPath.row]];
        UIImage *savedImage = [[UIImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/Documents/%@",NSHomeDirectory(),photoName[indexPath.row]]];
        NSLog(@"%@-----------------------------------------",savedImage);
        if (!imgView) {
            imgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 90, 90)];
            imgView.tag = 200;
            [cell addSubview:imgView];
            imgView.image = savedImage;
        } else {
            imgView.image = savedImage;
        }

    }
    if (array1.count == 16) {
        UIImage *savedImage = [[UIImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/Documents/%@",NSHomeDirectory(),photoName[indexPath.row]]];
        NSLog(@"%@-----------------------------------------",savedImage);
        if (!imgView) {
            imgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 90, 90)];
            imgView.tag = 200;
            [cell addSubview:imgView];
            imgView.image = savedImage;
        } else {
            imgView.image = savedImage;
        }
        
    }
    if (array1.count == 24) {
        UIImage *savedImage = [[UIImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/Documents/%@",NSHomeDirectory(),photoName[indexPath.row]]];
        NSLog(@"%@-----------------------------------------",savedImage);
        if (!imgView) {
            imgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 90, 90)];
            imgView.tag = 200;
            [cell addSubview:imgView];
            imgView.image = savedImage;
        } else {
            imgView.image = savedImage;
        }
        
    }
    if (array1.count == 32) {
        UIImage *savedImage = [[UIImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/Documents/%@",NSHomeDirectory(),photoName[indexPath.row]]];
        NSLog(@"%@-----------------------------------------",savedImage);
        if (!imgView) {
            imgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 90, 90)];
            imgView.tag = 200;
            [cell addSubview:imgView];
            imgView.image = savedImage;
        } else {
            imgView.image = savedImage;
        }
    }
        if (array1.count == 40) {
            UIImage *savedImage = [[UIImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/Documents/%@",NSHomeDirectory(),photoName[indexPath.row]]];
            NSLog(@"%@-----------------------------------------",savedImage);
            if (!imgView) {
                imgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 90, 90)];
                imgView.tag = 200;
                [cell addSubview:imgView];
                imgView.image = savedImage;
            } else {
                imgView.image = savedImage;
            }
            
        }
        if (array1.count == 48) {
            UIImage *savedImage = [[UIImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/Documents/%@",NSHomeDirectory(),photoName[indexPath.row]]];
            NSLog(@"%@-----------------------------------------",savedImage);
            if (!imgView) {
                imgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 90, 90)];
                imgView.tag = 200;
                [cell addSubview:imgView];
                imgView.image = savedImage;
            } else {
                imgView.image = savedImage;
            }
            
        }
    
    return cell;
}

#pragma mark --UICollectionViewDelegateFlowLayout

    //定义每个Item 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(90, 90);
}

    //定义每个UICollectionView 的 margin
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(5, 5, 5, 5);
}
#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
        //初始化imageview，设置图片
    imageView = [[UIImageView alloc]init];
    
    UIImage *savedImage = [[UIImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/Documents/%@",NSHomeDirectory(),photoName[indexPath.row]]];
    imageView.image = savedImage;
    imageView.frame = CGRectMake(0, 0, imageView.image.size.width, imageView.image.size.height);
    [TXBSJAvatarBrowser showImage:imageView];
    
}
//#pragma mark - UICollectionViewDelegate
//- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
//{
//    ShowPhotoViewController *vc = [[ShowPhotoViewController alloc]init];
//    UIImage *savedImage1 = [[UIImage alloc] initWithContentsOfFile:[tempArr objectAtIndex:indexPath.row]];
//    self.trendDelegate = vc; //设置代理
//    
//    [self.trendDelegate passTrendValues:savedImage1];
//    NSLog(@"%@",savedImage1);
//    [self.navigationController pushViewController:vc animated:YES];
//    
//    
//}

    //返回这个UICollectionView是否可以被选择
-(BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
