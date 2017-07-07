//
//  TagsModel.h
//  KeTing
//
//  Created by 吴孔锐 on 2017/7/6.
//  Copyright © 2017年 wurui. All rights reserved.
//

#import "BaseModel.h"

@interface TagsModel:BaseModel
/**自动编号*/
@property (nonatomic, strong) NSString * tagId;
/**标签名称*/
@property (nonatomic, strong) NSString * tagName;
/**栏目 0音频 1是头条 2是听书 3是声度*/
@property (nonatomic, strong) NSString * columnId;
/**首字母*/
@property (nonatomic, strong) NSString * initial;
/**查询字段*/
@property (nonatomic, strong) NSString * searchColumn;
/**统计数量*/
@property (nonatomic, strong) NSNumber * useCount;
/**添加人*/
@property (nonatomic, strong) NSString * manager;
/**添加时间*/
@property (nonatomic, strong) NSNumber * addTime;
/**标签状态 0是正常 1是禁用 2.删除*/
@property (nonatomic, strong) NSString * tagStatus;
/**禁用时间*/
@property (nonatomic, strong) NSNumber * hiddenTime;
@end
