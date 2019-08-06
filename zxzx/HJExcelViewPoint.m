//
//  HJExcelViewPoint.m
//  zxzx
//
//  Created by 王庆尧 on 2019/7/29.
//  Copyright © 2019 屈霸天. All rights reserved.
//

#import "HJExcelViewPoint.h"

@implementation HJExcelViewPoint

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

+ (id)excelViewPointWithX:(CGFloat)x y:(CGFloat)y
{
    HJExcelViewPoint *point = [[[self class] alloc] init];
    
    point.x = x;
    point.y = y;
    
    return point;
}


@end
