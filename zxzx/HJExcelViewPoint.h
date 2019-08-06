//
//  HJExcelViewPoint.h
//  zxzx
//
//  Created by 王庆尧 on 2019/7/29.
//  Copyright © 2019 屈霸天. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HJExcelViewPoint : UIView
/** 坐标x*/
@property (nonatomic) CGFloat x;
/** 坐标y*/
@property (nonatomic) CGFloat y;

/**
 *  生成坐标
 *
 *  @param x x
 *  @param y y
 *
 *  @return HJExcelViewPoint
 */
+ (id)excelViewPointWithX:(CGFloat)x y:(CGFloat)y;


@end

NS_ASSUME_NONNULL_END
