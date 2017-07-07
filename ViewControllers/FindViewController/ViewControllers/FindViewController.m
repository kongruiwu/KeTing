//
//  FindViewController.m
//  KeTing
//
//  Created by 吴孔锐 on 2017/6/13.
//  Copyright © 2017年 wurui. All rights reserved.
//

#import "FindViewController.h"
#import "FindListCell.h"
#import "HotSortViewController.h"
@interface FindViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView * tabview;
@property (nonatomic, strong) NSArray * titles;
@property (nonatomic, strong) NSArray * images;
@end

@implementation FindViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self creatUI];
}
- (void)creatUI{
    self.titles = @[@"热门排行",@"限免"];
    self.images = @[@"find_ Top Comments",@"find_ Limit free"];
    self.tabview = [KTFactory creatTabviewWithFrame:CGRectMake(0, 0, UI_WIDTH, UI_HEGIHT) style:UITableViewStyleGrouped];
    self.tabview.delegate = self;
    self.tabview.dataSource = self;
    [self.view addSubview:self.tabview];
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return Anno750(30);
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 2;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return Anno750(100);
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString * cellid = @"findcell";
    FindListCell * cell = [tableView dequeueReusableCellWithIdentifier:cellid];
    if (!cell) {
        cell = [[FindListCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid];
    }
    [cell updateWithTitle:self.titles[indexPath.row] imgName:self.images[indexPath.row]];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    HotSortViewController * vc = [HotSortViewController new];
    if (indexPath.row == 0) {
        vc.isHot = YES;
    }else{
        vc.isHot = NO;
    }
    [self.navigationController pushViewController:vc animated:YES];
}

@end
