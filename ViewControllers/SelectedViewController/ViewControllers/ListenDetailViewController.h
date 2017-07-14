//
//  ListenDetailViewController.h
//  KeTing
//
//  Created by 吴孔锐 on 2017/6/13.
//  Copyright © 2017年 wurui. All rights reserved.
//

#import "BaseViewController.h"
#import "HomeListenModel.h"


@interface ListenDetailViewController : BaseViewController

@property (nonatomic, strong) NSString * listenID;
@property (nonatomic, assign) BOOL isFromAnchor;

@end
