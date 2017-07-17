//
//  HotWordModel.h
//  KeTing
//
//  Created by 吴孔锐 on 2017/7/17.
//  Copyright © 2017年 wurui. All rights reserved.
//

#import "BaseModel.h"
#import "KTFactory.h"
@interface HotWordModel : BaseModel

@property (nonatomic, strong) NSNumber * addTime;
@property (nonatomic, strong) NSString * searchName;
@property (nonatomic, assign) float with;

@end
