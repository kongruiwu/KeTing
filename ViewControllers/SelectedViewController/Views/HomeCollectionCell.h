//
//  HomeCollectionCell.h
//  KeTing
//
//  Created by 吴孔锐 on 2017/6/5.
//  Copyright © 2017年 wurui. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ConfigHeader.h"
//由collectioncell 改为 uiview
//书籍固定为三个  直接写死
@protocol ListenBookDelegate <NSObject>

- (void)checkBookAtIndex:(NSInteger)index;

@end

#import "ListenBookCollectionCell.h"
@interface HomeCollectionCell : UITableViewCell

@property (nonatomic, strong) ListenBookCollectionCell * FirstView;
@property (nonatomic, strong) ListenBookCollectionCell * SecndView;
@property (nonatomic, strong) ListenBookCollectionCell * ThirdView;
@property (nonatomic, assign) id<ListenBookDelegate> delegate;


- (void)updateWithArray:(NSArray *)dataArray;

@end
