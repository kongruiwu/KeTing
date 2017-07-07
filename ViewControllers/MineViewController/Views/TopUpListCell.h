//
//  TopUpListCell.h
//  KeTing
//
//  Created by 吴孔锐 on 2017/6/30.
//  Copyright © 2017年 wurui. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ConfigHeader.h"
#import "TopUpModel.h"
@interface TopUpListCell : UITableViewCell

@property (nonatomic, strong) UILabel * namelabel;
@property (nonatomic, strong) UILabel * timeLabel;
@property (nonatomic, strong) UILabel * moneyLabel;
@property (nonatomic, strong) UIView * bottomLine;
- (void)updateWithModel:(TopUpModel *)model isTopUp:(BOOL)rec;
@end
