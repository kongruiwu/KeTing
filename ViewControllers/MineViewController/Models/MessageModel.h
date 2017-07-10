//
//  MessageModel.h
//  KeTing
//
//  Created by 吴孔锐 on 2017/7/7.
//  Copyright © 2017年 wurui. All rights reserved.
//

#import "BaseModel.h"

@interface MessageModel : BaseModel

@property (nonatomic, strong) NSNumber * errorCount;
@property (nonatomic, strong) NSNumber * hiddenTime;
@property (nonatomic, strong) NSString * messageContent;
@property (nonatomic, strong) NSNumber * messageId;
@property (nonatomic, strong) NSNumber * messageStatus;
@property (nonatomic, strong) NSNumber * messageType;
@property (nonatomic, strong) NSNumber * readCount;
@property (nonatomic, strong) NSNumber * rowNum;
@property (nonatomic, strong) NSNumber * sendTime;
@property (nonatomic, strong) NSNumber * sendTo;
@property (nonatomic, strong) NSNumber * successCount;
@property (nonatomic, strong) NSNumber * templeId;
@property (nonatomic, strong) NSNumber * unReadCount;
@property (nonatomic, strong) NSString * userId;
@end
