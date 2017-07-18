//
//  SetAccoutViewController.h
//  KeTing
//
//  Created by 吴孔锐 on 2017/7/18.
//  Copyright © 2017年 wurui. All rights reserved.
//

#import "BaseViewController.h"
@interface SetAccoutViewController : BaseViewController

@property (nonatomic, strong) NSArray * products;
@property (nonatomic, strong) NSNumber * money;
/**是否是听书类型*/
@property (nonatomic, assign) BOOL isBook;
/**是否来自购物车*/
@property (nonatomic, assign) BOOL isCart;
@end
