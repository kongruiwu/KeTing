//
//  TagAudioModel.h
//  KeTing
//
//  Created by 吴孔锐 on 2017/6/9.
//  Copyright © 2017年 wurui. All rights reserved.
//

#import "BaseModel.h"

@interface TagAudioModel : BaseModel
/**音频Id*/
@property (nonatomic, strong) NSString * audioId;
/**头条Id*/
@property (nonatomic, strong) NSString * topId;
/**标签名称*/
@property (nonatomic, strong) NSString * tagName;
/**头条名称*/
@property (nonatomic, strong) NSString * topName;
/**音频时长*/
@property (nonatomic, strong) NSNumber * audioLong;
/**音频大小*/
@property (nonatomic, strong) NSNumber * audioSize;
/**主播id*/
@property (nonatomic, strong) NSString * anchorId;
/**分类ID*/
@property (nonatomic, strong) NSString * columnId;
/**音频名称*/
@property (nonatomic, strong) NSString * audioName;
/**音频地址*/
@property (nonatomic, strong) NSString * audioSource;
/**缩略图*/
@property (nonatomic, strong) NSString * thumbnail;
/**音频内容简介*/
@property (nonatomic, strong) NSString * summary;
/**是否点赞*/
@property (nonatomic, strong) NSString * isprase;
@end
