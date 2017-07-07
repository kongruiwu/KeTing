//
//  HomeCollectionCell.m
//  KeTing
//
//  Created by 吴孔锐 on 2017/6/5.
//  Copyright © 2017年 wurui. All rights reserved.
//

#import "HomeCollectionCell.h"
#import "ListenBookCollectionCell.h"
@implementation HomeCollectionCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self creatUI];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}
- (void)creatUI{
    self.FirstView = [[ListenBookCollectionCell alloc]init];
    self.SecndView = [[ListenBookCollectionCell alloc]init];
    self.ThirdView = [[ListenBookCollectionCell alloc]init];
    
    [self.FirstView.clickBtn addTarget:self action:@selector(checkBookFirst) forControlEvents:UIControlEventTouchUpInside];
    [self.SecndView.clickBtn addTarget:self action:@selector(checkBookSecond) forControlEvents:UIControlEventTouchUpInside];
    [self.ThirdView.clickBtn addTarget:self action:@selector(checkBookThird) forControlEvents:UIControlEventTouchUpInside];
    
    [self addSubview:self.FirstView];
    [self addSubview:self.SecndView];
    [self addSubview:self.ThirdView];
    
}
- (void)layoutSubviews{
    [super layoutSubviews];
    
    [self.FirstView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(Anno750(24)));
        make.top.equalTo(@(Anno750(10)));
        make.height.equalTo(@(Anno750(410)));
        make.width.equalTo(@(Anno750(188)));
    }];
    [self.SecndView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(@0);
        make.top.equalTo(@(Anno750(10)));
        make.height.equalTo(@(Anno750(410)));
        make.width.equalTo(@(Anno750(188)));
    }];
    [self.ThirdView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(@(-Anno750(24)));
        make.top.equalTo(@(Anno750(10)));
        make.height.equalTo(@(Anno750(410)));
        make.width.equalTo(@(Anno750(188)));
    }];
    
}


- (void)updateWithArray:(NSArray *)dataArray{
    for (int i = 0; i<dataArray.count; i++) {
        if (i == 0) {
            [self.FirstView updateWithListenModel:dataArray[i]];
        }else if(i == 1){
            [self.SecndView updateWithListenModel:dataArray[i]];
        }else if(i == 2){
            [self.ThirdView updateWithListenModel:dataArray[i]];
        }
    }
    self.SecndView.hidden = NO;
    self.ThirdView.hidden = NO;
    if (dataArray.count == 1) {
        self.SecndView.hidden = YES;
        self.ThirdView.hidden = YES;
    }else if(dataArray.count == 2){
        self.ThirdView.hidden = YES;
    }
}
- (void)checkBookFirst{
    if ([self.delegate respondsToSelector:@selector(checkBookAtIndex:)]) {
        [self.delegate checkBookAtIndex:0];
    }
}
- (void)checkBookSecond{
    if ([self.delegate respondsToSelector:@selector(checkBookAtIndex:)]) {
        [self.delegate checkBookAtIndex:1];
    }
}
- (void)checkBookThird{
    if ([self.delegate respondsToSelector:@selector(checkBookAtIndex:)]) {
        [self.delegate checkBookAtIndex:2];
    }
}

@end
