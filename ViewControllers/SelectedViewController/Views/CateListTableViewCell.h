//
//  CateListTableViewCell.h
//  KeTing
//
//  Created by 吴孔锐 on 2017/6/9.
//  Copyright © 2017年 wurui. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ConfigHeader.h"
#import "TopTagModel.h"
@interface CateListTableViewCell : UITableViewCell

@property (nonatomic, strong) UILabel * leftName;
@property (nonatomic, strong) UIImageView * seletImg;
@property (nonatomic, strong) UIView * bottomLine;

- (void)updateWithModel:(TopTagModel *)model;
@end
