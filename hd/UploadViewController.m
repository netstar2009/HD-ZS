    //
    //  UploadViewController.m
    //  hd
    //
    //  Created by hongxianyu on 2016/10/26.
    //  Copyright © 2016年 com.hxy. All rights reserved.
    //

#import "UploadViewController.h"
#import<AssetsLibrary/AssetsLibrary.h>
#import<CoreLocation/CoreLocation.h>
#import <AVFoundation/AVCaptureDevice.h>
#import <AVFoundation/AVMediaFormat.h>

#import "XKCollectionViewCell.h"
#import "TXBSJAvatarBrowser.h"


#import "UIViewController+BackButtonHandler.h"
static NSString * const FTP_ADDRESS = @"ftp://118.102.25.25:21";
static NSString * const USERNAME = @"SFAAdmin";
static NSString * const PASSWORD = @"1234";
static NSString * const PHOTOPATH= @"/./photo/";

@interface UploadViewController ()<UIScrollViewDelegate>
{
    UIImage *image1;
    NSString *lat1;
    NSString *lon1;
    JGProgressHUD * _progressHUD;
    NSMutableArray *photoArry; //水印图片集合
    NSMutableArray *tempArr; //图片名字集合
    NSString *date1; //服务器时间截取后时间
    NSString *date2; //系统时间截取后时间
    NSString *strDate;//系统时间
    NSString *date; //服务器时间
    UIImage *waterImage;
    
    NSString *photoName1;//图片名字
    NSString *in_gpserrormsg;//gps采点状态说明
    
    NSString *photofilepath;//图片路径
    
    UIButton   *button;
    
    UIImageView *imgView1;
    
    NSMutableArray *lat;
    NSMutableArray *lon;
    
    
}
@property (nonatomic, retain) UICollectionView *collectionView;
@property (nonatomic,strong)BMKLocationService *locService;

@end

@implementation UploadViewController
UIImageView *imageView;

- (void)viewDidLoad {
    [super viewDidLoad];
        //self.edgesForExtendedLayout = UIRectEdgeNone;
    
    [self.navigationItem setTitle:@"上传照片"];
    
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    
    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:66/255.0 green:135/255.0 blue:178/255.0 alpha:1.0]];
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],NSForegroundColorAttributeName,nil]];
    
        //ftp上照片存储路径
    photofilepath=[NSString stringWithFormat:@"/./photo/"];
    
    UIImage  *img = [UIImage imageNamed:@"compose_pic_add"];
    button = [UIButton buttonWithType:UIButtonTypeCustom];
        //button.frame = CGRectMake([UIScreen mainScreen].bounds.size.width/2-img.size.width/2, 430, img.size.width, img.size.height);
    button.frame = CGRectMake(mainW / 2 -img.size.width / 2, mainH * 0.77, img.size.width, img.size.height);
    
    [button setBackgroundImage:img forState:UIControlStateNormal];
    [button setBackgroundImage:[UIImage imageNamed:@"compose_pic_add_highlighted"] forState:UIControlStateHighlighted];
    [button addTarget:self action:@selector(composePicAdd) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    
    
    lat = [[NSMutableArray alloc]init];
    lon = [[NSMutableArray alloc]init];
    photoArry = [NSMutableArray array];
    tempArr = [NSMutableArray array];
    
        //确定上传照片
    UIButton *uploadButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [uploadButton setFrame:CGRectMake(30 , mainH - 50, mainW - 60, 40)];
    [uploadButton setTitle:@"确定上传" forState:UIControlStateNormal];        //设置button在没有选中的时候显示的字体
    uploadButton.titleLabel.font = [UIFont systemFontOfSize:14.0f];         //设置button显示字体的大小
    [uploadButton setBackgroundImage:[UIImage imageNamed:@"Button01.png"] forState:UIControlStateNormal];    //设置button背景显示图片
    [uploadButton addTarget:self action:@selector(uploadPhoto) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:uploadButton];
    
    
    
        //确定是水平滚动，还是垂直滚动
    UICollectionViewFlowLayout *flowLayout=[[UICollectionViewFlowLayout alloc] init];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    
    self.collectionView=[[UICollectionView alloc] initWithFrame:CGRectMake(0, 64, mainW, mainH - 200) collectionViewLayout:flowLayout];
    self.collectionView.dataSource=self;
    self.collectionView.delegate=self;
    [self.collectionView setBackgroundColor:[UIColor clearColor]];
    
        //注册Cell，必须要有
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"UICollectionViewCell"];
    
    [self.view addSubview:self.collectionView];
    
    
    
    if (![CLLocationManager locationServicesEnabled]) {
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:@"定位服务可能尚未打开，请设置打开！" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
        
        [alert addAction:cancelAction];
        
        [alert addAction:okAction];
    }
        //初始化BMKLocationService
    _locService = [[BMKLocationService alloc]init];
    
    [_locService startUserLocationService];
    
    HUDManager = [[MBProgressHUDManager alloc] initWithView:self.navigationController.view];
}


/**
 *在地图View将要启动定位时，会调用此函数
 *@param mapView 地图View
 */
- (void)willStartLocatingUser
{
    
    NSLog(@"start locate");
}
/**
 *用户位置更新后，会调用此函数
 *@param userLocation 新的用户位置
 */
- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation
{
    
    
        //for (NSInteger i = 0; i < tempArr.count; i++) {
    NSLog(@"当前位置%f,%f", userLocation.location.coordinate.latitude, userLocation.location.coordinate.longitude);
    
    double lat2 = userLocation.location.coordinate.latitude;
    double lon2 = userLocation.location.coordinate.longitude;
    
    lat1 = [NSString stringWithFormat:@"%f",lat2];
    lon1 = [NSString stringWithFormat:@"%f",lon2];
    if (lat1 == 0 || lon1 == 0) {
        in_gpserrormsg = @"网络定位结果,网络定位定位失败";
    }else{
        in_gpserrormsg = @"网络定位结果,网络定位定位成功";
    }
    
    
        //}
}
/**
 *定位失败后，会调用此函数
 *@param mapView 地图View
 *@param error 错误号，参考CLError.h中定义的错误号
 */
- (void)didFailToLocateUserWithError:(NSError *)error
{
    NSLog(@"location error");
}



-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    _locService.delegate = self;// 此处记得不用的时候需要置nil，否则影响内存的释放
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    _locService.delegate = nil;
}





#pragma mark - image picker delegte
- (UIImage *)waterMarkImage:(UIImage *)image withText:(NSString *)text
{
    UIGraphicsBeginImageContext(CGSizeMake(image1.size.width, image1.size.height)); // 在画布中绘制内容
    [image drawInRect:CGRectMake(0, 0, image1.size.width, image1.size.height)];
    
    CGRect rect = CGRectMake(20, image1.size.height-350, image1.size.width, 180);
        //CGRect rect1 = CGRectMake(20, image1.size.height-100 , image1.size.width - 40, 50);
    NSDictionary *dic = @{NSFontAttributeName:[UIFont systemFontOfSize:180], NSForegroundColorAttributeName : [UIColor redColor]}; //这里设置了字体，和颜色
    
    [text drawInRect:rect withAttributes:dic];
        //[text1 drawInRect:rect1 withAttributes:dic];
        // 从画布中得到image
    UIImage *returnImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return returnImage;
}
- (void)composePicAdd
{
    
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if (authStatus == AVAuthorizationStatusRestricted ||//此应用程序没有被授权访问的照片数据。可能是家长控制权限
        authStatus == AVAuthorizationStatusDenied)//用户已经明确否认了这一照片数据的应用程序访问
        {
            // 无相机权限 做一个友好的提示
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"无法使用相机" message:@"请在iPhone的""设置-隐私-相机""中允许访问相机" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"设置", nil];
        
        [alert show];
        
            //            // 无权限 引导去开启
            //        NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
            //        if ([[UIApplication sharedApplication]canOpenURL:url]) {
            //            [[UIApplication sharedApplication]openURL:url];
            //        }
        }else{
            
                //先设定sourceType为相机
            UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
            if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera]){
                UIImagePickerController *picker = [[UIImagePickerController alloc] init];
                picker.delegate = self;
                
                picker.sourceType = sourceType;
                    //picker.cameraCaptureMode = UIImagePickerControllerCameraCaptureModePhoto;
                [self presentViewController:picker animated:YES completion:nil];
            }else{
                NSLog(@"模拟其中无法打开照相机,请在真机中使用");
                
            }
        }
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
#pragma clang diagnostic pop
    if (buttonIndex == 1) { // 去设置界面，开启相机访问权限
        if (iOS8Later) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
        } else {
            NSURL *privacyUrl;
            if (alertView.tag == 1) {
                privacyUrl = [NSURL URLWithString:@"prefs:root=Privacy&path=PHOTOS"];
            } else {
                privacyUrl = [NSURL URLWithString:@"prefs:root=Privacy&path=CAMERA"];
            }
            if ([[UIApplication sharedApplication] canOpenURL:privacyUrl]) {
                [[UIApplication sharedApplication] openURL:privacyUrl];
            } else {
                UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"抱歉" message:@"无法跳转到隐私设置页面，请手动前往设置页面，谢谢" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
                [alert show];
            }
        }
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

-(void)getServerTime{
    Common *common=[[Common alloc] initWithView:self.view];
    if (common.isConnectionAvailable) {
        NSString *urlString =@"http://118.102.25.56:8080/HM/photo/systemtm.do";
            //统一资源定位符(URL)
        NSURL *url = [NSURL URLWithString:urlString];
        NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:10.0f];
        
        NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];  //从网上请求得到的数据
        NSString *str = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];  //转码之后,可以打印出来
        NSLog(@"str == %@", str);
            //        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
            //        NSLog(@"dic === %@", dic);
        if (![str isEqualToString:@""]) {
            date = [self objectFromJSONString:str][@"open_cursor"][0][@"SYS_TIME"];
            date1 = [date substringToIndex:13];
            NSLog(@"%@",date1);
        } else {
            NSLog(@"没有数据返回");
        }
    }
    
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    image1 = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    Common *common=[[Common alloc] initWithView:self.view];
    if (common.isConnectionAvailable) {
        [self getServerTime];
        if (![date isEqualToString:@""]) {
            waterImage =  [self waterMarkImage:image1 withText:date1];
            
            NSString *date11 =  [[[[[[date substringToIndex:4] stringByAppendingString:[date substringWithRange:NSMakeRange(5, 2)]]stringByAppendingString:[date substringWithRange:NSMakeRange(8, 2)]]stringByAppendingString:[date substringWithRange:NSMakeRange(11, 2)]]stringByAppendingString:[date substringWithRange:NSMakeRange(14, 2)]]stringByAppendingString:[date substringWithRange:NSMakeRange(17, 2)]];
            photoName1 = [NSString stringWithFormat:@"%@.jpg",[@"2" stringByAppendingString:[self.UploadReportcode stringByAppendingString:date11]]];
            NSLog(@"y----%@-------",photoName1);
        }
    }else{
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy.MM.dd HH:mm:ss"];
        strDate = [dateFormatter stringFromDate:[NSDate date]];
        date2 = [strDate substringToIndex:13];
        NSLog(@"%@=================================",date2);
        
        waterImage =  [self waterMarkImage:image1 withText:date2];
        
        NSString *date12 =  [[[[[[strDate substringToIndex:4] stringByAppendingString:[strDate substringWithRange:NSMakeRange(5, 2)]]stringByAppendingString:[strDate substringWithRange:NSMakeRange(8, 2)]]stringByAppendingString:[strDate substringWithRange:NSMakeRange(11, 2)]]stringByAppendingString:[strDate substringWithRange:NSMakeRange(14, 2)]]stringByAppendingString:[strDate substringWithRange:NSMakeRange(17, 2)]];
        photoName1 = [NSString stringWithFormat:@"%@.jpg",[@"2" stringByAppendingString:[self.UploadReportcode  stringByAppendingString:date12]]];
        
    }
        //UIImageWriteToSavedPhotosAlbum(waterImage, nil, nil, nil); //保存图片至相册
    NSString *fullPath = [self saveImage:waterImage WithName:photoName1];
    [photoArry addObject:fullPath];//水印图片集合
    [tempArr addObject:photoName1];//图片名字集合
    [lat addObject:lat1];
    [lon addObject:lon1];
    NSLog(@"%@,%@,%@,%@",photoArry,tempArr,lat,lon);
    [_collectionView reloadData];
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    if (photoArry.count > 5){
        button.userInteractionEnabled=NO;
        [HUDManager showMessage:@"最多拍照6张图片" duration:1];
    }
    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker

{
    
    [self dismissViewControllerAnimated:YES completion:^{}];
    
}



- (UIImage *)scaleImage:(UIImage *)image toScale:(float)scaleSize{
    UIGraphicsBeginImageContext(CGSizeMake(image.size.width * scaleSize, image.size.height * scaleSize));
    [image drawInRect:CGRectMake(0, 0, image.size.width * scaleSize, image.size.height * scaleSize)];
    UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return scaledImage;
}
#pragma mark 保存图片到document
- (NSString *)saveImage:(UIImage *)tempImage WithName:(NSString *)imageName
{
        //对图片大小进行压缩--
        // tempImage = [self imageWithImage:tempImage scaledToSize:imagesize];
    tempImage = [self scaleImage:tempImage toScale:0.3];
    NSData *imageData = UIImageJPEGRepresentation(tempImage,0.5);
    
        //NSData* imageData = UIImageJPEGRepresentation(tempImage, 0.1f);
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString* documentsDirectory = [paths objectAtIndex:0];
        // 图片的沙盒里的路径
    NSString* fullPathToFile = [documentsDirectory stringByAppendingPathComponent:imageName];
    [imageData writeToFile:fullPathToFile atomically:NO];
    return fullPathToFile;
}


-(NSString *)deleteFile:(NSString *)imageName {
    NSFileManager* fileManager=[NSFileManager defaultManager];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    
        //文件名
    NSString *uniquePath=[[paths objectAtIndex:0] stringByAppendingPathComponent:imageName];
    BOOL blHave=[[NSFileManager defaultManager] fileExistsAtPath:uniquePath];
    if (!blHave) {
        NSLog(@"no  have");
        return  imageName;
    }else {
        NSLog(@" have");
        BOOL blDele= [fileManager removeItemAtPath:uniquePath error:nil];
        if (blDele) {
            NSLog(@"dele success");
        }else {
            NSLog(@"dele fail");
        }
        
    }
    return imageName;
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
-(void)uploadPhoto{
    [_locService stopUserLocationService];
    Common *common=[[Common alloc] initWithView:self.view];
    if (common.isConnectionAvailable) {
        __block NSString *PHOTO_NM ;
        __block NSString *LONGITUDE;
        __block NSString *LATITUDE;
        __block NSString *GPSERRORCODE;
        __block NSString *GPSERRORMSG;
        __block NSUInteger number = 0;
        PHOTO_NM=@"";//图片名字
        LONGITUDE=@""; //经度
        LATITUDE =@"";//纬度
        GPSERRORCODE = @"";//gps采点状态码
        GPSERRORMSG = @"";//gps采点状态说明
        
        if(tempArr.count>0){
                // {
                //        @try {
                //[HUDManager showIndeterminateWithMessage:@"正在上传..."];
            for (int i = 0; i < tempArr.count; i++) {
                
                __block NSString *imagePath=nil;
                NSLog(@"%@",tempArr[i]);
                imagePath=[photofilepath stringByAppendingString:tempArr[i]];
                    //typeof(self) __weak weakSelf = self;
                LxFTPRequest * request = [LxFTPRequest uploadRequest];
                request.username = USERNAME;
                request.password = PASSWORD;
                
                request.serverURL = [[NSURL URLWithString:FTP_ADDRESS]URLByAppendingPathComponent:imagePath];
                NSString *localFilePath = [NSString stringWithFormat:@"%@/Documents/%@",NSHomeDirectory(),tempArr[i]];
                NSLog(@"%@",localFilePath);
                
                request.localFileURL = [NSURL fileURLWithPath:localFilePath];
                
                [request start];
                _progressHUD = [JGProgressHUD progressHUDWithStyle:JGProgressHUDStyleDark];
                _progressHUD.indicatorView = [[JGProgressHUDPieIndicatorView alloc]init];
                    //_progressHUD.progress = 0;
                    //                typeof(weakSelf) __strong strongSelf = weakSelf;
                    //                [_progressHUD showInView:strongSelf.view animated:YES];
                
                request.progressAction = ^(NSInteger totalSize, NSInteger finishedSize, CGFloat finishedPercent) {
                    NSLog(@"totalSize = %ld, finishedSize = %ld, finishedPercent = %f", (long)totalSize, (long)finishedSize, finishedPercent);  //
                    totalSize = MAX(totalSize, finishedSize);
                    _progressHUD.progress = (CGFloat)finishedSize / (CGFloat)totalSize;
                    [_progressHUD showInView:self.view animated:YES];
                };
                
                request.successAction = ^(Class resultClass, id result) {
                    NSLog(@"%@",result);
                    PHOTO_NM=[PHOTO_NM stringByAppendingString:[NSString stringWithFormat:@"%@AA",tempArr[i]]];
                    
                    LONGITUDE=[LONGITUDE stringByAppendingString:[NSString stringWithFormat:@"%@AA",lon[i]]];
                    
                    LATITUDE=[LATITUDE stringByAppendingString:[NSString stringWithFormat:@"%@AA",lat[i]]];
                    GPSERRORCODE=[GPSERRORCODE stringByAppendingString:[NSString stringWithFormat:@"%@AA",@""]];
                    GPSERRORMSG = [GPSERRORMSG stringByAppendingString:[NSString stringWithFormat:@"%@AA",in_gpserrormsg]];
                    NSLog(@"%@,%@,%@,%@,%@======================",PHOTO_NM,LONGITUDE,LATITUDE,GPSERRORCODE,GPSERRORMSG);
                    [_progressHUD dismissAnimated:YES];
                    number = number + 1;
                    NSLog(@"%lu",(unsigned long)number);
                    
                    
                    NSLog(@"y------%@-------------",result);
                    
                    NSLog(@"1111111----------------%lu",(unsigned long)number);
                    
                    if (tempArr.count == number  ) {
                        NSLog(@"成功");
                            //图片上传成功！ 关联数据表中数据
                        [self communicateServiceWithIN_PHOTO_NM:PHOTO_NM andIN_P_LONGITUDE:LONGITUDE andIN_P_LATITUDE:LATITUDE andIN_GPSERRORCODE:GPSERRORCODE andIN_GPSERRORMSG:GPSERRORCODE];
                    }else{
                        [_progressHUD dismissAnimated:YES];
                        [_progressHUD dismiss];
                    }
                    
                };
                request.failAction = ^(CFStreamErrorDomain domain, NSInteger error, NSString * errorMessage) {
                    
                    [_progressHUD dismissAnimated:YES];
                    NSLog(@"domain = %ld, error = %ld, errorMessage = %@", domain, (long)error, errorMessage);    //
                                                                                                                  //[HUDManager showMessage:@"FTP上传失败" duration:1];
                };
                
            }
        }else{
            [HUDManager showMessage:@"请添加照片" duration:1];
        }
        
    }
    else
        {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:@"网络环境较差，是否保存以后再上传(务必在30天内上传)？" preferredStyle:UIAlertControllerStyleAlert];
        [alert loadViewIfNeeded];
        [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
                // 点击确定按钮的时候, 会调用这个block
            
            NSMutableArray *array=[[NSMutableArray alloc]init];
            NSMutableArray *array1=[[NSMutableArray alloc]init];
            
            AppDelegate *delegate = [UIApplication sharedApplication].delegate;
            for (int i = 0; i < tempArr.count; i++) {
                NSString *IN_SABEON=delegate.userInfo1.pernr;
                NSString *IN_REPORT_CODE=self.UploadReportcode;
                NSString *IN_PHOTO_NM=tempArr[i];
                NSString *IN_P_LONGITUDE=lon[i];
                NSString *IN_P_LATITUDE=lat[i];
                NSString *IN_GPSERRORCODE=@"";
                NSString *IN_GPSERRORMSG=in_gpserrormsg;
                NSString *PhotoPath=photoArry[i];
                
                
                [array   addObject:IN_SABEON];
                [array   addObject:IN_REPORT_CODE];
                [array   addObject:IN_PHOTO_NM];
                [array   addObject:IN_P_LONGITUDE];
                [array   addObject:IN_P_LATITUDE];
                [array   addObject:IN_GPSERRORCODE];
                [array   addObject:IN_GPSERRORMSG];
                [array   addObject:PhotoPath];
            }
                //把数据写入plist文件
            NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
            NSString *path=[paths     objectAtIndex:0];
            NSString *filename=[path stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.plist",_UploadReportcode]];
            [array writeToFile:filename   atomically:YES];
            
            NSLog(@"%@",array);
            
            NSDateFormatter *formatDay = [[NSDateFormatter alloc] init];
            formatDay.dateFormat = @"yyyy-MM-dd HH:mm:ss";
            NSString *dayStr = [formatDay stringFromDate:[NSDate date]];
            NSString *filename1=[path stringByAppendingPathComponent:[NSString stringWithFormat:@"1%@.plist",_UploadReportcode]];
            [array1 addObject:dayStr];
            [array1 writeToFile:filename1  atomically:YES];
            NSLog(@"%@",array1);
            [self.navigationController popViewControllerAnimated:YES];
            
        }]];
        [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
        
        [self presentViewController:alert animated:YES completion:nil];
        
            //[HUDManager showMessage:@"请添加照片" duration:1];
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
-(void) communicateServiceWithIN_PHOTO_NM:(NSString *) IN_PHOTO_NM andIN_P_LONGITUDE:(NSString *) IN_P_LONGITUDE andIN_P_LATITUDE:(NSString *) IN_P_LATITUDE andIN_GPSERRORCODE:(NSString *) IN_GPSERRORCODE andIN_GPSERRORMSG:(NSString *) IN_GPSERRORMSG{
    
    Common *common=[[Common alloc] initWithView:self.view];
    if (common.isConnectionAvailable) {
        AppDelegate *delegate = [UIApplication sharedApplication].delegate;
        NSLog(@"%@,%@",delegate.userInfo1.pernr,self.UploadReportcode);
        
        NSDictionary *dic = @{
                              @"IN_SABEON":delegate.userInfo1.pernr,
                              @"IN_REPORT_CODE":self.UploadReportcode,
                              @"IN_PHOTO_NM" :IN_PHOTO_NM,
                              @"IN_P_LONGITUDE":IN_P_LONGITUDE,
                              @"IN_P_LATITUDE":IN_P_LATITUDE,
                              @"IN_GPSERRORCODE":IN_GPSERRORCODE,
                              @"IN_GPSERRORMSG" :IN_GPSERRORMSG
                              };
        NSString *string = @"http://118.102.25.56:8080/HM/photo/report_photoinfo.do";
        [[AFHTTPRequestOperationManager manager] POST:string parameters:dic success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
            
            NSLog(@"%@",responseObject[@"open_cursor"][0][@"OUT_RESULT"]);
            NSNumber *result = responseObject[@"open_cursor"][0][@"OUT_RESULT"];
            NSString *result1 = result.description;
            if ([result1 isEqualToString:@"0"]) {
                
                [HUDManager showSuccessWithMessage:@"图片上传成功" duration:1 complection:^{
                    
                        //[self deletePhoto];
                    for (NSInteger i = 0; i < tempArr.count; i++) {
                        [self deleteFile:tempArr[i]];
                    }
                        //[self.navigationController popViewControllerAnimated:YES];
                    [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:1] animated:YES];
                }];
            }
            
        } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
            NSLog(@"error:%@----%@",error.localizedFailureReason,error.localizedDescription);
                // [HUDManager showSuccessWithMessage:@"" duration:1 complection:^{
            
                //[self deletePhoto];
                //            [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:1] animated:YES];
                //}];
            [HUDManager showMessage:@"图片上传失败" duration:1];
        }];
        
        
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
        // Dispose of any resources that can be recreated.
}
#pragma mark -- UICollectionViewDataSource

    //定义展示的UICollectionViewCell的个数
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    NSLog(@"%lu",(unsigned long)photoArry.count);
    return photoArry.count;
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
    imgView1 = (UIImageView *)[cell viewWithTag:200] ;
        // UIImageView *imgView = (UIImageView *)cell ;
    UIImage *savedImage = [[UIImage alloc] initWithContentsOfFile:photoArry[indexPath.row]];
    NSLog(@"%@-----------------------------------------",savedImage);
    if (!imgView1) {
        imgView1 = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 90, 90)];
        imgView1.tag = 200;
        [cell addSubview:imgView1];
        imgView1.image = savedImage;
    } else {
        imgView1.image = savedImage;
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
    imageView.image = [UIImage imageNamed:photoArry[indexPath.row]];
    imageView.frame = CGRectMake(0, 0, imageView.image.size.width, imageView.image.size.height);
    [TXBSJAvatarBrowser showImage:imageView];
    
}


/**
 * 协议中的方法，获取返回按钮的点击事件
 */
- (BOOL)navigationShouldPopOnBackButton
{
    
    
    if (tempArr.count == 0) {
        [self.navigationController popViewControllerAnimated:YES];
    }
    if (tempArr.count >= 1) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"退出将清空照片,导致无法上传,是否继续退出?"  preferredStyle:UIAlertControllerStyleAlert];
        [alert loadViewIfNeeded];
        [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
                // 点击确定按钮的时候, 会调用这个block
            for (NSInteger i = 0; i < photoArry.count; i++) {
                NSLog(@"%@",tempArr[i]);
                [self deleteFile:tempArr[i]];
            }
            [self.navigationController popViewControllerAnimated:YES];
        }]];
        [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
        
        [self presentViewController:alert animated:YES completion:nil];
        
    }
    return NO;
    
}


@end
