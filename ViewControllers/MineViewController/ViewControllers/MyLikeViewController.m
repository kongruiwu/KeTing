//
//  MyLikeViewController.m
//  KeTing
//
//  Created by 吴孔锐 on 2017/7/3.
//  Copyright © 2017年 wurui. All rights reserved.
//

#import "MyLikeViewController.h"
#import <HMSegmentedControl.h>
#import "MyLikeSubViewController.h"
@interface MyLikeViewController ()<UIScrollViewDelegate>

@property (nonatomic, strong) HMSegmentedControl * segmentControl;
@property (nonatomic, strong) UIScrollView * mainScroll;
@property (nonatomic, strong) NSArray * titles;
@property (nonatomic, strong) NSMutableArray * viewControllers;
@property (nonatomic, assign) NSInteger indexNum;
@end

@implementation MyLikeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self drawBackButtonWithType:BackImgTypeBlack];
    [self setNavTitle:@"我赞过的" color:KTColor_MainBlack];
    [self creatUI];
    
}
- (void)creatUI{
    self.indexNum = 0;
    
    self.viewControllers = [NSMutableArray new];
    self.titles = @[@"财经头条",@"书籍",@"订阅"];
    self.segmentControl = [[HMSegmentedControl alloc]initWithSectionTitles:self.titles];
    self.segmentControl.frame = CGRectMake(0, 64, UI_WIDTH, Anno750(90));
    //设置字体
    self.segmentControl.titleTextAttributes = @{NSFontAttributeName : [UIFont systemFontOfSize:font750(30)],
                                                NSForegroundColorAttributeName : KTColor_lightGray};
    self.segmentControl.selectedTitleTextAttributes = @{NSFontAttributeName : [UIFont systemFontOfSize:font750(30)],
                                                        NSForegroundColorAttributeName : KTColor_MainOrange};
    
    //设置移动线条属性
    self.segmentControl.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocationDown;
    self.segmentControl.selectionIndicatorHeight = Anno750(4);
    self.segmentControl.selectionIndicatorColor = KTColor_MainOrange;
    [self.view addSubview:self.segmentControl];
    
    UIView * lineView = [KTFactory creatLineView];
    [self.segmentControl addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@0);
        make.right.equalTo(@0);
        make.bottom.equalTo(@0);
        make.height.equalTo(@0.5);
    }];
    
    self.mainScroll = [[UIScrollView alloc]initWithFrame:CGRectMake(0, Anno750(90)+64, UI_WIDTH,  UI_HEGIHT - 64 - Anno750(90))];
    self.mainScroll.contentSize = CGSizeMake(self.titles.count * UI_WIDTH, 0);
    [self.mainScroll autoresizingMask];
    self.mainScroll.pagingEnabled = YES;
    self.mainScroll.showsVerticalScrollIndicator = NO;
    self.mainScroll.showsHorizontalScrollIndicator = NO;
    self.mainScroll.backgroundColor = KTColor_BackGround;
    self.mainScroll.delegate = self;
    [self.view addSubview:self.mainScroll];
    
    for (int i = 0 ; i<self.titles.count; i++) {
        if (self.indexNum  == i) {
            MyLikeSubViewController *vc = [MyLikeSubViewController new];
            vc.subType = i;
            vc.view.frame = CGRectMake(UI_WIDTH * i, 0, UI_WIDTH , UI_HEGIHT - 64 - Anno750(90));
            [self.mainScroll addSubview:vc.view];
            [self addChildViewController:vc];
            [self.viewControllers addObject:vc];
        }else{
            [self.viewControllers addObject:@"OderStatusViewController"];
        }
        
    }
    
    //这里 是是用时进行创建 避免内存浪费
    __weak MyLikeViewController * weakSelf = self;
    [self.segmentControl setIndexChangeBlock:^(NSInteger index) {
        if (![weakSelf.viewControllers[index] isKindOfClass:[UIViewController class]]) {
            MyLikeSubViewController *vc = [MyLikeSubViewController new];
            vc.subType = index;
            vc.view.frame = CGRectMake(UI_WIDTH * index, 0, UI_WIDTH , UI_HEGIHT - 64 - Anno750(90));
            [weakSelf.mainScroll addSubview:vc.view];
            [weakSelf addChildViewController:vc];
            [weakSelf.viewControllers replaceObjectAtIndex:index withObject:vc];
        }
        [UIView animateWithDuration:0.3f animations:^{
            weakSelf.mainScroll.contentOffset = CGPointMake(UI_WIDTH * index, 0);
        }];
    }];
    [self.segmentControl setSelectedSegmentIndex:self.indexNum];
    self.mainScroll.contentOffset = CGPointMake(self.indexNum * UI_WIDTH, 0);
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    int index = scrollView.contentOffset.x / UI_WIDTH;
    [self.segmentControl setSelectedSegmentIndex:index animated:YES];
    if (![self.viewControllers[index] isKindOfClass:[UIViewController class]]) {
        MyLikeSubViewController *vc = [MyLikeSubViewController new];
        vc.subType = index;
        vc.view.frame = CGRectMake(UI_WIDTH * index, 0, UI_WIDTH ,UI_HEGIHT - 64 - Anno750(90));
        [self.mainScroll addSubview:vc.view];
        [self addChildViewController:vc];
        [self.viewControllers replaceObjectAtIndex:index withObject:vc];
    }
}


@end
