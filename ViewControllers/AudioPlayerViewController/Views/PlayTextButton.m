//
//  PlayTextButton.m
//  KeTing
//
//  Created by 吴孔锐 on 2017/6/8.
//  Copyright © 2017年 wurui. All rights reserved.
//

#import "PlayTextButton.h"

@implementation PlayTextButton

- (void)layoutSubviews{
    [super layoutSubviews];
    UIImage * img = self.imageView.image;
    self.imageView.frame = CGRectMake((self.bounds.size.width - img.size.width)/2, (Anno750(50) - img.size.height)/2, img.size.width, img.size.height);
    self.titleLabel.frame = CGRectMake(0, Anno750(60), PlayWidth, Anno750(30));
}


@end
