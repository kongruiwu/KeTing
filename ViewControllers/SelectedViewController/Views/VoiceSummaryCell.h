//
//  VoiceSummaryCell.h
//  KeTing
//
//  Created by 吴孔锐 on 2017/6/13.
//  Copyright © 2017年 wurui. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ConfigHeader.h"
@interface VoiceSummaryCell : UITableViewCell

@property (nonatomic, strong) UILabel * nameLabel;
//订阅状态
@property (nonatomic, strong) UILabel * countLabel;
@property (nonatomic, strong) UILabel * descLabel;
- (void)updateWithDescString:(NSString *)string count:(NSString *)count;
- (void)updateWithDescString:(NSString *)string time:(NSNumber *)time;
@end
