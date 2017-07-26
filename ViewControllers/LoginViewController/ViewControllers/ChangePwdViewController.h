//
//  ChangePwdViewController.h
//  KeTing
//
//  Created by 吴孔锐 on 2017/6/28.
//  Copyright © 2017年 wurui. All rights reserved.
//

#import "BaseViewController.h"

@interface ChangePwdViewController : BaseViewController

@property (nonatomic, strong) NSString * phoneNum;
/**是否是修改密码*/
@property (nonatomic, assign) BOOL isChange;
/**票据信息*/
@property (nonatomic, strong) NSString * TICKET;

@end
