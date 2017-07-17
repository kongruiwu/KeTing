//
//  HotWordModel.m
//  KeTing
//
//  Created by 吴孔锐 on 2017/7/17.
//  Copyright © 2017年 wurui. All rights reserved.
//

#import "HotWordModel.h"

@implementation HotWordModel


- (instancetype)initWithDictionary:(NSDictionary *)dic{
    self = [super initWithDictionary:dic];
    if (self) {
        self.with = [KTFactory getSize:self.searchName maxSize:CGSizeMake(Anno750(702 - 48), 99999) font:[UIFont systemFontOfSize:Anno750(28)]].width;
    }
    return self;
}

@end
