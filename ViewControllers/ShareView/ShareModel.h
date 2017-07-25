//
//  ShareModel.h
//  KeTing
//
//  Created by 吴孔锐 on 2017/7/25.
//  Copyright © 2017年 wurui. All rights reserved.
//

#import "BaseModel.h"
#import <UIKit/UIKit.h> 
@interface ShareModel : BaseModel
//分享标题
@property (nonatomic, strong) NSString * shareTitle;
//分享描述
@property (nonatomic, strong) NSString * shareDesc;
//分享图片
@property (nonatomic, strong) NSString * imageUrl;
//分享目标
@property (nonatomic, strong) NSString * targeturl;
//图片
@property (nonatomic, strong) UIImage * image;
@end
