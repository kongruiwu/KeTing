//
//  SetAccountHeadCell.h
//  KeTing
//
//  Created by 吴孔锐 on 2017/7/18.
//  Copyright © 2017年 wurui. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ConfigHeader.h"
@interface SetAccountHeadCell : UITableViewCell


@property (nonatomic, strong) UIView * whiteView;
@property (nonatomic, strong) UILabel * moneyLabel;
@property (nonatomic, strong) UILabel * descLabel;


- (void)updateMoneyLabel:(NSString *)money;
@end
