//
//  PhotoDetailViewController.m
//  hd
//
//  Created by hongxianyu on 2016/10/26.
//  Copyright © 2016年 com.hxy. All rights reserved.
//

#import "PhotoDetailViewController.h"
#import "UIImageView+WebCache.h"

#import "XKCollectionViewCell.h"
#import "TXBSJAvatarBrowser.h"
#import "MJRefresh.h"
@interface PhotoDetailViewController (){
    NSMutableArray *imageArray;
}
@property(nonatomic,strong)NSMutableArray *photoList;
@property(nonatomic,strong)UIImageView *image;


@end

@implementation PhotoDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   self.edgesForExtendedLayout = UIRectEdgeNone;
    NSLog(@"11111111111%@",_phtotDetailRrportCode);
    imageArray = [[NSMutableArray alloc]init];
    
        //确定是水平滚动，还是垂直滚动
    UICollectionViewFlowLayout *flowLayout=[[UICollectionViewFlowLayout alloc] init];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    
    self.collectionView=[[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, mainW, mainH-55) collectionViewLayout:flowLayout];
    self.collectionView.dataSource=self;
    self.collectionView.delegate=self;
    [self.collectionView setBackgroundColor:[UIColor clearColor]];
    
//        //注册Cell，必须要有
//    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"UICollectionViewCell"];
    [self.collectionView registerNib:[UINib nibWithNibName:@"XKCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"imageViewCell"];
    
    [self.view addSubview:self.collectionView];
    
    HUDManager = [[MBProgressHUDManager alloc] initWithView:self.navigationController.view];

        // [self getPhtot];
    __weak __typeof(self) weakSelf = self;
    
        // 设置回调（一旦进入刷新状态就会调用这个refreshingBlock）
    _collectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        [weakSelf getPhtot];
    }];
    
        // 马上进入刷新状态
    [_collectionView.mj_header beginRefreshing];
}
-(void)viewWillAppear:(BOOL)animated{

    [super viewWillAppear:animated];
    [self.navigationItem setTitle:@"查看照片"];
    
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    
    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:66/255.0 green:135/255.0 blue:178/255.0 alpha:1.0]];
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],NSForegroundColorAttributeName,nil]];

}

-(void)getPhtot{

    Common *common=[[Common alloc] initWithView:self.view];

    if (common.isConnectionAvailable) {
        
        NSDictionary *dic = @{
                              @"IN_REPORT_CODE":self.phtotDetailRrportCode
                              };
            //post提交
        NSString *string = @"http://118.102.25.56:8080/HM/photo/report_photolist.do";
        
        [[AFHTTPRequestOperationManager manager] POST:string parameters:dic success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
            
            NSLog(@"----%@----",string);
            NSLog(@"%@",responseObject);
         _photoList =  responseObject[@"open_cursor"];
            [self.collectionView reloadData];
                // 拿到当前的下拉刷新控件，结束刷新状态
            [_collectionView.mj_header endRefreshing];

        }failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
            NSLog(@"error:%@----%@",error.localizedFailureReason,error.localizedDescription);
                //[HUDManager showMessage:@"网络错误" duration:1];
        }];
        
    }
    
    
}


#pragma mark -- UICollectionViewDataSource

    //定义展示的UICollectionViewCell的个数
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.photoList.count;
}

    //定义展示的Section的个数
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

    //每个UICollectionView展示的内容
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dic = [self.photoList objectAtIndex:indexPath.row];
    NSLog(@"%lu==========",(unsigned long)dic.count);

    NSString *urlString = [self.photoList objectAtIndex:indexPath.row][@"PHOTO_PATH"];
    XKCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"imageViewCell" forIndexPath:indexPath];
    
    [cell.imageView sd_setImageWithURL:[NSURL URLWithString:urlString] placeholderImage:[UIImage imageNamed:@"HDlogo.png"]options:SDWebImageProgressiveDownload progress:^(NSInteger receivedSize, NSInteger expectedSize) {
        NSLog(@"当前进度：%.lf%%", (float)receivedSize / expectedSize * 100);
    } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        NSLog(@"加载完成");
    }];
    return cell;

}

#pragma mark --UICollectionViewDelegateFlowLayout

    //定义每个Item 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    return CGSizeMake(140, 140);
}

    //定义每个UICollectionView 的 margin
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(10, 10, 10, 10);
}

#pragma mark --UICollectionViewDelegate

    //UICollectionView被选中时调用的方法
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    XKCollectionViewCell * cell = (XKCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    
        //[TXBSJAvatarBrowser showImageWithUrl:[self.photoList objectAtIndex:indexPath.row][@"PHOTO_PATH"] imageView:cell.imageView];
    
    
       [TXBSJAvatarBrowser showImage:cell.imageView];
}

      //返回这个UICollectionView是否可以被选择
-(BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    [[SDImageCache sharedImageCache] setValue:nil forKey:@"memCache"];
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
