//
//  TimeListenViewController.m
//  KeTing
//
//  Created by 吴孔锐 on 2017/6/13.
//  Copyright © 2017年 wurui. All rights reserved.
//

#import "TimeListenViewController.h"
#import "LoginViewController.h"
#import "HomeTopModel.h"
#import "AudioPlayerViewController.h"
#import "PorgressView.h"
@interface TimeListenViewController ()

@property (nonatomic, strong) UIImageView * userIcon;
@property (nonatomic, strong) UILabel * userName;
@property (nonatomic, strong) UILabel * descLabel;
@property (nonatomic, strong) UIButton * threeBtn;
@property (nonatomic, strong) UIButton * tenBtn;
@property (nonatomic, strong) UIButton * fourBtn;
@property (nonatomic, strong) UIButton * hourBtn;
@property (nonatomic, strong) NSMutableArray * dataArray;
@property (nonatomic, strong) PorgressView * progressView;
@property (nonatomic, strong) NSTimer * timer;
@property (nonatomic) BOOL canNext;

@end

@implementation TimeListenViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self updateUI];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.dataArray  = [NSMutableArray new];
    [self creatui];
}
- (void)creatui{
    UIButton * clearButton = [KTFactory creatButtonWithNormalImage:@"" selectImage:@""];
    [clearButton addTarget:self action:@selector(userLogin) forControlEvents:UIControlEventTouchUpInside];
    self.userIcon = [KTFactory creatImageViewWithImage:@"default_head"];

    self.userIcon.layer.cornerRadius = Anno750(60);
    self.userIcon.layer.masksToBounds = YES;
    self.userName = [KTFactory creatLabelWithText:@"你好"
                                        fontValue:font750(28)
                                        textColor:KTColor_darkGray
                                    textAlignment:NSTextAlignmentCenter];
    self.descLabel = [KTFactory creatLabelWithText:@"此刻，这里的时间由你决定"
                                         fontValue:font750(36)
                                         textColor:KTColor_lightGray
                                     textAlignment:NSTextAlignmentCenter];
    self.threeBtn = [KTFactory creatButtonWithNormalImage:@"listening_30" selectImage:nil];
    self.tenBtn = [KTFactory creatButtonWithNormalImage:@"listening_15" selectImage:nil];
    self.fourBtn = [KTFactory creatButtonWithNormalImage:@"listening_45" selectImage:nil];
    self.hourBtn = [KTFactory creatButtonWithNormalImage:@"listening_1H" selectImage:nil];
    [self.threeBtn addTarget:self action:@selector(request30) forControlEvents:UIControlEventTouchUpInside];
    [self.tenBtn addTarget:self action:@selector(request15) forControlEvents:UIControlEventTouchUpInside];
    [self.fourBtn addTarget:self action:@selector(request45) forControlEvents:UIControlEventTouchUpInside];
    [self.hourBtn addTarget:self action:@selector(request60) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:self.userIcon];
    [self.view addSubview:self.userName];
    [self.view addSubview:self.descLabel];
    [self.view addSubview:self.threeBtn];
    [self.view addSubview:self.tenBtn];
    [self.view addSubview:self.fourBtn];
    [self.view addSubview:self.hourBtn];
    [self.view addSubview:clearButton];
    
    [self.userIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@(Anno750(100)));
        make.centerX.equalTo(@0);
        make.height.equalTo(@(Anno750(120)));
        make.width.equalTo(@(Anno750(120)));
    }];
    [self.userName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.userIcon.mas_bottom).offset(Anno750(20));
        make.centerX.equalTo(@0);
    }];
    [clearButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.userIcon.mas_top);
        make.bottom.equalTo(self.userName.mas_bottom);
        make.left.equalTo(self.userIcon.mas_left);
        make.right.equalTo(self.userIcon.mas_right);
    }];
    [self.descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(@0);
        make.top.equalTo(self.userName.mas_bottom).offset(Anno750(110));
    }];
    [self.threeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(@0);
        make.top.equalTo(self.descLabel.mas_bottom).offset(Anno750(60));
        make.width.equalTo(@(Anno750(226)));
        make.height.equalTo(@(Anno750(226)));
    }];
    [self.fourBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(@0);
        make.top.equalTo(self.threeBtn.mas_bottom).offset(Anno750(72));
        make.height.equalTo(@(Anno750(176)));
        make.width.equalTo(@(Anno750(176)));
    }];
    [self.tenBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.fourBtn.mas_left).offset(Anno750(-80));
        make.centerY.equalTo(self.fourBtn.mas_centerY);
        make.height.equalTo(@(Anno750(176)));
        make.width.equalTo(@(Anno750(176)));
    }];
    [self.hourBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.fourBtn.mas_right).offset(Anno750(80));
        make.centerY.equalTo(self.fourBtn.mas_centerY);
        make.height.equalTo(@(Anno750(176)));
        make.width.equalTo(@(Anno750(176)));
    }];
    
    self.canNext = YES;
    self.progressView = [[PorgressView alloc]initWithFrame:CGRectMake(0, 0, UI_WIDTH, UI_HEGIHT)];
    [self.progressView.cannceBtn addTarget:self action:@selector(cannceAllDoing) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.progressView];
    
    
}


- (void)userLogin{
    if (![UserManager manager].isLogin) {
        UINavigationController * nav = [[UINavigationController alloc]initWithRootViewController:[LoginViewController new]];
        [self presentViewController:nav animated:YES completion:nil];
    }
}
- (void)updateUI{
    [self.userIcon sd_setImageWithURL:[NSURL URLWithString:[UserManager manager].info.ICON] placeholderImage:[UIImage imageNamed:@"default_head"]];
    self.userName.text = [UserManager manager].isLogin ? [NSString stringWithFormat:@"%@,你好",[UserManager manager].info.NICKNAME]:@"你好";
}
- (void)request30{
    [self requestListenList:30];
}
- (void)request15{
    [self requestListenList:15];
}
- (void)request45{
    [self requestListenList:45];
}
- (void)request60{
    [self requestListenList:60];
}
- (void)cannceAllDoing{
    [self.timer invalidate];
    self.timer = nil;
    self.canNext = NO;
    [self.progressView disMiss];
}
- (void)changeProgressViewSlow{
    self.progressView.progressView.progress += 0.001;
}
- (void)changeProgressViewQuick{
    float value = [self.timer.userInfo floatValue];
    self.progressView.progressView.progress += value;
}
- (void)requestListenList:(int)num{
    
    [self.progressView show];
    self.timer = [NSTimer scheduledTimerWithTimeInterval:0.05 target:self selector:@selector(changeProgressViewSlow) userInfo:nil repeats:YES];
    [self.dataArray removeAllObjects];
    NSDictionary * params = @{
                              @"userId":[UserManager manager].isLogin?[UserManager manager].userid:@0,
                              @"longTime":@(num)
                              };
    [[NetWorkManager manager] GETRequest:params pageUrl:page_TimeListen complete:^(id result) {
        float value = (1.0 - self.progressView.progressView.progress)/(2/0.05);
        NSArray * list = result[@"list"];
        [self.timer invalidate];
        self.timer = nil;
        self.timer = [NSTimer scheduledTimerWithTimeInterval:0.05 target:self selector:@selector(changeProgressViewQuick) userInfo:[NSNumber numberWithFloat:value] repeats:YES];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            if (!self.canNext) {
                self.canNext = YES;
                return ;
            }
            [self.timer invalidate];
            self.timer = nil;
            [self.progressView disMiss];
            for (int i = 0; i<list.count; i++) {
                HomeTopModel * model = [[HomeTopModel alloc]initWithDictionary:list[i]];
                [self.dataArray addObject:model];
            }
            [AudioPlayer instance].currentAudio = self.dataArray[0];
            [AudioPlayer instance].playList = self.dataArray;
            AudioPlayerViewController * audioVC = [AudioPlayerViewController new];
            UINavigationController * nav = [[UINavigationController alloc]initWithRootViewController:audioVC];
            [self presentViewController:nav animated:YES completion:nil];
        });
    } errorBlock:^(KTError *error) {
        [self.timer invalidate];
        self.timer = nil;
        [self.progressView disMiss];
    }];
}

@end