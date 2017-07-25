//
//  PlayListView.h
//  KeTing
//
//  Created by 吴孔锐 on 2017/6/12.
//  Copyright © 2017年 wurui. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PlayListCell.h"

@protocol PlayListDelegate <NSObject>

- (void)playAudioNeedUpdate:(HomeTopModel *)model;

@end

@interface PlayListView : UIView<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UIView * showView;
@property (nonatomic, strong) UITableView * tabview;
@property (nonatomic, strong) UILabel * titleLabel;
@property (nonatomic, assign) id<PlayListDelegate> delegate;

- (void)show;
- (void)disMiss;
@end
