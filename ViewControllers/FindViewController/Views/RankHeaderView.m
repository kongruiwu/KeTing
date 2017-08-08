//
//  RankHeaderView.m
//  KeTing
//
//  Created by 吴孔锐 on 2017/8/7.
//  Copyright © 2017年 wurui. All rights reserved.
//

#import "RankHeaderView.h"

@implementation RankHeaderView


- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self creatUI];
    }
    return self;
}
- (void)creatUI{
    NSArray * titles = @[@"声度",@"听书"];
    self.hmsgControl = [[HMSegmentedControl alloc]initWithSectionTitles:titles];
    self.hmsgControl.frame = CGRectMake(0, 0, UI_WIDTH, Anno750(80));
    
    self.hmsgControl.titleTextAttributes = @{
                                             NSFontAttributeName : [UIFont systemFontOfSize:font750(32)],
                                             NSForegroundColorAttributeName : KTColor_darkGray};
    self.hmsgControl.selectedTitleTextAttributes = @{
                                                     NSFontAttributeName : [UIFont systemFontOfSize:font750(32)],
                                                     NSForegroundColorAttributeName : KTColor_MainOrange};
    
    self.hmsgControl.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocationDown;
    self.hmsgControl.selectionIndicatorHeight = Anno750(4);
    self.hmsgControl.selectionIndicatorColor = KTColor_MainOrange;
    
    [self addSubview:self.hmsgControl];
    
    self.lineView = [KTFactory creatLineView];
    [self.hmsgControl addSubview:self.lineView];
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(@0);
        make.width.equalTo(@0.5);
        make.centerY.equalTo(@0);
        make.height.equalTo(@(Anno750(32)));
    }];
}


@end
