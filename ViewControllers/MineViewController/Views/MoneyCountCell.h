//
//  MoneyCountCell.h
//  KeTing
//
//  Created by 吴孔锐 on 2017/6/29.
//  Copyright © 2017年 wurui. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ConfigHeader.h"
@interface MoneyCountCell : UITableViewCell

@property (nonatomic, strong) NSMutableArray * btnArray;

- (void)updateWithAmouts:(NSArray *)amount;
@end