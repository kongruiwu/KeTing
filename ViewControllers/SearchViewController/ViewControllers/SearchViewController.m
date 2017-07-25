//
//  SearchViewController.m
//  KeTing
//
//  Created by 吴孔锐 on 2017/7/17.
//  Copyright © 2017年 wurui. All rights reserved.
//

#import "SearchViewController.h"
#import "KTSearchBar.h"
#import "SearchListCell.h"
#import "HotWordModel.h"
#import "HotWordCell.h"
#import "HomeListenModel.h"
@interface SearchViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,HotWordCellDelegate>

@property (nonatomic, strong) KTSearchBar * searchBar;
@property (nonatomic, strong) UITextField * textField;
//@property (nonatomic, strong) UITableView * tabview;
@property (nonatomic, strong) NSMutableArray * hotWords;
@property (nonatomic, strong) NSMutableArray * dataArray;

@end

@implementation SearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavUnAlpha];
    [self CreatUI];
    [self getHotWord];
}

- (void)CreatUI{
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.searchBar = [[KTSearchBar alloc]initWithFrame:CGRectMake(0, 0, Anno750(600), Anno750(65))];
    self.textField = self.searchBar.searchTf;
    [self.textField addTarget:self action:@selector(textchaged:) forControlEvents:UIControlEventEditingChanged];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:self.searchBar];
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
    if (self.textField.text.length > 0) {
        return 10;
    }else{
        return 1;
    }
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.textField resignFirstResponder];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.textField.text.length > 0) {
        return Anno750(70);
    }else{
        return [self getButtonLineNumber:self.hotWords] * Anno750(80);
    }
}

- (int)getButtonLineNumber:(NSArray *)tags{
    int num = 0;
    float leftWith = Anno750(702);
    for (int i = 0; i<tags.count; i++){
        HotWordModel * model = tags[i];
        if (i == 0) {
            leftWith -= Anno750(24) + model.with + 2 * Anno750(30) + Anno750(20);
            num = 1;
        }else{
            if (leftWith>model.with) {
                leftWith -= model.with+ Anno750(50);
            }else{
                leftWith = Anno750(702);
                leftWith -= Anno750(24) + model.with + 2 * Anno750(30) + Anno750(20);
                num += 1;
            }
        }
    }
    return num;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (self.textField.text.length > 0) {
        return section == 0 ? Anno750(100) : Anno750(80);
    }else{
        return Anno750(80);
    }
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (self.textField.text.length > 0) {
        return Anno750(70);
    }else{
        return 0.01;
    }
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (self.textField.text.length > 0) {
        UIView * header = [KTFactory creatViewWithColor:[UIColor whiteColor]];
        header.frame = CGRectMake(0, 0, UI_WIDTH,section == 0 ? Anno750(100) : Anno750(80));
        UIView * groundView = [KTFactory creatViewWithColor:KTColor_BackGround];
        UILabel * label = [KTFactory creatLabelWithText:@"财经头条"
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
            make.height.equalTo(@(section == 0 ? Anno750(30) : Anno750(10)));
        }];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@(Anno750(24)));
            make.centerY.equalTo(@(section == 0 ? Anno750(15) : Anno750(5)));
            make.right.equalTo(@(-Anno750(24)));
        }];
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@(Anno750(24)));
            make.right.equalTo(@(-Anno750(24)));
            make.bottom.equalTo(@0);
            make.height.equalTo(@0.5);
        }];
        return header;
    }else{
        UIView * header = [KTFactory creatViewWithColor:[UIColor whiteColor]];
        header.frame = CGRectMake(0, 0, UI_WIDTH, Anno750(80));
        
        UILabel * label = [KTFactory creatLabelWithText:@"热门搜索"
                                              fontValue:font750(24)
                                              textColor:KTColor_darkGray
                                          textAlignment:NSTextAlignmentLeft];
        [header addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@(Anno750(24)));
            make.centerY.equalTo(@0);
        }];
        return header;
    }
    
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if (self.textField.text.length == 0) {
        return nil;
    }
    UIView * footer = [KTFactory creatViewWithColor:[UIColor whiteColor]];
    footer.frame = CGRectMake(0, 0, UI_WIDTH, Anno750(70));
    
    UIView * line = [KTFactory creatLineView];
    UILabel * label = [KTFactory creatLabelWithText:@"共计23个结果"
                                          fontValue:font750(24)
                                          textColor:KTColor_darkGray
                                      textAlignment:NSTextAlignmentLeft];
    UIImageView * arrow = [KTFactory creatArrowImage];
    
    [footer addSubview:line];
    [footer addSubview:label];
    [footer addSubview:arrow];
    
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(Anno750(24)));
        make.right.equalTo(@(Anno750(-24)));
        make.height.equalTo(@0.5);
        make.top.equalTo(@0);
    }];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(Anno750(24)));
        make.centerY.equalTo(@0);
    }];
    [arrow mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(@0);
        make.right.equalTo(@(-Anno750(24)));
    }];
    
    return footer;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (self.textField.text.length == 0) {
        return 1;
    }
    return self.dataArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.textField.text.length == 0) {
        static NSString * cellid = @"HotWordCell";
        HotWordCell * cell = [tableView dequeueReusableCellWithIdentifier:cellid];
        if (!cell) {
            cell = [[HotWordCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid];
        }
        [cell updateHotWords:self.hotWords];
        cell.delegate = self;
        return cell;
        
    }else{
        static NSString * cellid = @"SearchListCell";
        SearchListCell * cell = [tableView dequeueReusableCellWithIdentifier:cellid];
        if (!cell) {
            cell = [[SearchListCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid];
        }
        
        return cell;
    }
}
- (void)getHotWord{
    self.hotWords = [NSMutableArray new];
    [[NetWorkManager manager] GETRequest:@{} pageUrl:Page_SearchHot complete:^(id result) {
        NSDictionary * dic = (NSDictionary *)result;
        if (dic[@"high"] && ![dic[@"high"] isKindOfClass:[NSNull class]]) {
            self.textField.placeholder = dic[@"high"];
        }else{
            self.textField.placeholder = @"";
        }
        NSArray * arr = dic[@"hot"];
        for (int i = 0; i<arr.count; i++) {
            HotWordModel * model = [[HotWordModel alloc]initWithDictionary:arr[i]];
            [self.hotWords addObject:model];
        }
        [self.tabview reloadData];
    } errorBlock:^(KTError *error) {
        
    }];
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self searchRequest:self.textField.text];
    return NO;
}

- (void)textchaged:(UITextField *)textField{
    if (textField.text.length == 0) {
        [self hiddenNullView];
        [self.tabview reloadData];
    }
}
- (void)HotWordBtnClick:(NSString *)searchText{
    self.textField.text = searchText;
    [self searchRequest:searchText];
}
- (void)searchRequest:(NSString *)text{
//    self.textField resignFirstResponder
    [self showLoadingCantTouchAndClear];
    self.dataArray = [NSMutableArray new];
    NSDictionary * params = @{
                              @"search":text,
                              @"searchType":@1
                              };
    [[NetWorkManager manager] GETRequest:params pageUrl:Page_Search complete:^(id result) {
        [self dismissLoadingView];
        NSMutableArray * listens = [NSMutableArray new];
        NSMutableArray * tops = [NSMutableArray new];
        NSMutableArray * voices = [NSMutableArray new];
        NSDictionary * dic = result[@"list"];
    
        NSArray * listen = dic[@"listen"];
        NSArray * top = dic[@"top"];
        NSArray * voice = dic[@"voice"];
        for (int i = 0; i<listen.count; i++) {
            HomeListenModel * model = [[HomeListenModel alloc]initWithDictionary:listen[i]];
            [listens addObject:model];
        }
        for (int i = 0; i<top.count; i++) {
            HomeTopModel * model = [[HomeTopModel alloc]initWithDictionary:top[i]];
            [tops addObject:model];
        }
        for (int i = 0; i<voice.count; i++) {
            HomeListenModel * model = [[HomeListenModel alloc]initWithDictionary:voice[i]];
            [voices addObject:model];
        }
        
        if (listens.count>0) {
            NSDictionary * dic = @{@"听书":listens};
            [self.dataArray addObject:dic];
        }
        if (tops.count>0) {
            NSDictionary * dic = @{@"财经头条":tops};
            [self.dataArray addObject:dic];
        }
        if (voices.count>0) {
            NSDictionary * dic = @{@"声度":voices};
            [self.dataArray addObject:dic];
        }
        if (self.dataArray.count > 0) {
            [self hiddenNullView];
            [self.tabview reloadData];
        }
        if (self.dataArray.count == 0) {
            [self showNullViewWithNullViewType:NullTypeNoneSerach];
        }
        
    } errorBlock:^(KTError *error) {
        [self dismissLoadingView];
        [self showNullViewWithNullViewType:NullTypeNoneSerach];
    }];
}

@end
