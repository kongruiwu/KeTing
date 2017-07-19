//
//  CateDetailViewController.m
//  KeTing
//
//  Created by 吴孔锐 on 2017/6/9.
//  Copyright © 2017年 wurui. All rights reserved.
//

#import "CateDetailViewController.h"
#import "HomeTopModel.h"
#import "TopListCell.h"
#import "AudioPlayerViewController.h"

@interface CateDetailViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) NSString * tagID;
@property (nonatomic, strong) NSString * name;

@property (nonatomic, strong) UITableView * tabview;
@property (nonatomic, strong) NSMutableArray * dataArray;

@end

@implementation CateDetailViewController

- (instancetype)initWithTagid:(NSString *)tagid tagName:(NSString *)tagName{
    self = [super init];
    if (self) {
        self.tagID = tagid;
        self.name = tagName;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self drawBackButtonWithType:BackImgTypeBlack];
    [self setNavTitle:@"财经头条" color:KTColor_MainBlack];
    [self creatUI];
    [self getData];
}
- (void)creatUI{
    self.dataArray = [NSMutableArray new];
    
    self.tabview = [KTFactory creatTabviewWithFrame:CGRectMake(0, 0, UI_WIDTH, UI_HEGIHT) style:UITableViewStylePlain];
    self.tabview.delegate = self;
    self.tabview.dataSource = self;
    [self.view addSubview:self.tabview];
    
    UILabel * headLabel = [KTFactory creatLabelWithText:self.name
                                              fontValue:font750(30)
                                              textColor:KTColor_MainBlack
                                          textAlignment:NSTextAlignmentCenter];
    headLabel.frame = CGRectMake(0, 0, UI_WIDTH, Anno750(88));
    self.tabview.tableHeaderView = headLabel;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    HomeTopModel * model = self.dataArray[indexPath.row];
    CGSize size = [KTFactory getSize:model.audioName maxSize:CGSizeMake(Anno750(646), 9999) font:[UIFont systemFontOfSize:font750(30)]];
    return Anno750(96) + size.height;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString * cellid = @"cateDetail";
    TopListCell * cell = [tableView dequeueReusableCellWithIdentifier:cellid];
    if (!cell) {
        cell = [[TopListCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid];
    }
    [cell updateWithHomeTopModel:self.dataArray[indexPath.row]];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [AudioPlayer instance].currentAudio = self.dataArray[indexPath.row];
    [AudioPlayer instance].playList = self.dataArray;
    AudioPlayerViewController * audioVC = [AudioPlayerViewController new];
    UINavigationController * nav = [[UINavigationController alloc]initWithRootViewController:audioVC];
    [self presentViewController:nav animated:YES completion:nil];
}

- (void)getData{
    NSDictionary * params = @{
                              @"tagId":self.tagID
                              };
    [[NetWorkManager manager] GETRequest:params pageUrl:Page_TagAudio complete:^(id result) {
        NSArray * arr = (NSArray *)result;
        for (int i = 0; i<arr.count; i++) {
            HomeTopModel * model = [[HomeTopModel alloc]initWithDictionary:arr[i]];
            [self.dataArray addObject:model];
        }
        [self.tabview reloadData];
    } errorBlock:^(KTError *error) {
        
    }];
}

@end
