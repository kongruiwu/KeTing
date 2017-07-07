//
//  HistoryModel.h
//  KeTing
//
//  Created by 吴孔锐 on 2017/7/6.
//  Copyright © 2017年 wurui. All rights reserved.
//

#import "BaseModel.h"
#import "TagsModel.h"
@interface HistoryModel : BaseModel
/**音频id*/
@property (nonatomic, strong) NSNumber * audioId;
/**音频名称*/
@property (nonatomic, strong) NSString * audioName;
/**关联听书、声度、头条类型*/
@property (nonatomic, strong) NSNumber * relationType;
/**关联听书、声度、头条id*/
@property (nonatomic, strong) NSNumber * relationId;
/**收听时长*/
@property (nonatomic, strong) NSNumber * playLong;
/**音频时长*/
@property (nonatomic, strong) NSNumber * audioLong;
/**音频封面图*/
@property (nonatomic, strong) NSString * thumbnail;
/**音频源*/
@property (nonatomic, strong) NSString * audioSource;
/**音频简介*/
@property (nonatomic, strong) NSString * summary;
/**标签名称*/
@property (nonatomic, strong) NSString * tagName;
/**是否点赞*/
@property (nonatomic, strong) NSString * isprase;
/**标签列表*/
@property (nonatomic, strong) NSArray<TagsModel *> * tagModels;
/**音频主键*/
@property (nonatomic, strong) NSNumber * downPercent;
/**下载进度  0  下载中， 下载完成*/
@property (nonatomic, strong) NSNumber * downStatus;
/**下载设备号*/
@property (nonatomic, strong) NSString * deviceNo;
/**终端*/
@property (nonatomic, strong) NSString * systemVersion;
/**系统版本 手机类型*/
@property (nonatomic, strong) NSString * phoneType;
/**是否删除*/
@property (nonatomic, assign) BOOL isDel;
@end
