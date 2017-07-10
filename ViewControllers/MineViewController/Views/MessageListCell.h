//
//  MessageListCell.h
//  KeTing
//
//  Created by 吴孔锐 on 2017/7/4.
//  Copyright © 2017年 wurui. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ConfigHeader.h"
#import "MessageModel.h"
@interface MessageListCell : UITableViewCell

@property (nonatomic, strong) UILabel * nameLabel;
@property (nonatomic, strong) UILabel * timelabel;
@property (nonatomic, strong) UIView * lineView;
- (void)updateWithMessageModel:(MessageModel *)model;
@end
