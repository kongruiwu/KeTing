//
//  CropViewController.m
//  防小红书 的图片剪切
//
//  Created by syf on 15/9/8.
//  Copyright (c) 2015年 SYF. All rights reserved.
//
#import "CropViewController.h"
#import "FilterGridVIew.h"
#import "UIImage+ImageFilter.h"
#import "ConfigHeader.h"

@interface CropViewController ()<UIScrollViewDelegate>
{
    CGFloat offsetY;
    CGFloat offsetX;
}
@property (weak, nonatomic) IBOutlet UIScrollView *backScroll;
@property (strong, nonatomic) UIImageView * PhotoIMg;
@property (weak, nonatomic) IBOutlet UIView *scrollView; // backScroll 的superVIew
/// yes 就是横图 no就是竖图
@property (assign, nonatomic) BOOL ISWho;// Yes 就是IMg 的宽大于高
@end

@implementation CropViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self SetUPVIewSubviews];
  
}

- (void)SetUPVIewSubviews
{
    _PhotoIMg = [[UIImageView alloc] initWithImage:self.IMg];
    _PhotoIMg.frame = CGRectMake(0, 0, _IMg.size.width, _IMg.size.height);
    _PhotoIMg.contentMode = UIViewContentModeScaleAspectFit;
    _PhotoIMg.userInteractionEnabled = YES;
    [_PhotoIMg addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(CHangeScrollBgd)]];
    [self.backScroll addSubview:_PhotoIMg];
    
    // 设置 滚出
    self.backScroll.layer.masksToBounds = NO;
    self.scrollView.layer.masksToBounds = YES;
    
    _ISWho = _IMg.size.width>_IMg.size.height;
    
    self.backScroll.contentSize = CGSizeMake(_IMg.size.width, _IMg.size.height);
    self.backScroll.frame = CGRectMake(0, (UI_HEGIHT-75-UI_WIDTH)/2, UI_WIDTH, UI_WIDTH);
    
    if(_ISWho)
         self.backScroll.minimumZoomScale = UI_WIDTH*1.0/self.IMg.size.width;
    else
        self.backScroll.minimumZoomScale = UI_WIDTH*1.0/self.IMg.size.height;
    
    // 设置filter 网格view
    FilterGridVIew * gridView = [[FilterGridVIew alloc] initWithFrame:CGRectMake(0, (UI_HEGIHT-75-UI_WIDTH)/2, UI_WIDTH, UI_WIDTH)];
    gridView.backgroundColor = [UIColor clearColor];
    [self.scrollView addSubview:gridView];
}

/// 改变scrollview 的背景颜色
- (void)CHangeScrollBgd{
    self.backScroll.backgroundColor = (self.backScroll.backgroundColor == [UIColor blackColor] ?[UIColor whiteColor]  :[UIColor blackColor]);
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    offsetY = scrollView.contentOffset.y;
    offsetX = scrollView.contentOffset.x;
//    
//    NSLog(@"scroll……contentsize:%@ frame____%@",NSStringFromCGSize(self.backScroll.contentSize),NSStringFromCGRect(self.backScroll.frame));
//    CGFloat ddfsd =  self.backScroll.zoomScale;
//    NSLog(@"scrollview的缩放系数：%f,偏移的尺寸YYY:%f,XXX:%f",ddfsd,offsetY,offsetX);
//    
 }
//告诉scrollview要缩放的是哪个子控件
 -(UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
 {
         return _PhotoIMg;
   }

- (void)scrollViewDidZoom:(UIScrollView *)scrollView
{
    
    CGSize boundsSize = scrollView.bounds.size;
    CGRect imgFrame = self.PhotoIMg.frame;
    CGSize contentSize = scrollView.contentSize;
    
    CGPoint centerPoint = CGPointMake(contentSize.width/2, contentSize.height/2);
    
    // center horizontally
    if (imgFrame.size.width <= boundsSize.width)
        centerPoint.x = boundsSize.width/2;
    
    // center vertically
    if (imgFrame.size.height <= boundsSize.height)
    centerPoint.y = boundsSize.height/2;
    
    _PhotoIMg.center = centerPoint;
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
  //  [self.backScroll setContentOffset:CGPointMake(0, (_IMg.size.height-SYFWidth)/2) animated:YES];
    self.backScroll.backgroundColor =[UIColor blackColor];

    [self.scrollView.subviews.lastObject  setHidden:NO];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = NO;
   
}

- (IBAction)cancelClicked:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
  }

- (BOOL)prefersStatusBarHidden{
    return YES;
}

- (IBAction)nextClicked {
    
UIImage * Img = [self dealWIthCropIMage];
    __weak CropViewController  * BlockSelf = self;
    [self dismissViewControllerAnimated:YES completion:^{
          if(BlockSelf.cropIMGBlock)
              BlockSelf.cropIMGBlock(Img);
    }];
    
}


- (void)dealloc{
 //   NSLog(@"是否释放");
}




//- (UIImage *)getSnapshotImage {
//    ///1. 截取整个self.view
//    UIGraphicsBeginImageContextWithOptions(CGSizeMake(CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame)), YES, 1.0);
//    //1.1 改变scrollview 的背景颜色
//        self.backScroll.backgroundColor = SYFColor(231, 230, 231);
//    //1.5 移除网格
//    [self.scrollView.subviews.lastObject  setHidden:YES];
//    
//    [self.view drawViewHierarchyInRect:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame)) afterScreenUpdates:YES];
//    UIImage *snapshot = UIGraphicsGetImageFromCurrentImageContext();
//
//    
//    //2. 截取需要的图片区域
//    CGFloat rectY = (SYFHeight - 75-SYFWidth)/2.0;
//    CGRect rect = CGRectMake(0, rectY, SYFWidth, SYFWidth);
//snapshot = [UIImage imageWithCGImage:CGImageCreateWithImageInRect(snapshot.CGImage, rect)];
//    UIGraphicsEndImageContext();
//    return snapshot;
//}
//
//-(UIImage *)screenImageWithSize:(CGSize )imgSize{
//    UIGraphicsBeginImageContext(imgSize);
//    CGContextRef context = UIGraphicsGetCurrentContext();
//    
//;//获取app的appdelegate，便于取到当前的window用来截屏
//
//[ [UIApplication sharedApplication].delegate.window.layer renderInContext:context];
//    
//    UIImage * img = UIGraphicsGetImageFromCurrentImageContext();
//    //2. 截取需要的图片区域
//    CGFloat rectY = (SYFHeight - 75-SYFWidth)/2.0;
//    CGRect rect = CGRectMake(0, rectY, SYFWidth, SYFWidth);
//      img = [UIImage imageWithCGImage:CGImageCreateWithImageInRect(img.CGImage, rect)];
//    UIGraphicsEndImageContext();
//    
//    
//    
//    return img;
//}


- (UIImage * )dealWIthCropIMage
{
     CGFloat zoom = self.backScroll.zoomScale;
    UIImage * image;
    //1. 缩放系数>=1
    if(zoom >= 1){// 竖图
       
        CGFloat XX_ =offsetX/zoom  ;
        CGFloat YY_ = offsetY/zoom;
        CGFloat WW_ = UI_WIDTH/zoom;
        CGFloat HH_ =  WW_;
        
       image  = [self.IMg SYFGetPartOfImageWithrect:CGRectMake(XX_, YY_, WW_, HH_) WIthScaleSize:CGSizeMake(UI_WIDTH, UI_WIDTH)];
}
    else if (zoom<1){// 缩放系数 <1
        
         //1. 截取背景黑色或白色的蒙版
        UIImage * mengBanIMg = [self CreteMBVIewIMg];
        
        UIImage * scaleIMg;
        if(self.ISWho){// 横图
            CGFloat XX_ =offsetX/zoom;
            CGFloat YY_ =0;
            CGFloat WW_ = UI_WIDTH/zoom;
            CGFloat HH_ =  self.IMg.size.height;
            CGRect rect = CGRectMake(XX_, YY_, WW_, HH_) ;
            // 缩放后剪切的图片
          scaleIMg = [self.IMg SYFGetPartOfImageWithrect:rect WIthScaleSize:CGSizeMake(UI_WIDTH, UI_WIDTH*zoom)];
            }
        else{//  竖图
            CGFloat XX_ =0  ;
            CGFloat YY_ =offsetY/zoom;
            CGFloat WW_ = self.IMg.size.width;
            CGFloat HH_ =  UI_WIDTH/zoom;
            CGRect rect = CGRectMake(XX_, YY_, WW_, HH_) ;
            // 缩放后剪切的图片
            scaleIMg = [self.IMg SYFGetPartOfImageWithrect:rect WIthScaleSize:CGSizeMake(UI_WIDTH*zoom, UI_WIDTH)];
        }
        image = [UIImage SYFMixIMgs:mengBanIMg toImage:scaleIMg];
        
    }
    return image;
}

- (UIImage *)CreteMBVIewIMg
{
    UIView * MBVIew = [[UIView alloc] initWithFrame:CGRectMake(-1000, 10, UI_WIDTH, UI_WIDTH)];
    MBVIew.backgroundColor = self.backScroll.backgroundColor;
    [self.view addSubview:MBVIew];
    UIImage * img = [UIImage SYFSnapshot:MBVIew];
    [MBVIew removeFromSuperview];
    return img;
}

@end
