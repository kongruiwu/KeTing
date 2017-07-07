//
//  MyLikeSubViewController.h
//  KeTing
//
//  Created by 吴孔锐 on 2017/7/3.
//  Copyright © 2017年 wurui. All rights reserved.
//

#import "BaseViewController.h"

typedef NS_ENUM(NSInteger,LIKESUBTYPE){
    LIKESUBTYPETOPLIST = 0 , //财经头条
    LIKESUBTYPEBOOK ,        //书籍
    LIKESUBTYPEBUY           //订阅
};


@interface MyLikeSubViewController : BaseViewController


@property (nonatomic, assign) LIKESUBTYPE subType;

@end
