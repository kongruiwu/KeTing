//
//  PlayCloseListView.h
//  KeTing
//
//  Created by 吴孔锐 on 2017/6/12.
//  Copyright © 2017年 wurui. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KTFactory.h"
@interface PlayCloseListView : UIView<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView * tabview;
@property (nonatomic, strong) NSArray * chosseArray;

- (void)show;
- (void)disMiss;
@end
