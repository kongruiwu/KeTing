//
//  SetUserNameViewController.m
//  KeTing
//
//  Created by 吴孔锐 on 2017/6/28.
//  Copyright © 2017年 wurui. All rights reserved.
//

#import "SetUserNameViewController.h"
#import "HeaderImage.h"
#import <ReactiveObjC.h>
@interface SetUserNameViewController ()<UIImagePickerControllerDelegate, UINavigationControllerDelegate,UserManagerDelegate>

@property (nonatomic, strong)HeaderImage * userIcon;

@property (nonatomic, strong) UITextField * nameT;
@property (nonatomic, strong) UIButton * chageBtn;

@end

@implementation SetUserNameViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self creatBackGroundImg];
    [self creatUI];
}
- (UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}
- (void)creatUI{
    UIButton * backBtn = [KTFactory creatButtonWithNormalImage:@"back_white" selectImage:nil];
    [backBtn addTarget:self action:@selector(doBack) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backBtn];
    [backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(Anno750(30)));
        make.top.equalTo(@(20+ Anno750(12)));
        make.width.equalTo(@(Anno750(64)));
        make.height.equalTo(@(Anno750(64)));
    }];
    
    self.userIcon = [[HeaderImage alloc]init];
    [self.userIcon.clearBtn addTarget:self action:@selector(uploadUserIcon) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.userIcon];
    [self.userIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(@0);
        make.top.equalTo(@(Anno750(200)));
        make.width.equalTo(@(Anno750(130)));
        make.height.equalTo(@(Anno750(130)));
    }];

    self.nameT = [KTFactory creattextfildWithPlaceHloder:@"请输入昵称"];
    [self.view addSubview:self.nameT];
    [self.nameT mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(Anno750(90)));
        make.right.equalTo(@(-Anno750(90)));
        make.top.equalTo(self.userIcon.mas_bottom).offset(Anno750(158 - 96));
        make.height.equalTo(@(Anno750(50)));
    }];
    UIView * lineup = [KTFactory creatLineView];
    [self.view addSubview:lineup];
    [lineup mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.nameT.mas_left);
        make.right.equalTo(self.nameT.mas_right);
        make.height.equalTo(@0.5);
        make.top.equalTo(self.nameT.mas_bottom).offset(Anno750(18));
    }];
    self.chageBtn= [KTFactory creatButtonWithTitle:@"保存"
                                    backGroundColor:KTColor_IconOrange
                                          textColor:KTColor_MainBlack
                                           textSize:font750(32)];
    [self.view addSubview:self.chageBtn];
    [self.chageBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.nameT.mas_left);
        make.right.equalTo(self.nameT.mas_right);
        make.height.equalTo(@(Anno750(88)));
        make.top.equalTo(lineup.mas_bottom).offset(Anno750(88));
    }];
    [self.chageBtn addTarget:self action:@selector(changeUserName) forControlEvents:UIControlEventTouchUpInside];
    
    [self.nameT.rac_textSignal subscribeNext:^(NSString * _Nullable x) {
        self.chageBtn.backgroundColor = x.length>=1 ? KTColor_MainOrange :KTColor_MainOrangeAlpha;
    }];
    
}
- (void)changeUserName{
    NSDictionary * params = @{
                              @"userid":[UserManager manager].info.USERID,
                              @"nickName":self.nameT.text
                              };
    [[NetWorkManager manager] POSTRequest:params pageUrl:Page_ChangeName complete:^(id result) {
        [ToastView presentToastWithin:self.view.window withIcon:APToastIconNone text:@"修改成功" duration:2.0f];
        [UserManager manager].info.NICKNAME = self.nameT.text;
        [UserManager manager].delegate = self;
        [[UserManager manager] getUserInfo];
    } errorBlock:^(KTError *error) {
        [ToastView presentToastWithin:self.view withIcon:APToastIconNone text:error.message duration:1.0f];
    }];
}
- (void)getUserInfoSucess{
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)uploadUserIcon{
    UIAlertController * alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction * cammer = [UIAlertAction actionWithTitle:@"相机" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSUInteger sourceType = UIImagePickerControllerSourceTypeCamera;
        UIImagePickerController *picker = [[UIImagePickerController alloc]init];
        picker.delegate = self;
        picker.allowsEditing=NO;
        picker.title = @"照片";
        picker.sourceType = sourceType;
        [self presentViewController:picker animated:YES completion:NULL];
    }];
    UIAlertAction * photo = [UIAlertAction actionWithTitle:@"从相册中选择" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSUInteger sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        
        UIImagePickerController *picker = [[UIImagePickerController alloc]init];
        picker.delegate = self;
        picker.allowsEditing=NO;
        picker.title = @"照片";
        picker.sourceType = sourceType;
        [self presentViewController:picker animated:YES completion:NULL];
    }];
    UIAlertAction *cannce = [UIAlertAction actionWithTitle:@"取消" style:(UIAlertActionStyleCancel) handler:nil];
    [alert addAction:cammer];
    [alert addAction:photo];
    [alert addAction:cannce];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary<NSString *,id> *)editingInfo
{
    [self dismissViewControllerAnimated:NO completion:^{
        self.userIcon.userIcon.image = image;
//        NSData *data = [KTFactory dealWithAvatarImage:image];
//        [[NetWorkManager manager] uploadImage:image];
//        NSString * string = [NSString stringWith]
//        NSDictionary * params = @{
//                                  
//                                  };
//        [NetWorkManager manager] POSTRequest:<#(NSDictionary *)#> pageUrl:<#(NSString *)#> complete:<#^(id result)complete#> errorBlock:<#^(KTError *error)errorBlock#>
    }];
}

@end
