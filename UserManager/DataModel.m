//
//  DataModel.m
//  KeTing
//
//  Created by 吴孔锐 on 2017/7/5.
//  Copyright © 2017年 wurui. All rights reserved.
//

#import "DataModel.h"

@implementation DataModel

- (instancetype)initWithDictionary:(NSDictionary *)dic{
    self = [super initWithDictionary:dic];
    
    if (self) {
        NSMutableArray * names = [NSMutableArray new];
        NSMutableArray * ids = [NSMutableArray new];
        for (int i = 0; i<self.edu_id.allKeys.count; i++) {
            NSString * key = self.edu_id.allKeys[i];
            NSString * value = self.edu_id[key];
            [ids addObject:key];
            [names addObject:value];
        }
        self.eduNames = [NSArray arrayWithArray:names];
        self.eduIds = [NSArray arrayWithArray:ids];
        
        [names removeAllObjects];
        [ids removeAllObjects];
        
        for (int i = 0; i<self.typ_id.allKeys.count; i++) {
            NSString * key = self.typ_id.allKeys[i];
            NSString * value = self.typ_id[key];
            [ids addObject:key];
            [names addObject:value];
        }
        self.typNames = [NSArray arrayWithArray:names];
        self.typIds = [NSArray arrayWithArray:ids];
        
        
        [names removeAllObjects];
        [ids removeAllObjects];
        
        for (int i = 0; i<self.order_cycle.allKeys.count; i++) {
            NSString * key = self.order_cycle.allKeys[i];
            NSString * value = self.order_cycle[key];
            [ids addObject:key];
            [names addObject:value];
        }
        self.orderNames = [NSArray arrayWithArray:names];
        self.orderIDs = [NSArray arrayWithArray:ids];
        
        self.amount = @[@6,@30,@108,@208,@298,@518];
        
        [[NSUserDefaults standardUserDefaults] setObject:self.typNames  forKey:@"TYPNAMES"];
        [[NSUserDefaults standardUserDefaults] setObject:self.typIds    forKey:@"TYPIDS"];
        [[NSUserDefaults standardUserDefaults] setObject:self.eduNames  forKey:@"EDUNAMES"];
        [[NSUserDefaults standardUserDefaults] setObject:self.eduIds    forKey:@"EDUIDS"];
        [[NSUserDefaults standardUserDefaults] setObject:self.orderNames  forKey:@"ORDERNAMES"];
        [[NSUserDefaults standardUserDefaults] setObject:self.orderIDs    forKey:@"ORDERIDS"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    
    return self;
}

@end
