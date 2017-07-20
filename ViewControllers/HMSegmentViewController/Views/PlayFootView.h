//
//  PlayFootView.h
//  KeTing
//
//  Created by 吴孔锐 on 2017/7/20.
//  Copyright © 2017年 wurui. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ConfigHeader.h"
@interface PlayFootView : UIView

@property (nonatomic, strong) UIImageView * leftImg;
@property (nonatomic, strong) UILabel * nameLabel;
@property (nonatomic, strong) UIButton * nextBtn;
@property (nonatomic, strong) UIButton * playBtn;
@property (nonatomic, strong) UIButton * listBtn;
@property (nonatomic, strong) UIProgressView * progressView;
@property (nonatomic, strong) UIView * line;
@property (nonatomic, strong) UIButton * clearButton;
/**计时器*/
@property (nonatomic, strong) NSTimer * timer;
- (void)changePlayStatus;
@end
