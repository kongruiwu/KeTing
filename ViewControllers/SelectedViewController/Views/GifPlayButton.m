//
//  GifPlayButton.m
//  KeTing
//
//  Created by 吴孔锐 on 2017/9/12.
//  Copyright © 2017年 wurui. All rights reserved.
//

#import "GifPlayButton.h"

@implementation GifPlayButton

+ (instancetype)buttonWithType:(UIButtonType)buttonType{
    GifPlayButton * button = [super buttonWithType:buttonType];
    if (button) {
        button.playImgView = [[FLAnimatedImageView alloc]init];
        NSURL *url1 = [[NSBundle mainBundle] URLForResource:@"home_playing@2x" withExtension:@"gif"];
        NSData *data1 = [NSData dataWithContentsOfURL:url1];
        FLAnimatedImage * animatedImage1 = [FLAnimatedImage animatedImageWithGIFData:data1];
        button.playImgView.animatedImage = animatedImage1;
        [button addSubview:button.playImgView];
    }
    return button;
}

- (void)setSelected:(BOOL)selected{
    [super setSelected:selected];
    self.playImgView.hidden = !selected;
    if (selected) {
        [self.playImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.imageView.mas_centerX);
            make.centerY.equalTo(self.imageView.mas_centerY);
            make.width.equalTo(@(Anno750(20)));
            make.height.equalTo(@(Anno750(20)));
        }];
    }
     
}
@end
