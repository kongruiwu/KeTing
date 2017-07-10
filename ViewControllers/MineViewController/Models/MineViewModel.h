//
//  MineViewModel.h
//  KeTing
//
//  Created by 吴孔锐 on 2017/6/6.
//  Copyright © 2017年 wurui. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MineListModel.h"
@interface MineViewModel : NSObject

@property (nonatomic, strong) NSArray * dataArray;
//未读信息id 与数量
@property (nonatomic, strong) NSString * msgStr;

@property (nonatomic, strong) NSArray<MineListModel *> * FirstSection;
@property (nonatomic, strong) NSArray<MineListModel *> * SeconSection;
@property (nonatomic, strong) NSArray<MineListModel *> * ThirdSection;

@end
