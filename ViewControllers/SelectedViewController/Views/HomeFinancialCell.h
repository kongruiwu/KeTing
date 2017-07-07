//
//  HomeFinancialCell.h
//  KeTing
//
//  Created by 吴孔锐 on 2017/6/5.
//  Copyright © 2017年 wurui. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ConfigHeader.h"
@protocol HomeFinancialDelegate <NSObject>

- (void)PlayAudioAtIndex:(NSInteger)index;
- (void)PlayTopList;
@end

//财经头条cell
@interface HomeFinancialCell : UITableViewCell


@property (nonatomic, strong) UIView * topLine;
@property (nonatomic, strong) UIButton * playButton;
@property (nonatomic, strong) NSMutableArray * topButtons;
@property (nonatomic, assign) id<HomeFinancialDelegate> delegate;

- (void)updateWithTitles:(NSArray *)titls;
@end
