//
//  ViewController.m
//  zxzx
//
//  Created by 王庆尧 on 2019/7/29.
//  Copyright © 2019 屈霸天. All rights reserved.
//

#import "ViewController.h"
#import "HJExcelView.h"
@interface ViewController ()<HJExcelViewViewDelegate,HJExcelViewViewDataSource>
@property (nonatomic ,strong) HJExcelView *tabview;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tabview = [[HJExcelView alloc] initWithFrame:CGRectMake(0, 100, self.view.frame.size.width, 90)];
//    self.tabview.backgroundColor =[ UIColor orangeColor];
    self.tabview.borderColor = [UIColor lightGrayColor];
    self.tabview.borderWidth = 1;
    self.tabview.cellToBordeSpace = 0;
    [self.view addSubview:self.tabview];
    self.tabview.dataSource = self;
    self.tabview.delegate = self;
    [self.tabview reloadData];
    
}



-(NSInteger)numberOfRowsInExcelView:(HJExcelView *)excelView
{
    return 3;
}

- (NSInteger)numberOfSectionsInExcelView:(HJExcelView *)excelView{
    return 3;
}

- (HJExcelViewCell *)excelViewCell:(HJExcelViewCell *)cell cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    //cell 自定义布局
//    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
//    view.backgroundColor = [UIColor redColor];
//    [cell addSubview:view];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 126, 30)];
    label.backgroundColor = [UIColor orangeColor];
    [cell addSubview:label];
    label.textColor = [UIColor redColor];
    label.text = @"11";
    label.textAlignment = NSTextAlignmentCenter;
    NSLog(@"%f",cell.frame.size.width);
    return cell;
}

-(CGFloat)excelView:(HJExcelView *)excelView heightForRow:(NSInteger)row;
{
    return 30;
}

- (CGFloat)excelView:(HJExcelView *)excelView widthInSection:(NSInteger)section;
{
    return 126;
}

@end
