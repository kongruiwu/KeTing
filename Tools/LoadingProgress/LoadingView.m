//
//  LoadingView.m
//  KeTing
//
//  Created by 吴孔锐 on 2017/7/25.
//  Copyright © 2017年 wurui. All rights reserved.
//

#import "LoadingView.h"
#import "ConfigHeader.h"
@implementation LoadingView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self creatUI];
    }
    return self;
}
- (void)creatUI{
    
    self.backgroundColor = [UIColor clearColor];
    
    self.loadingImg = [[FLAnimatedImageView alloc]init];
    [self addSubview:self.loadingImg];
    NSURL *url1 = [[NSBundle mainBundle] URLForResource:@"loading" withExtension:@"gif"];
    NSData *data1 = [NSData dataWithContentsOfURL:url1];
    FLAnimatedImage *animatedImage1 = [FLAnimatedImage animatedImageWithGIFData:data1];
    self.loadingImg.animatedImage = animatedImage1;
    [self.loadingImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(@0);
        make.top.equalTo(@(Anno750(350)));
        make.width.equalTo(@(Anno750(300)));
        make.height.equalTo(@(Anno750(300)));
    }]; 

}
@end
