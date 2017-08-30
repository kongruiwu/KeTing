//
//  AnchorHeader.h
//  KeTing
//
//  Created by 吴孔锐 on 2017/6/14.
//  Copyright © 2017年 wurui. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ConfigHeader.h"
#import "AnchorModel.h"
@interface AnchorHeader : UIView

@property (nonatomic, strong) UIImageView * groundImg;

@property (nonatomic, strong) UIImageView * userIcon;
@property (nonatomic, strong) UILabel * username;
@property (nonatomic, strong) UILabel * descLabel;

- (void)updateWithAnchorModel:(AnchorModel *)model;
@end
