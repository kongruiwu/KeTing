//
//  MoneyHeaderCell.h
//  KeTing
//
//  Created by 吴孔锐 on 2017/6/29.
//  Copyright © 2017年 wurui. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ConfigHeader.h"
@interface MoneyHeaderCell : UITableViewCell

@property (nonatomic, strong) UIImageView * groundImg;
@property (nonatomic, strong) UILabel * moneyNumber;
@property (nonatomic, strong) UILabel * moneyLabel;


- (void)updateWithMoneyNumber:(NSString *)money;
@end
