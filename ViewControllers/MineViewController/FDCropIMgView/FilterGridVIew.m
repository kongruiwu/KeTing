//
//  FilterGridVIew.m
//  研究图片的知识和处理加载框
//
//  Created by syf on 15/10/16.
//  Copyright (c) 2015年 SYF. All rights reserved.
//

#import "FilterGridVIew.h"

@implementation FilterGridVIew

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self){
        self.userInteractionEnabled = NO;
        self.layer.borderWidth = 1.0f;
        self.layer.borderColor = [UIColor whiteColor].CGColor;
        
        for(NSInteger index = 0; index<4; index++){
            UIView * lineVIew = [[UIView alloc] init];
            lineVIew.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.8];
            [self addSubview:lineVIew];
        }
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    CGFloat  VIewWidth = [UIScreen mainScreen].bounds.size.width;
    CGFloat padding = VIewWidth/3.0;
    
    [self.subviews enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if(idx ==0 || idx == 1){
            UIView * lineVIew = obj;
            lineVIew.frame = CGRectMake(padding* (idx +1), 0, 0.5, VIewWidth);
        }
        else if (idx == 2 || idx == 3){
            UIView * lineVIew = obj;
            lineVIew.frame = CGRectMake(0, padding* (idx -1), VIewWidth,0.5 );

        }
    }];
    

  
    
}
@end
