//
//  HomeViewModel.h
//  KeTing
//
//  Created by 吴孔锐 on 2017/6/6.
//  Copyright © 2017年 wurui. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseModel.h"
#import "HomeTopModel.h"
#import "HomeListenModel.h"



@interface HomeViewModel : BaseModel

@property (nonatomic, strong) NSArray * titleArray;

/**头条*/
@property (nonatomic, strong) NSArray * tops;
@property (nonatomic, strong) NSArray * topTitles;
/**听书*/
@property (nonatomic, strong) NSArray * listen;
/**声度*/
@property (nonatomic, strong) NSArray * voice;
/**股市解密*/
@property (nonatomic, strong) HomeListenModel * voiceStockSecret;
@end
