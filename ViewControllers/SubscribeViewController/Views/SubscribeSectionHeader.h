//
//  SubscribeSectionHeader.h
//  KeTing
//
//  Created by 吴孔锐 on 2017/6/14.
//  Copyright © 2017年 wurui. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ConfigHeader.h"
@interface ChangeButton : UIButton

@end

@interface SubscribeSectionHeader : UIView

@property (nonatomic, strong) UIView * leftview;
@property (nonatomic, strong) UILabel * nameLabel;
@property (nonatomic, strong) ChangeButton * changeBtn;

@end
