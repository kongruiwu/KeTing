//
//  HotWordCell.h
//  KeTing
//
//  Created by 吴孔锐 on 2017/7/17.
//  Copyright © 2017年 wurui. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HotWordModel.h"
#import "ConfigHeader.h"

@protocol HotWordCellDelegate <NSObject>

- (void)HotWordBtnClick:(NSString *)searchText;

@end
@interface HotWordCell : UITableViewCell

@property (nonatomic, strong) NSMutableArray * tags;
@property (nonatomic, assign) id<HotWordCellDelegate> delegate;

- (void)updateHotWords:(NSArray *)tags;
@end
