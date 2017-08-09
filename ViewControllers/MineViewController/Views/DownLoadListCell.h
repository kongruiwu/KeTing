//
//  DownLoadListCell.h
//  KeTing
//
//  Created by 吴孔锐 on 2017/7/3.
//  Copyright © 2017年 wurui. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ConfigHeader.h"
#import "HomeTopModel.h"

//@protocol DownLoadListCellDelegate <NSObject>
//
//- (void)downLoadAudio:(UIButton *)button;
//- (void)checkAudioText:(UIButton *)button;
//- (void)likeAudioClick:(UIButton *)button;
//- (void)shareBtnClick:(UIButton *)button;
//- (void)moreBtnClick:(UIButton *)button;
//
//@end
//
@interface DownLoadListCell : UITableViewCell

@property (nonatomic, strong) UILabel * nameLabel;
@property (nonatomic, strong) UIImageView * downLoadImg;
@property (nonatomic, strong) UILabel * downStatus;
@property (nonatomic, strong) UILabel * tagLabel;
@property (nonatomic, strong) UILabel * playStatus;
@property (nonatomic, strong) UIView * line;


/**更多   文稿按钮*/
//@property (nonatomic, strong) UIButton * moreBtn;
//@property (nonatomic, strong) UIImageView * toolsbar;
//@property (nonatomic, strong) UIButton * downLoadBtn;
//@property (nonatomic, strong) UIButton * likeBtn;
//@property (nonatomic, strong) UIButton * shareBtn;
//@property (nonatomic, strong) UIButton * textBtn;


@property (nonatomic, strong) UIButton * selectButton;
@property (nonatomic, strong) UIView * moveView;
//@property (nonatomic, assign) id<DownLoadListCellDelegate> delegate;

- (void)updateWithHistoryModel:(HomeTopModel *)model pausStatus:(BOOL)rec isDown:(BOOL)isDown;
- (void)showSelectBotton:(BOOL)rec;
@end
