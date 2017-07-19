//
//  HomeTopModel.h
//  KeTing
//
//  Created by 吴孔锐 on 2017/6/6.
//  Copyright © 2017年 wurui. All rights reserved.
//

#import "BaseModel.h"
#import "TagsModel.h"
@interface HomeTopModel : BaseModel

/**头条Id*/
@property (nonatomic, strong) NSString * topId;
/**标签名称*/
@property (nonatomic, strong) NSString * tagName;
/**头条名称*/
@property (nonatomic, strong) NSString * topName;

/**音频Id*/
@property (nonatomic, strong) NSNumber * audioId;
/**唯一标识*/
@property (nonatomic, strong) NSString * onlyCode;
/**主播id*/
@property (nonatomic, strong) NSString * anchorId;
/**栏目Id*/
@property (nonatomic, strong) NSString * columnId;
/**音频名称*/
@property (nonatomic, strong) NSString * audioName;
/**简介*/
@property (nonatomic, strong) NSString * summary;
/**音频文稿*/
@property (nonatomic, strong) NSString * audioContent;
/**音频地址*/
@property (nonatomic, strong) NSString * audioSource;
/**音频大小*/
@property (nonatomic, strong) NSNumber * audioSize;
/**音频时长*/
@property (nonatomic, strong) NSNumber * audioLong;
/**封面图*/
@property (nonatomic, strong) NSString * thumbnail;
/**排序值*/
@property (nonatomic, strong) NSString * sortNo;
/**播放量*/
@property (nonatomic, strong) NSNumber * playTime;
/**下载量*/
@property (nonatomic, strong) NSNumber * downloads;
/**音频状态 0是正常 1是删除*/
@property (nonatomic, strong) NSNumber * audioStatus;
/**添加时间*/
@property (nonatomic, strong) NSNumber * addTime;
/**修改时间*/
@property (nonatomic, strong) NSNumber * editTime;
/**删除时间*/
@property (nonatomic, strong) NSNumber * delTime;
/**主播姓名*/
@property (nonatomic, strong) NSString * anchorName;
/**是否点赞*/
@property (nonatomic, assign) BOOL isprase;
/**标签列表*/
@property (nonatomic, strong) NSArray<TagsModel *> * tagModels;

/**是否选择被下载*/
@property (nonatomic, assign) BOOL isSelectDown;
/**是否显示toolsbar*/
@property (nonatomic, assign) BOOL showTools;

/**音频主键*/
@property (nonatomic, strong) NSNumber * downPercent;
/**下载进度  0 未下载， 1  下载中， 2 下载完成*/
@property (nonatomic, strong) NSNumber * downStatus;
/**下载设备号*/
@property (nonatomic, strong) NSString * deviceNo;
/**终端*/
@property (nonatomic, strong) NSString * systemVersion;
/**系统版本 手机类型*/
@property (nonatomic, strong) NSString * phoneType;
/**是否删除*/
@property (nonatomic, assign) BOOL isDel;

/**关联听书、声度、头条类型*/
@property (nonatomic, strong) NSNumber * relationType;
/**关联听书、声度、头条id*/
@property (nonatomic, strong) NSNumber * relationId;
/**收听时长*/
@property (nonatomic, strong) NSNumber * playLong;
/**标签tag*/
@property (nonatomic, strong) NSString * tagString;
/**音频存储的本地地址*/
@property (nonatomic, strong) NSString * localAddress;
@end
