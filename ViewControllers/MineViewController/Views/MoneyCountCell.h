//
//  MoneyCountCell.h
//  KeTing
//
//  Created by 吴孔锐 on 2017/6/29.
//  Copyright © 2017年 wurui. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ConfigHeader.h"

@protocol SendPriceDelegate <NSObject>
- (void)sendPrice:(NSInteger )price;
@end

@interface MoneyCountCell : UITableViewCell

@property (nonatomic, strong) id <SendPriceDelegate > delegate;

@property (nonatomic, strong) NSMutableArray * btnArray;

- (void)updateWithAmouts:(NSArray *)amount;
@end
