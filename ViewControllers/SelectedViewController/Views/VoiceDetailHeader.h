//
//  VoiceDetailHeader.h
//  KeTing
//
//  Created by 吴孔锐 on 2017/6/13.
//  Copyright © 2017年 wurui. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ConfigHeader.h"
@interface VoiceDetailHeader : UIView

@property (nonatomic, strong) UIImageView * groundImg;
@property (nonatomic, strong) UIView * navView;
@property (nonatomic, strong) UIButton * backBtn;
@property (nonatomic, strong) UIButton * shareBtn;
@property (nonatomic, strong) UIButton * shopCar;
@property (nonatomic, strong) UIView * grayView;
@property (nonatomic, strong) UILabel * nameLabel;
@property (nonatomic, strong) UILabel * countLabel;
@property (nonatomic, strong) UIButton * checkSummy;

- (void)updateWithImage:(NSString *)imgurl title:(NSString *)title;
- (void)updateShopCarCount:(NSString *)count;
@end
