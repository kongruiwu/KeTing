//
//  SearchSubViewController.m
//  KeTing
//
//  Created by 吴孔锐 on 2017/7/25.
//  Copyright © 2017年 wurui. All rights reserved.
//

#import "SearchSubViewController.h"
#import "KTSearchBar.h"
#import "HomeListenModel.h"
#import "SearchListCell.h"

//#import "AudioPlayerViewController.h"
#import "VoiceDetailViewController.h"
#import "ListenDetailViewController.h"

@interface SearchSubViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>

@property (nonatomic, strong) KTSearchBar * searchBar;
@property (nonatomic, strong) UITextField * textField;
@property (nonatomic, strong) NSMutableArray * dataArray;
@property (nonatomic, strong) NSDictionary * modelDic;
@property (nonatomic, strong) NSString * typeStr;
@end

@implementation SearchSubViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self drawBackButtonWithType:BackImgTypeBlack];
    [self creatUI];
    [self checkNetStatus];
}

- (void)creatUI{
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.modelDic = @{
                      @"听书":@2,
                      @"财经头条":@1,
                      @"声度":@3
                      };
    NSArray * keys = self.dataDic.allKeys;
    self.typeStr = keys[0];
    self.dataArray = [NSMutableArray arrayWithArray:self.dataDic[self.typeStr]];
    
    self.searchBar = [[KTSearchBar alloc]initWithFrame:CGRectMake(0, 0, Anno750(500), Anno750(65))];
    self.textField = self.searchBar.searchTf;
    [self.textField addTarget:self action:@selector(textchaged:) forControlEvents:UIControlEventEditingChanged];
    self.navigationItem.titleView = self.searchBar;
    self.textField.returnKeyType = UIReturnKeySearch;
    self.textField.delegate = self;
    
    UIBarButtonItem * rightBar = [[UIBarButtonItem alloc]initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(doBack)];
    self.navigationItem.rightBarButtonItem = rightBar;
    [self.navigationItem.rightBarButtonItem setTintColor:KTColor_darkGray];
    [self.navigationItem.rightBarButtonItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont boldSystemFontOfSize:font750(28)],NSFontAttributeName, nil] forState:UIControlStateNormal];
    
    self.tabview = [KTFactory creatTabviewWithFrame:CGRectMake(0, 0, UI_WIDTH, UI_HEGIHT - 64) style:UITableViewStyleGrouped];
    self.tabview.delegate = self;
    self.tabview.dataSource = self;
    [self.view addSubview:self.tabview];

}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return Anno750(70);
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return Anno750(100);
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView * header = [KTFactory creatViewWithColor:[UIColor whiteColor]];
    header.frame = CGRectMake(0, 0, UI_WIDTH,Anno750(100));
    UIView * groundView = [KTFactory creatViewWithColor:KTColor_BackGround];
    UILabel * label = [KTFactory creatLabelWithText:self.typeStr
                                          fontValue:font750(26)
                                          textColor:KTColor_MainOrange
                                      textAlignment:NSTextAlignmentLeft];
    UIView * line = [KTFactory creatLineView];
    
    [header addSubview:groundView];
    [header addSubview:label];
    [header addSubview:line];
    
    [groundView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@0);
        make.top.equalTo(@0);
        make.right.equalTo(@0);
        make.height.equalTo(@(Anno750(30)));
    }];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(Anno750(24)));
        make.centerY.equalTo(@(Anno750(15)));
        make.right.equalTo(@(-Anno750(24)));
    }];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(Anno750(24)));
        make.right.equalTo(@(-Anno750(24)));
        make.bottom.equalTo(@0);
        make.height.equalTo(@0.5);
    }];
    return header;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString * cellid = @"SearchListCell";
    SearchListCell * cell = [tableView dequeueReusableCellWithIdentifier:cellid];
    if (!cell) {
        cell = [[SearchListCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid];
    }
    if ([self.typeStr isEqualToString:@"财经头条"]) {
        HomeTopModel * model = self.dataArray[indexPath.row];
        cell.nameLabel.text = model.audioName;
    }else{
        HomeListenModel * model = self.dataArray[indexPath.row];
        cell.nameLabel.text = model.name;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([self.typeStr isEqualToString:@"财经头条"]) {
        [[AVQueenManager Manager] playAudioList:self.dataArray playAtIndex:indexPath.row];
        [self reloadTabviewFrame];
    }else if([self.typeStr isEqualToString:@"听书"]){
        ListenDetailViewController * vc = [ListenDetailViewController new];
        HomeListenModel * model = self.dataArray[indexPath.row];
        vc.listenID = model.listenId;
        [self.navigationController pushViewController:vc animated:YES];
    }else{
        HomeListenModel * model = self.dataArray[indexPath.row];
        VoiceDetailViewController * vc = [VoiceDetailViewController new];
        vc.voiceID = model.listenId;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    NSString * str = self.textField.text.length>0 ? self.textField.text : self.textField.placeholder;
    self.textField.text = str;
    [self searchRequest:self.textField.text];
    return NO;
}

- (void)textchaged:(UITextField *)textField{
    if (textField.text.length == 0) {
        [self hiddenNullView];
        [self.tabview reloadData];
    }
}
- (void)searchRequest:(NSString *)text{
    [self.textField resignFirstResponder];
    [self showLoadingCantTouchAndClear];
    self.dataArray = [NSMutableArray new];
    NSDictionary * params = @{
                              @"search":text,
                              @"searchType":self.modelDic[self.typeStr]
                              };
    [[NetWorkManager manager] GETRequest:params pageUrl:Page_Search complete:^(id result) {
        [self dismissLoadingView];
//        NSMutableArray * listens = [NSMutableArray new];
//        NSMutableArray * tops = [NSMutableArray new];
//        NSMutableArray * voices = [NSMutableArray new];
//        NSDictionary * dic = result[@"list"];
//        
//        NSArray * listen = dic[@"listen"];
//        NSArray * top = dic[@"top"];
//        NSArray * voice = dic[@"voice"];
//        for (int i = 0; i<listen.count; i++) {
//            HomeListenModel * model = [[HomeListenModel alloc]initWithDictionary:listen[i]];
//            [listens addObject:model];
//        }
//        for (int i = 0; i<top.count; i++) {
//            HomeTopModel * model = [[HomeTopModel alloc]initWithDictionary:top[i]];
//            [tops addObject:model];
//        }
//        for (int i = 0; i<voice.count; i++) {
//            HomeListenModel * model = [[HomeListenModel alloc]initWithDictionary:voice[i]];
//            [voices addObject:model];
//        }
//        
//        if (listens.count>0) {
//            NSDictionary * dic = @{@"听书":listens};
//            [self.dataArray addObject:dic];
//        }
//        if (tops.count>0) {
//            NSDictionary * dic = @{@"财经头条":tops};
//            [self.dataArray addObject:dic];
//        }
//        if (voices.count>0) {
//            NSDictionary * dic = @{@"声度":voices};
//            [self.dataArray addObject:dic];
//        }
        if (self.dataArray.count > 0) {
            [self hiddenNullView];
            [self.tabview reloadData];
        }else{
            [self showNullViewWithNullViewType:NullTypeNoneSerach];
        }
        
    } errorBlock:^(KTError *error) {
        [self dismissLoadingView];
        [self showNullViewWithNullViewType:NullTypeNoneSerach];
    }];
}


@end
