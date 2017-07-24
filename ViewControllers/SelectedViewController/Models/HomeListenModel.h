//
//  HomeListenModel.h
//  KeTing
//
//  Created by 吴孔锐 on 2017/6/6.
//  Copyright © 2017年 wurui. All rights reserved.
//

#import "BaseModel.h"
#import "HomeTopModel.h"
@interface HomeListenModel : BaseModel
/**书籍Id*/
@property (nonatomic, strong) NSNumber * listenId;
/**书籍名称*/
@property (nonatomic, strong) NSString * name;
/**主播Id*/
@property (nonatomic, strong) NSString * anchorId;
/**分类Id 1头条 2听书 3声度*/
@property (nonatomic, strong) NSNumber * catId;
/**简介*/
@property (nonatomic, strong) NSString * summary;
/**缩略图*/
@property (nonatomic, strong) NSString * thumb;
/**描述*/
@property (nonatomic, strong) NSString * descString;
/**计算用价格*/
@property (nonatomic, strong) NSNumber * PRICE;
/**价格*/
@property (nonatomic, strong) NSString * price;
/**价格带单位*/
@property (nonatomic, strong) NSString * timePrice;
/**排序值*/
@property (nonatomic, strong) NSString * sortNo;
/**发布状态*/
@property (nonatomic, strong) NSString * releaseStatus;
/**是否免费 1免费0收费*/
@property (nonatomic, assign) BOOL isFree;
/**促销类型 0无 1自定义价格 2限免*/
@property (nonatomic, strong) NSString * promotionType;
/**下载量*/
@property (nonatomic, strong) NSString * orderNum;
/**订阅时间*/
@property (nonatomic, strong) NSNumber * orderTime;
/**添加时间*/
@property (nonatomic, strong) NSNumber * addTime;
/**修改时间*/
@property (nonatomic, strong) NSNumber * editTime;
/**删除时间*/
@property (nonatomic, strong) NSNumber * delTime;
/**优惠后价格*/
@property (nonatomic, strong) NSString * selfPrice;
/**优惠类型*/
@property (nonatomic, strong) NSString * selfStatus;
/**主播姓名*/
@property (nonatomic, strong) NSString * anchorName;
/**是否加入购物车*/
@property (nonatomic, assign) BOOL iscart;
/**是否购买 true表示已购买*/
@property (nonatomic, assign) BOOL Isbuy;
/**视频时长*/
@property (nonatomic, strong) NSString * audioLong;
/**点赞数*/
@property (nonatomic, strong) NSNumber * praseNum;
@property (nonatomic, strong) NSNumber * hitNum;
/**是否点赞*/
@property (nonatomic, assign) BOOL isprase;
/**封面图*/
@property (nonatomic, strong) NSString * anchorFace;
/**最新更新列表*/
@property (nonatomic, strong) NSArray<HomeTopModel *> * audio;
@property (nonatomic, strong) HomeTopModel * audioModel;
/**标签列表*/
@property (nonatomic, strong) NSArray<TagsModel *> * tagModels;
/**购物车中是否被选择*/
@property (nonatomic, assign) BOOL isSelect;
/**是否已下载*/
@property (nonatomic, assign) BOOL isDownLoad;
/**是否正在下载*/
@property (nonatomic, assign) BOOL isDownLoading;


- (void)checkForDownLoadList:(NSArray *)arr;

@end
