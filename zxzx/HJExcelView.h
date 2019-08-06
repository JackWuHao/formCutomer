//
//  HJExcelView.h
//  zxzx
//
//  Created by 王庆尧 on 2019/7/29.
//  Copyright © 2019 屈霸天. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HJExcelViewCell.h"
NS_ASSUME_NONNULL_BEGIN


@protocol HJExcelViewViewDelegate, HJExcelViewViewDataSource;


@interface HJExcelView : UIView <HJExcelViewViewCellDelegate>

/** 数据源代理*/
@property (nonatomic, assign) id <HJExcelViewViewDataSource> dataSource;
/** 界面代理*/
@property (nonatomic, assign) id <HJExcelViewViewDelegate>   delegate;

/** 边框颜色*/
@property (nonatomic, strong) UIColor *borderColor;
/** 边框大小(>0才有效果，默认为1.0)*/
@property (nonatomic)         CGFloat borderWidth;

/** cell到边框的间隙*/
@property (nonatomic) CGFloat  cellToBordeSpace;
/** 是否允许手势滑动 默认为NO*/
@property (nonatomic ,assign) BOOL enableRecognizer;

/**
 *  刷新全部数据
 *
 *  @return void
 */
- (void)reloadData;

@end


@protocol HJExcelViewViewDelegate <NSObject>

@optional

/**
 *  点击cell
 *
 *  @param excelView HJExcelView
 *  @param indexPath 位置
 *
 *  @return void
 */
- (void)excelView:(HJExcelView *)excelView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;

/**
 *  cell的行高，默认40，包含了borderWidth／2
 *
 *  @param excelView HJExcelView
 *  @param row       行
 *
 *  @return CGFloat
 */
- (CGFloat)excelView:(HJExcelView *)excelView heightForRow:(NSInteger)row;

/**
 *  cell的列宽，默认:60,包含了borderWidth／2
 *
 *  @param excelView HJExcelView
 *  @param section   列
 *
 *  @return CGFloat
 */
- (CGFloat)excelView:(HJExcelView *)excelView widthInSection:(NSInteger)section;

@end


@protocol HJExcelViewViewDataSource <NSObject>

@required

/**
 *  有多少行数据
 *
 *  @param excelView HJExcelView
 *
 *  @return NSInteger
 */
- (NSInteger)numberOfRowsInExcelView:(HJExcelView *)excelView;

/**
 *  有多少列数据
 *
 *  @param excelView HJExcelView
 *
 *  @return NSInteger
 */
- (NSInteger)numberOfSectionsInExcelView:(HJExcelView *)excelView;

/**
 *  生成cell
 *
 *  @param cell      已初始化的HJExcelViewCell
 *  @param indexPath 位置
 *
 *  @return HJExcelViewCell
 */
- (HJExcelViewCell *)excelViewCell:(HJExcelViewCell *)cell cellForRowAtIndexPath:(NSIndexPath *)indexPath;

@end


NS_ASSUME_NONNULL_END
