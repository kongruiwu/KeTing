//
//  UserInfoViewController.m
//  KeTing
//
//  Created by 吴孔锐 on 2017/6/26.
//  Copyright © 2017年 wurui. All rights reserved.
//

#import "UserInfoViewController.h"
#import "UserInfoListCell.h"
#import "HeaderImage.h"
#import "DatePickerSelectView.h"
#import "PickerView.h"
#import "GTMBase64.h"
#import "CropViewController.h"
@interface UserInfoViewController ()<UITableViewDelegate,UITableViewDataSource,UIPickerViewDelegate,UIImagePickerControllerDelegate, UINavigationControllerDelegate>

//@property (nonatomic, strong) UITableView * tabview;
@property (nonatomic, strong) NSArray * titles;
@property (nonatomic, strong) NSArray * descs;
@property (nonatomic, strong) HeaderImage * headerImg;
@property (nonatomic, strong) DatePickerSelectView * dateView;
@property (nonatomic, strong) PickerView * pickerView;
@property (nonatomic, assign) BOOL isEdu;

@end

@implementation UserInfoViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self drawBackButtonWithType:BackImgTypeBlack];
    [self setNavTitle:@"个人资料" color:KTColor_MainBlack];
    [self creatUI];
}
- (void)creatUI{
    
    self.dateView = [[DatePickerSelectView alloc]initWithFrame:CGRectMake(0, 64, UI_WIDTH, UI_HEGIHT)];
    [self.view addSubview:self.dateView];
    [self.dateView.datePicker setDate:[NSDate dateWithTimeIntervalSince1970:[[UserManager manager].info.BIRTHDAY longLongValue]]];
    [self.dateView.sureBtn addTarget:self action:@selector(setBirthdayReuqest) forControlEvents:UIControlEventTouchUpInside];
    
    self.pickerView = [[PickerView alloc]initWithFrame:CGRectMake(0, 64, UI_WIDTH, UI_HEGIHT)];
    [self.view addSubview:self.pickerView];
    [self.pickerView.sureBtn addTarget:self action:@selector(setEduRequest) forControlEvents:UIControlEventTouchUpInside];
    
    
    self.titles = @[@"昵称",@"性别",@"生日",@"学历",@"投资方向"];
    self.descs = @[INCASE_EMPTY([UserManager manager].info.NICKNAME, @"小西瓜"),
                   [UserManager manager].info.Sex?@"男":@"女",
                   INCASE_EMPTY([UserManager manager].info.Birthday, @"点击设置"),
                   INCASE_EMPTY([UserManager manager].info.EDU_NAME, @"点击设置"),
                   INCASE_EMPTY([UserManager manager].info.TYP_NAME, @"点击设置")];
    self.tabview = [KTFactory creatTabviewWithFrame:CGRectMake(0, 64, UI_WIDTH, UI_HEGIHT - 64) style:UITableViewStyleGrouped];
    self.tabview.delegate = self;
    self.tabview.dataSource = self;
    [self.view addSubview:self.tabview];
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return Anno750(88);
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return Anno750(280);
}
- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView * header = [KTFactory creatViewWithColor:[UIColor whiteColor]];
    header.frame = CGRectMake(0, 0, UI_WIDTH, Anno750(280));
    UIView * groundView = [KTFactory creatViewWithColor:KTColor_BackGround];
    self.headerImg = [[HeaderImage alloc]init];
    [self.headerImg.clearBtn addTarget:self action:@selector(uploadUserIcon) forControlEvents:UIControlEventTouchUpInside];
    [self.headerImg updateUserIcon];
    [header addSubview:self.headerImg];
    [header addSubview:groundView];
    [groundView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@0);
        make.right.equalTo(@0);
        make.height.equalTo(@(Anno750(30)));
        make.top.equalTo(@0);
    }];
    [self.headerImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(@0);
        make.centerY.equalTo(@(Anno750(15)));
        make.height.equalTo(@(Anno750(131)));
        make.width.equalTo(@(Anno750(131)));
    }];
    return header;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return Anno750(0.01);
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.titles.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString * cellid = @"UserInfoListCell";
    UserInfoListCell * cell = [tableView dequeueReusableCellWithIdentifier:cellid];
    if (!cell) {
        cell = [[UserInfoListCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid];
    }
    [cell updateWithName:self.titles[indexPath.row] desc:self.descs[indexPath.row]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        [self setUserNickName];
    }else if (indexPath.row == 1) {
        [self setGenerChoose];
    }else if (indexPath.row == 2){
        [self.view bringSubviewToFront:self.dateView];
        [self.dateView show];
    }else if(indexPath.row == 3){
        [self.view bringSubviewToFront:self.pickerView];
        self.isEdu = YES;
        if ([UserManager manager].info.EDU_ID && [[UserManager manager].info.EDU_ID integerValue] != 0) {
            NSInteger index = [[UserManager manager].dataModel.eduIds indexOfObject:[NSString stringWithFormat:@"%@",[UserManager manager].info.EDU_ID]];
            [self.pickerView.picker selectRow:index inComponent:0 animated:NO];
        }
        self.pickerView.pickerDatas = [UserManager manager].dataModel.eduNames;
        [self.pickerView show];
    }else if(indexPath.row == 4){
        [self.view bringSubviewToFront:self.pickerView];
        self.isEdu = NO;
        if ([UserManager manager].info.TYP_ID && [[UserManager manager].info.TYP_ID integerValue] != 0) {
            NSInteger index = [[UserManager manager].dataModel.typIds indexOfObject:[UserManager manager].info.TYP_ID];
            [self.pickerView.picker selectRow:index inComponent:0 animated:NO];
        }
        self.pickerView.pickerDatas = [UserManager manager].dataModel.typNames;
        [self.pickerView show];
    }

}
- (void)setUserNickName{
    UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"修改昵称" message:nil preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction * sureAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if (10>=alert.textFields[0].text.length>0) {
            [self setUserNickNameRequest:alert.textFields[0].text];
        }else{
            [ToastView presentToastWithin:self.view withIcon:APToastIconNone text:@"昵称长度为10字以内" duration:1.0f];
        }
        
    }];
    [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
       textField.placeholder = @"请输入新的昵称";
    }];
    UIAlertAction * cannceAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [alert addAction:sureAction];
    [alert addAction:cannceAction];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)setGenerChoose{
    UIAlertController * alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction * manAction = [UIAlertAction actionWithTitle:@"男" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self setGenerRequestWithSex:@1];
    }];
    UIAlertAction * womenAction = [UIAlertAction actionWithTitle:@"女" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self setGenerRequestWithSex:@0];
    }];
    UIAlertAction * cannceAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [alert addAction:manAction];
    [alert addAction:womenAction];
    [alert addAction:cannceAction];
    [self presentViewController:alert animated:YES completion:nil];
}
- (void)setGenerRequestWithSex:(NSNumber *)sex{
    [self showLoadingCantTouchAndClear];
    NSDictionary * params = @{
                              @"nickName":[UserManager manager].info.NICKNAME,
                              @"sex":sex,
                              @"birthday":INCASE_EMPTY([UserManager manager].info.Birthday, [UserManager manager].info.BIRTHDAY),
                              @"typ_id":[UserManager manager].info.TYP_ID,
                              @"edu_id":[UserManager manager].info.EDU_ID
                              };
    [[NetWorkManager manager] POSTRequest:params pageUrl:Page_ChangeInfo complete:^(id result) {
        [self dismissLoadingView];
        [UserManager manager].info.Sex = [sex boolValue];
        [self reloadView];
        [ToastView presentToastWithin:self.view withIcon:APToastIconNone text:@"修改成功" duration:1.0f];
    } errorBlock:^(KTError *error) {
        [self dismissLoadingView];
    }];
}
- (void)setUserNickNameRequest:(NSString *)nickName{
    [self showLoadingCantTouchAndClear];
    NSDictionary * params = @{
                              @"nickName":nickName,
                              @"sex":@([UserManager manager].info.Sex),
                              @"birthday":INCASE_EMPTY([UserManager manager].info.Birthday, [UserManager manager].info.BIRTHDAY),
                              @"typ_id":[UserManager manager].info.TYP_ID,
                              @"edu_id":[UserManager manager].info.EDU_ID
                              };
    [[NetWorkManager manager] POSTRequest:params pageUrl:Page_ChangeInfo complete:^(id result) {
        [self dismissLoadingView];
        [UserManager manager].info.NICKNAME = nickName;
        [self reloadView];
        [ToastView presentToastWithin:self.view withIcon:APToastIconNone text:@"修改成功" duration:1.0f];
    } errorBlock:^(KTError *error) {
        [self dismissLoadingView];
    }];
}
- (void)setBirthdayReuqest{
    [self showLoadingCantTouchAndClear];
    NSDate* date = self.dateView.datePicker.date;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy/MM/dd"];
    NSString * dateString = [dateFormatter stringFromDate:date];
    NSDictionary * params = @{
                              @"nickName":[UserManager manager].info.NICKNAME,
                              @"sex":@([UserManager manager].info.Sex),
                              @"typ_id":[UserManager manager].info.TYP_ID,
                              @"edu_id":[UserManager manager].info.EDU_ID,
                              @"birthday":dateString
                              };
    [[NetWorkManager manager] POSTRequest:params pageUrl:Page_ChangeInfo complete:^(id result) {
        [self dismissLoadingView];
        [self.dateView disMiss];
        [self.dateView.datePicker setDate:date];
        [UserManager manager].info.Birthday = dateString;
        [self reloadView];
        [ToastView presentToastWithin:self.view withIcon:APToastIconNone text:@"修改成功" duration:1.0f];
    } errorBlock:^(KTError *error) {
        [self dismissLoadingView];
    }];
}
- (void)setEduRequest{
    [self showLoadingCantTouchAndClear];
    NSInteger index = [self.pickerView.picker selectedRowInComponent:0];
    NSString * key = self.isEdu ? @"edu_id":@"typ_id";
    NSString * value = self.isEdu ? [UserManager manager].dataModel.eduIds[index] : [UserManager manager].dataModel.typIds[index];
    NSString * key1 = self.isEdu ? @"typ_id":@"edu_id";
    NSString * value2 = self.isEdu ? [UserManager manager].info.TYP_ID : [NSString stringWithFormat:@"%@",[UserManager manager].info.EDU_ID];
    NSDictionary * params = @{
                              @"nickName":[UserManager manager].info.NICKNAME,
                              @"sex":@([UserManager manager].info.Sex),
                              @"birthday":INCASE_EMPTY([UserManager manager].info.Birthday, [UserManager manager].info.BIRTHDAY),
                              key:value,
                              key1:value2
                              };
    [[NetWorkManager manager] POSTRequest:params pageUrl:Page_ChangeInfo complete:^(id result) {
        [self dismissLoadingView];
        if (self.isEdu) {
            [UserManager manager].info.EDU_ID = @([value integerValue]);
            [UserManager manager].info.EDU_NAME = [UserManager manager].dataModel.eduNames[index];
        }else{
            [UserManager manager].info.TYP_ID = value;
            [UserManager manager].info.TYP_NAME = [UserManager manager].dataModel.typNames[index];
        }
        [self.pickerView disMiss];
        [self reloadView];
        [ToastView presentToastWithin:self.view withIcon:APToastIconNone text:@"修改成功" duration:1.0f];
    } errorBlock:^(KTError *error) {
        [self dismissLoadingView];
    }];
}

- (void)reloadView{
    self.descs = @[INCASE_EMPTY([UserManager manager].info.NICKNAME, @"小西瓜"),
                   [UserManager manager].info.Sex?@"男":@"女",
                   INCASE_EMPTY([UserManager manager].info.Birthday, @"点击设置"),
                   INCASE_EMPTY([UserManager manager].info.EDU_NAME, @"点击设置"),
                   INCASE_EMPTY([UserManager manager].info.TYP_NAME, @"点击设置")];
    [self.tabview reloadData];
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
        
        CropViewController * cropVC = [[CropViewController alloc] initWithNibName:@"CropViewController" bundle:nil];
        UINavigationController * nav = [[UINavigationController alloc] initWithRootViewController:cropVC];
        cropVC.IMg = [self  imageCrop:image];
        __weak UserInfoViewController * blockSelf = self;
        cropVC.cropIMGBlock = ^(UIImage * img){
            //    上传图片的数据请求
            blockSelf.headerImg.userIcon.image = img;
            [blockSelf uploadImagerequest:img];
        };
        [self presentViewController:nav animated:YES completion:nil];
        
        
        
    }];
}
- (void)uploadImagerequest:(UIImage *)image{
    [self showLoadingCantTouchAndClear];
    NSData *data = [KTFactory dealWithAvatarImage:image];
    //判断图片是不是png格式的文件
    NSString *mimeType = nil;
    if (UIImagePNGRepresentation(image)) {
        mimeType = @"image/png";
    }else {
        mimeType = @"image/jpeg";
    }
    NSString * datastr = [NSString stringWithFormat:@"data:%@;base64,%@",mimeType,[GTMBase64 stringByEncodingData:data]];
    NSDictionary * params = @{
                              @"icon":datastr
                              };
    [[NetWorkManager manager] POSTRequest:params pageUrl:Page_UserAvater complete:^(id result) {
        [self dismissLoadingView];
        [ToastView presentToastWithin:self.view withIcon:APToastIconNone text:@"头像上传成功" duration:1.0f];
    } errorBlock:^(KTError *error) {
        [self dismissLoadingView];
        NSLog(@"%@",error.message);
    }];
}
-(UIImage *) imageCrop:(UIImage *)sourceImage
{
    CGSize imageSize = sourceImage.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    BOOL ISWho = width>height;
    CGFloat targetWidth = ISWho? width*UI_WIDTH/height:UI_WIDTH;
    CGFloat targetHeight =  ISWho?UI_WIDTH: UI_WIDTH*height/width;
    UIGraphicsBeginImageContext(CGSizeMake(targetWidth, targetHeight));
    [sourceImage drawInRect:CGRectMake(0,0,targetWidth,  targetHeight)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}
@end
