//
//  HJExcelView.m
//  zxzx
//
//  Created by 王庆尧 on 2019/7/29.
//  Copyright © 2019 屈霸天. All rights reserved.
//

#import "HJExcelView.h"
#import "HJExcelViewPoint.h"

@interface HJExcelView ()
{
@private
    /** 画版*/
    UIView *_boardView;
    /** 画布*/
    UIView *_contentView;
    
    /** 行列坐标点*/
    NSMutableArray *_cellRowArray, *_cellSectionArray;
}

@end


@implementation HJExcelView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _boardView = [[UIView alloc] initWithFrame:self.frame];
        [self addSubview:_boardView];
       
    }
    return self;
}

-(void)setEnableRecognizer:(BOOL)enableRecognizer
{
    _enableRecognizer = enableRecognizer;
    if (_enableRecognizer) {
        // 手势操作
        // 移动
        UIPanGestureRecognizer *panRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
        [_boardView addGestureRecognizer:panRecognizer];
    }
}

#pragma mark  - 图形移动
- (void)handlePan:(UIPanGestureRecognizer *)recognizer
{
    // 取点
    CGPoint translatedPoint = [recognizer translationInView:_boardView];
    // 计算
    CGFloat x = recognizer.view.center.x + translatedPoint.x;
    CGFloat y = recognizer.view.center.y + translatedPoint.y;
    
    // 移动范围
    CGFloat contentWidth  = _contentView.frame.size.width / 2;
    CGFloat contentHeight = _contentView.frame.size.height / 2;
    CGFloat mainWidth  = self.frame.size.width / 2;
    CGFloat mainHeight = self.frame.size.height / 2;
    
    // 上移动
    if (translatedPoint.y < 0)
    {
        // 画布高度低于屏幕高度
        if (contentHeight < mainHeight)
        {
            // 禁止上边框离开屏幕边缘
            y = y > contentHeight ? y : contentHeight;
        }
    }
    // 下移动
    else
    {
        // 画布高度低于屏幕高度
        if (contentHeight < mainHeight)
        {
            // 禁止下边框离开屏幕边缘
            y = y < self.frame.size.height - contentHeight ? y : self.frame.size.height - contentHeight;
        }
    }
    
    // 左移动
    if (translatedPoint.x < 0)
    {
        // 画布高度低于屏幕高度
        if (contentWidth < mainWidth)
        {
            // 禁止左边框离开屏幕边缘
            x = x > contentWidth ? x : contentWidth;
        }
        
    }
    // 右移动
    else
    {
        if (contentWidth < mainWidth)
        {
            // 禁止右边框离开屏幕边缘
            x = x < self.frame.size.width - contentWidth ? x : self.frame.size.width - contentWidth;
        }
        
    }
    
    // 移动
    recognizer.view.center = CGPointMake(x, y);
    
    // 回归中心点
    [recognizer setTranslation:CGPointMake(0, 0) inView:_boardView];
}

#pragma mark - 获得边框颜色
- (UIColor *)borderColor
{
    // 是否设置为默认
    _borderColor = _borderColor ? _borderColor : [UIColor colorWithWhite:0.821 alpha:1.000];
    
    return _borderColor;
}

#pragma mark 获得边框大小
- (CGFloat)borderWidth
{
    // 是否设置为默认
    _borderWidth = _borderWidth > 0 ? _borderWidth : 1.0;
    
    return _borderWidth;
}

#pragma mark - 刷新数据
- (void)reloadData
{
    // 必须实现的代理方法
    if ([self.dataSource respondsToSelector:@selector(numberOfSectionsInExcelView:)] && [self.dataSource respondsToSelector:@selector(numberOfRowsInExcelView:)] && [self.dataSource respondsToSelector:@selector(excelViewCell:cellForRowAtIndexPath:)])
    {
        // 清空上次的画布
        [_contentView removeFromSuperview];
        _contentView = [[UIView alloc] initWithFrame:self.frame];
        [_boardView addSubview:_contentView];
        
        // 行
        NSInteger rows = [self.dataSource numberOfRowsInExcelView:self];
        // 列
        NSInteger sections = [self.dataSource numberOfSectionsInExcelView:self];
        
        CGFloat borderWidth = self.borderWidth / 2;
        
        // cell的大小位置
        CGRect frame = CGRectMake(borderWidth + self.cellToBordeSpace * 2, borderWidth + self.cellToBordeSpace * 2, 0, 0);
        
        _cellRowArray     = [NSMutableArray array];
        _cellSectionArray = [NSMutableArray array];
        
        NSInteger sumHeight = 0, sumWidth = 0;
        
        // 行操作
        for (int row = 0; row < rows; row ++ )
        {
            // 行高
            frame.size.height = [self heightForRow:row];
            // 保存行点
            HJExcelViewPoint *point = [HJExcelViewPoint excelViewPointWithX:frame.origin.x y:frame.origin.y];
            [_cellRowArray addObject:point];
            
            // 列操作
            for (int section = 0; section < sections; section ++ )
            {
                // 列宽
                frame.size.width = [self widthInSection:section];
                // 位置
                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row inSection:section];
                
                [self addExcelViewCellWithIndexPath:indexPath frame:frame];
                
                if (row == 0)
                {
                    // 保存列点
                    HJExcelViewPoint *point = [HJExcelViewPoint excelViewPointWithX:frame.origin.x y:frame.origin.y];
                    [_cellSectionArray addObject:point];
                }
                // 下一列位置
                frame.origin.x += frame.size.width + self.cellToBordeSpace * 2;
            }
            
            // 下一行第0个位置
            frame.origin.y += frame.size.height + self.cellToBordeSpace * 2;
            // 当出现最后一个点时,保存长度
            if (row == rows - 1)
            {
                sumHeight = frame.origin.y;
                sumWidth = frame.origin.x;
            }
            frame.origin.x = self.borderWidth / 2 + self.cellToBordeSpace * 2;
        }
        
        // 画边框
        HJExcelViewPoint *point;
        UIView *line;
        
        sumHeight -= self.cellToBordeSpace * 2;
        sumWidth  -= self.cellToBordeSpace * 2;
        
        // 画行
        for (int row = 0; row < rows; row ++ )
        {
            point = [_cellRowArray objectAtIndex:row];
            line = [[UIView alloc] initWithFrame:CGRectMake(point.x - borderWidth - self.cellToBordeSpace, point.y - borderWidth - self.cellToBordeSpace, sumWidth, self.borderWidth)];
            line.backgroundColor = self.borderColor;
            [_contentView addSubview:line];
        }
        
        // 画最后一行
        line = [[UIView alloc] initWithFrame:CGRectMake(point.x - borderWidth - self.cellToBordeSpace, sumHeight - borderWidth + self.cellToBordeSpace, sumWidth, self.borderWidth)];
        line.backgroundColor = self.borderColor;
        [_contentView addSubview:line];
        
        // 画列
        for (int section = 0; section < sections; section ++ )
        {
            point = [_cellSectionArray objectAtIndex:section];
            line = [[UIView alloc] initWithFrame:CGRectMake(point.x - borderWidth - self.cellToBordeSpace, point.y - borderWidth - self.cellToBordeSpace, self.borderWidth, sumHeight)];
            line.backgroundColor = self.borderColor;
            [_contentView addSubview:line];
        }
        // 画最后一列
        line = [[UIView alloc] initWithFrame:CGRectMake(sumWidth - borderWidth + self.cellToBordeSpace, point.y - borderWidth - self.cellToBordeSpace, self.borderWidth, sumHeight)];
        line.backgroundColor = self.borderColor;
        [_contentView addSubview:line];
        
        // 调整画板
        frame = _boardView.frame;
        frame.origin.x = - self.frame.size.width / 2;
        frame.origin.y = - self.frame.size.height / 2;
        frame.size.height = self.borderWidth + self.cellToBordeSpace + sumHeight + self.frame.size.height;
        frame.size.width  = self.borderWidth + self.cellToBordeSpace + sumWidth + self.frame.size.width;
        _boardView.frame = frame;
        
        // 调整画布
        frame = _contentView.frame;
        frame.origin.x = self.frame.size.width / 2;
        frame.origin.y = self.frame.size.height / 2;
        frame.size.height = self.borderWidth + self.cellToBordeSpace + sumHeight;
        frame.size.width  = self.borderWidth + self.cellToBordeSpace + sumWidth;
        _contentView.frame = frame;
    }
    
}

#pragma mark - cell的行高
- (CGFloat)heightForRow:(NSInteger)row
{
    if ([self.delegate respondsToSelector:@selector(excelView:heightForRow:)])
    {
        return [self.delegate excelView:self heightForRow:row];
    }
    else
    {
        return 44;
    }
}

#pragma mark cell的列宽
- (CGFloat)widthInSection:(NSInteger)section
{
    if ([self.delegate respondsToSelector:@selector(excelView:heightForRow:)])
    {
        return [self.delegate excelView:self widthInSection:section];
    }
    else
    {
        return 70;
    }
}

#pragma mark - 视图增加cell
- (void)addExcelViewCellWithIndexPath:(NSIndexPath *)indexPath frame:(CGRect)frame
{
    // 初始化cell
    HJExcelViewCell *cell = [[HJExcelViewCell alloc] initWithFrame:frame];
    // 通知主视图向cell中添加内容
    cell = [self.dataSource excelViewCell:cell cellForRowAtIndexPath:indexPath];
    // 调整大小
    cell.frame = frame;
    // 绑定位置
    cell.indexPath = indexPath;
    // 代理
    cell.excelViewDelegate = self;
    //  加到页面中
    [_contentView addSubview:cell];
    
}

#pragma mark - HJExcelViewViewCellDelegate
- (void)excelViewCell:(HJExcelViewCell *)excelViewCell didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 判断是否开启可点击和实现回调
    if (excelViewCell.selected && [self.delegate respondsToSelector:@selector(excelView:didSelectRowAtIndexPath:)])
    {
        // 通知主视图，被点击
        [self.delegate excelView:self didSelectRowAtIndexPath:excelViewCell.indexPath];
    }
}

@end
