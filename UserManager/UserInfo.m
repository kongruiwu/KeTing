//
//  UserInfo.m
//  KeTing
//
//  Created by 吴孔锐 on 2017/6/28.
//  Copyright © 2017年 wurui. All rights reserved.
//

#import "UserInfo.h"

@implementation UserInfo

- (instancetype)initWithDictionary:(NSDictionary *)dic{
    self = [super initWithDictionary:dic];
    /**草泥马  渣b的服务端*/
    if (self) {
        if (dic[@"USERNAME"]) {
            self.UNAME = dic[@"USERNAME"];
        }
        if (!dic[@"BIRTHDAY"] || [dic[@"BIRTHDAY"] integerValue] == 0) {
            self.Birthday = nil;
            self.BIRTHDAY = @"0";
        }else{
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"yyyy/MM/dd"];
            NSNumber * time = dic[@"BIRTHDAY"];
            NSDate * date = [NSDate dateWithTimeIntervalSince1970:[time longLongValue]];
            NSString * dateString = [dateFormatter stringFromDate:date];
            self.Birthday = dateString;
        }
        
        NSArray * typNames = (NSArray *)[[NSUserDefaults standardUserDefaults] objectForKey:@"TYPNAMES"];
        NSArray * typIds = (NSArray *)[[NSUserDefaults standardUserDefaults] objectForKey:@"TYPIDS"];
        NSArray * eduNames = (NSArray *)[[NSUserDefaults standardUserDefaults] objectForKey:@"EDUNAMES"];
        NSArray * eduIds = (NSArray *)[[NSUserDefaults standardUserDefaults] objectForKey:@"EDUIDS"];
        if (self.EDU_ID && [self.EDU_ID integerValue] > 0) {
            NSInteger index = [eduIds indexOfObject:[NSString stringWithFormat:@"%@",self.EDU_ID]];
            self.EDU_NAME = index > eduNames.count ? @"":eduNames[index];
        }else{
            self.EDU_ID = @"0";
        }
        if (self.TYP_ID && [self.TYP_ID integerValue] > 0) {
            NSInteger index = [typIds indexOfObject:[NSString stringWithFormat:@"%@",self.TYP_ID]];
            self.TYP_NAME = index > typNames.count ? @"":typNames[index];
        }else{
            self.TYP_ID = @"0";
        }
        
        [[NSUserDefaults standardUserDefaults] setValue:[NSString stringWithFormat:@"%@",self.USERID] forKey:@"USERID"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    return self;
}

@end
