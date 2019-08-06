//
//  HJExcelViewCell.h
//  zxzx
//
//  Created by 王庆尧 on 2019/7/29.
//  Copyright © 2019 屈霸天. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol HJExcelViewViewCellDelegate;

@interface HJExcelViewCell : UIView

/** 是否可选，默认no关闭*/
@property (nonatomic) BOOL selected;

//以下属性,和HJExcelView通信，外部调用无用
/** 位置*/
@property (nonatomic, strong) NSIndexPath *indexPath;
@property (nonatomic, assign) id <HJExcelViewViewCellDelegate> excelViewDelegate;

@end




// 和HJExcelView通信，外部不用实现
@protocol HJExcelViewViewCellDelegate <NSObject>

@optional

/**
 *  点击cell
 *
 *  @param excelViewCell HJExcelViewCell
 *  @param indexPath 位置
 *
 *  @return void
 */
- (void)excelViewCell:(HJExcelViewCell *)excelViewCell didSelectRowAtIndexPath:(NSIndexPath *)indexPath;

@end

NS_ASSUME_NONNULL_END
