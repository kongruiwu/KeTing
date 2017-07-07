//
//  RecommendListCell.h
//  KeTing
//
//  Created by 吴孔锐 on 2017/6/14.
//  Copyright © 2017年 wurui. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RecommendView.h"
#import "HomeListenModel.h"
@protocol RecommendListDelegate <NSObject>

- (void)checkAudioDetail:(UIButton *)btn;

@end

@interface RecommendListCell : UITableViewCell

@property (nonatomic, strong) RecommendView * FristView;
@property (nonatomic, strong) RecommendView * seconView;
@property (nonatomic, assign) id<RecommendListDelegate> delegate;

- (void)updateWithFristModel:(HomeListenModel *)firstM secondModel:(id)secondM;
@end
