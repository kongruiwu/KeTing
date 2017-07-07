//
//  TopTagModel.h
//  KeTing
//
//  Created by 吴孔锐 on 2017/6/9.
//  Copyright © 2017年 wurui. All rights reserved.
//

#import "BaseModel.h"

@interface TopTagModel : BaseModel
/**标签Id*/
@property (nonatomic, strong) NSString * tagId;
/**标签名称*/
@property (nonatomic, strong) NSString * tagName;
/**标签首字母*/
@property (nonatomic, strong) NSString * firstLetter;
/**标签使用数量*/
@property (nonatomic, strong) NSString * useCount;
/**是否被选择*/
@property (nonatomic, assign) BOOL hasSelect;
@end
