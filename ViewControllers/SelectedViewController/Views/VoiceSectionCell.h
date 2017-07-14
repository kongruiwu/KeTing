//
//  VoiceSectionCell.h
//  KeTing
//
//  Created by 吴孔锐 on 2017/7/11.
//  Copyright © 2017年 wurui. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ConfigHeader.h"
@interface VoiceSectionCell : UITableViewCell

@property (nonatomic, strong) UILabel * nameLabel;
@property (nonatomic, strong) UILabel * descLabel;
@property (nonatomic, strong) UIView * line;
- (void)updateWithName:(NSString *)name color:(UIColor *)color font:(float)font;
@end
