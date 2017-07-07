//
//  KTError.h
//  KeTing
//
//  Created by 吴孔锐 on 2017/6/6.
//  Copyright © 2017年 wurui. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KTError : NSObject
@property (nonatomic, strong) NSString *code;
@property (nonatomic, strong) NSString *message;
@end
