//
//  KTSearchBar.m
//  KeTing
//
//  Created by 吴孔锐 on 2017/7/17.
//  Copyright © 2017年 wurui. All rights reserved.
//

#import "KTSearchBar.h"

@implementation KTSearchBar

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self creatUI];
    }
    return self;
}

- (void)creatUI{
    self.searchTf = [[UITextField alloc]initWithFrame:CGRectMake(0, 0,self.frame.size.width,self.frame.size.height)];
    self.searchTf.backgroundColor = KTColor_BackGround;
    self.searchTf.layer.cornerRadius = 4.0f;
    self.searchTf.placeholder = @"分分钟学会投资理财";
    self.searchTf.textColor = KTColor_MainBlack;
    self.searchTf.font = [UIFont systemFontOfSize:Anno750(28)];
    self.searchTf.leftViewMode = UITextFieldViewModeAlways;
    self.searchTf.rightViewMode = UITextFieldViewModeUnlessEditing;
    
    UIView * view = [KTFactory creatViewWithColor:[UIColor clearColor]];
    view.frame = CGRectMake(0, 0, Anno750(70), Anno750(65));
    UIImageView * imageView = [[UIImageView alloc]init];
    imageView.image = [UIImage imageNamed:@"nav_search"];
    [view addSubview:imageView];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(@0);
        make.centerY.equalTo(@0);
    }];
    self.searchTf.leftView = view;
    
    UIButton * cannceBtn = [KTFactory creatButtonWithNormalImage:@"" selectImage:@""];
    [cannceBtn addTarget:self action:@selector(clearTextFieldText) forControlEvents:UIControlEventTouchUpInside];
    self.searchTf.rightView = cannceBtn;
    
    [self addSubview:self.searchTf];
}
- (void)clearTextFieldText{
    self.searchTf.text = @"";
}
@end
