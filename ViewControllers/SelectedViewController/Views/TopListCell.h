//
//  TopListCell.h
//  KeTing
//
//  Created by 吴孔锐 on 2017/6/7.
//  Copyright © 2017年 wurui. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ConfigHeader.h"
#import "HomeTopModel.h"
#import "TagAudioModel.h"
@protocol TopListCellDelegate <NSObject>

- (void)downLoadAudio:(UIButton *)button;
- (void)checkAudioText:(UIButton *)button;
- (void)likeAudioClick:(UIButton *)button;
- (void)shareBtnClick:(UIButton *)button;
- (void)moreBtnClick:(UIButton *)button;

@end

@interface TopListCell : UITableViewCell

@property (nonatomic, strong) UIImageView * downLoadImg;
@property (nonatomic, strong) UILabel * nameLabel;
@property (nonatomic, strong) UILabel * timeLabel;
@property (nonatomic, strong) UILabel * tagLabel;
@property (nonatomic, strong) UILabel * playStutas;
@property (nonatomic, strong) UIButton * moreBtn;
@property (nonatomic, strong) UIView * bottomLine;

@property (nonatomic, strong) UIImageView * toolsbar;
@property (nonatomic, strong) UIButton * downLoadBtn;
@property (nonatomic, strong) UIButton * textBtn;
@property (nonatomic, strong) UIButton * likeBtn;
@property (nonatomic, strong) UIButton * shareBtn;


@property (nonatomic, assign) id<TopListCellDelegate> delegate;

- (void)updateWithHomeTopModel:(HomeTopModel *)model;
- (void)updateWithTagAudioModel:(TagAudioModel *)model;
@end
