//
//  HMSegmentViewController.m
//  KeTing
//
//  Created by 吴孔锐 on 2017/6/5.
//  Copyright © 2017年 wurui. All rights reserved.
//

#import "HMSegmentViewController.h"

#import "SelectedViewController.h"

#import "TimeListenViewController.h"

#import "SubscribeViewController.h"

#import "FindViewController.h"

#import "MineViewController.h"

@interface HMSegmentViewController ()<UIScrollViewDelegate>

@property (nonatomic, strong) HMSegmentedControl * hmsgControl;
@property (nonatomic, strong) UIScrollView * mainScroll;
@property (nonatomic, assign) NSInteger indexNum;
@property (nonatomic, strong) NSMutableArray * viewControllers;

@end

@implementation HMSegmentViewController
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.backgroundColor = [UIColor whiteColor];
    self.navigationController.navigationBar.translucent = YES;
    UIView * clearView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, UI_WIDTH, 20)];
    clearView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:clearView];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:0];
    self.navigationController.navigationBar.shadowImage=[UIImage new];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self creatUI];
}

- (void)creatUI{
    self.indexNum = 0;
    self.viewControllers = [NSMutableArray new];
    self.navigationController.navigationBar.backgroundColor = [UIColor whiteColor];
    
    NSArray * titles = @[@"精选",@"随时听",@"订阅",@"发现"];
    self.hmsgControl = [[HMSegmentedControl alloc]initWithSectionTitles:titles];
    self.hmsgControl.frame = CGRectMake(0, 0, Anno750(570), Anno750(80));
    
    self.hmsgControl.titleTextAttributes = @{
                                             NSFontAttributeName : [UIFont systemFontOfSize:font750(32)],
                                             NSForegroundColorAttributeName : KTColor_MainBlack};
    self.hmsgControl.selectedTitleTextAttributes = @{
                                                     NSFontAttributeName : [UIFont systemFontOfSize:font750(32)],
                                                     NSForegroundColorAttributeName : KTColor_MainOrange};
    
    self.hmsgControl.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocationDown;
    self.hmsgControl.selectionIndicatorHeight = Anno750(4);
    self.hmsgControl.selectionIndicatorColor = KTColor_MainOrange;
    
    self.navigationItem.titleView = self.hmsgControl;
 
    UIImage * headImage = [[UIImage imageNamed:@"Nav_head"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIImage * searchImg = [[UIImage imageNamed:@"nav_search"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    UIBarButtonItem * leftItem = [[UIBarButtonItem alloc]initWithImage:headImage style:UIBarButtonItemStylePlain target:self action:@selector(checkUserInfo)];
    UIBarButtonItem * rightItem = [[UIBarButtonItem alloc]initWithImage:searchImg style:UIBarButtonItemStylePlain target:self action:@selector(toSearchViewController)];
    
    self.navigationItem.leftBarButtonItem = leftItem;
    self.navigationItem.rightBarButtonItem = rightItem;
    
    self.mainScroll = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, UI_WIDTH,  UI_HEGIHT)];
    self.mainScroll.contentSize = CGSizeMake(titles.count * UI_WIDTH, 0);
    [self.mainScroll autoresizingMask];
    self.mainScroll.pagingEnabled = YES;
    self.mainScroll.showsVerticalScrollIndicator = NO;
    self.mainScroll.showsHorizontalScrollIndicator = NO;
    self.mainScroll.backgroundColor = KTColor_BackGround;
    self.mainScroll.delegate = self;
    [self.view addSubview:self.mainScroll];
    
    SelectedViewController * vc = [[SelectedViewController alloc]init];
    vc.view.frame = CGRectMake(0, 0, UI_WIDTH, UI_HEGIHT );
    [self.mainScroll addSubview:vc.view];
    [self addChildViewController:vc];
    [self.viewControllers addObject:vc];
    [self.viewControllers addObject:@"TimeListenViewController"];
    [self.viewControllers addObject:@"SubscribeViewController"];
    [self.viewControllers addObject:@"FindViewController"];
    
    __weak HMSegmentViewController * weakself = self;
    [self.hmsgControl setIndexChangeBlock:^(NSInteger index) {
        if (![weakself.viewControllers[index] isKindOfClass:[UIViewController class]]) {
            BaseViewController * vc ;
            if (index == 1) {
                vc = [TimeListenViewController new];
            }else if(index == 2){
                vc = [SubscribeViewController new];
            }else if(index == 3){
                vc = [FindViewController new];
            }
            vc.view.frame = CGRectMake(index * UI_WIDTH, 0, UI_WIDTH, UI_HEGIHT );
            [weakself.mainScroll addSubview:vc.view];
            [weakself addChildViewController:vc];
            [weakself.viewControllers replaceObjectAtIndex:index withObject:vc];
        }
        CGPoint point = weakself.mainScroll.contentOffset;
        [UIView animateWithDuration:0.3f animations:^{
            weakself.mainScroll.contentOffset = CGPointMake(UI_WIDTH * index,point.y);
        }];
    }];
    [self.hmsgControl setSelectedSegmentIndex:self.indexNum];
    self.mainScroll.contentOffset = CGPointMake(self.indexNum * UI_WIDTH, 0);
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    int index = scrollView.contentOffset.x / UI_WIDTH;
    [self.hmsgControl setSelectedSegmentIndex:index animated:YES];
    
    if (![self.viewControllers[index] isKindOfClass:[UIViewController class]]) {
        BaseViewController * vc ;
        if (index == 1) {
            vc = [TimeListenViewController new];
        }else if(index == 2){
            vc = [SubscribeViewController new];
        }else if(index == 3){
            vc = [FindViewController new];
        }
        vc.view.frame = CGRectMake(index * UI_WIDTH, 0, UI_WIDTH, UI_HEGIHT);
        [self.mainScroll addSubview:vc.view];
        [self addChildViewController:vc];
        [self.viewControllers replaceObjectAtIndex:index withObject:vc];
    }
}
- (void)checkUserInfo{
    [self.navigationController pushViewController:[MineViewController new] animated:YES];
}
- (void)toSearchViewController{
    
}

@end
