//
//  ListenDetailHeader.h
//  KeTing
//
//  Created by 吴孔锐 on 2017/8/8.
//  Copyright © 2017年 wurui. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ConfigHeader.h"
@interface ListenDetailHeader : UIView

@property (nonatomic, strong) UIImageView * groundImg;

@property (nonatomic, strong) UIImageView * bookImg;


- (void)updateWithImage:(NSString *)image;
@end
