//
//  HooLoginController.m
//  MomentsLife
//
//  Created by HooJackie on 15/9/18.
//  Copyright (c) 2015年 jackieHoo. All rights reserved.
//
#import <ShareSDK/ShareSDK.h>
#import "WXApi.h"
#import <BmobSDK/Bmob.h>
#import <TencentOpenAPI/TencentOAuth.h>
#import "HooLoginController.h"
#import "HooRegisterController.h"
#import "HooPhoneRegisterController.h"
#import "HooForgetPasswordController.h"
#import "HooUserInfoController.h"
#import "HooUserManager.h"
#import "SVProgressHUD.h"
#import "NSString+Extension.h"
#import <TencentOpenAPI/QQApi.h>

@interface HooLoginController ()<TencentSessionDelegate>

@property (nonatomic, retain)TencentOAuth *tencentOAuth;

@property (weak, nonatomic) IBOutlet UITextField *userNameTextField;

@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;

@property (weak, nonatomic) IBOutlet UIButton *forgetButton;

@property (weak, nonatomic) IBOutlet UIButton *QQLoginButton;

@property (weak, nonatomic) IBOutlet UILabel *QQLoginLabel;

@end

@implementation HooLoginController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.

    [self setupView];
    
    if (![QQApi isQQInstalled]) {
        self.QQLoginButton.hidden = YES;
        self.QQLoginLabel.hidden = YES;
    }
    
    
    
}
- (void)setupView
{
    self.title = @"登录";
    
   
    //用户输入框
    UIView *leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 30, 50)];
    self.userNameTextField.leftViewMode = UITextFieldViewModeAlways;
    self.userNameTextField.textColor = HooColor(80, 152, 200);
    [self.userNameTextField setValue:HooColor(80, 152, 200) forKeyPath:@"_placeholderLabel.textColor"];
    self.userNameTextField.leftView = leftView;
    //密码输入框
    UIView *leftView2 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 30, 50)];
    self.passwordTextField.leftViewMode = UITextFieldViewModeAlways;
    self.passwordTextField.leftView = leftView2;
    self.passwordTextField.textColor = HooColor(80, 152, 200);
    [self.passwordTextField setValue:HooColor(80, 152, 200) forKeyPath:@"_placeholderLabel.textColor"];
    
    //忘记密码按钮
    NSMutableAttributedString *title = [[NSMutableAttributedString alloc] initWithString:@"忘记密码"];
    [title addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:NSMakeRange(0, title.length)];
    [title addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:NSMakeRange(0, title.length)];
    [self.forgetButton setAttributedTitle:title forState:UIControlStateNormal];

}
- (void)closeController
{
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (IBAction)forgetButtonClicked:(UIButton *)sender {
    HooForgetPasswordController *forgetCtrl = [[HooForgetPasswordController alloc] init];
    [self.navigationController pushViewController:forgetCtrl animated:YES];
}

#pragma mark - 登录按钮点击
- (IBAction)login:(UIButton *)sender {
    if([self.userNameTextField.text isEmpty] || [self.passwordTextField.text isEmpty]){
        [SVProgressHUD showErrorWithStatus:@"用户名或密码不能为空"];
    }else{
        __weak typeof(self) weakSelf = self;
        [[HooUserManager manager] LoginWithUserName:self.userNameTextField.text andPassword:self.passwordTextField.text block:^(BmobUser *user, NSError *error) {
            __strong __typeof(weakSelf)strongSelf = weakSelf;
            if (error) {
                [SVProgressHUD showErrorWithStatus:@"登录失败"];
            }else if(user){
                [SVProgressHUD showSuccessWithStatus:@"登录成功"];
                
                [strongSelf loginSuccessDismiss];
            }
        }];
    }
}

- (void)loginSuccessDismiss
{
    if (self.fromMyPrint) {
        HooUserInfoController *userInfoCtrl = [[HooUserInfoController alloc] init];
        [self.navigationController pushViewController:userInfoCtrl animated:YES];
    }
    if (self.fromEdit) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}


#pragma mark - 注册按钮点击
- (IBAction)registerBtnClicked:(UIButton *)sender {
    //选择注册方式
    [self showPhotoSelectMenu:sender];
    
}

//显示选择按钮
- (void)showPhotoSelectMenu:(UIButton *)sender
{
    UIAlertController *alertCtrl = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [alertCtrl addAction:cancelAction];
    
    UIAlertAction *phoneRegisterAction = [UIAlertAction actionWithTitle:@"手机注册" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        HooPhoneRegisterController *phoneRegisterCtrl = [[HooPhoneRegisterController alloc] init];
        [self.navigationController pushViewController:phoneRegisterCtrl animated:YES];
    }];
    [alertCtrl addAction:phoneRegisterAction];
    UIAlertAction *userNameRegisterAction = [UIAlertAction actionWithTitle:@"用户名注册" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        
        HooRegisterController *registerCtrl = [[HooRegisterController alloc] init];
        [self.navigationController pushViewController:registerCtrl animated:YES];
    }];
    
    [alertCtrl addAction:userNameRegisterAction];
    alertCtrl.popoverPresentationController.sourceView = self.view;
    alertCtrl.popoverPresentationController.sourceRect = sender.frame;
    [self presentViewController:alertCtrl animated:YES completion:nil];
}
#pragma mark -  微博登录
- (IBAction)weiboLogin:(UIButton *)sender {
    __weak typeof(self) weakSelf = self;
        [ShareSDK getUserInfoWithType:ShareTypeSinaWeibo
                          authOptions:nil
                               result:^(BOOL result, id<ISSPlatformUser> userInfo, id<ICMErrorInfo> error) {
                                   if (result)
                                   {

                                       BmobQuery *query = [BmobQuery queryWithClassName:@"_User"];
                                       [query whereKey:@"objectId" equalTo:[userInfo uid]];
                                       [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
                                           if (error) {
                                               HooLog(@"%@",error);
                                               [SVProgressHUD showErrorWithStatus:@"第三方登录失败"];
                                               return;
                                           }
                                           
                                           if ([objects count] == 0)
                                           {                                              
                                               //  记录登录用户的OpenID、Token以及过期时间
                                               id<ISSPlatformCredential> credential = [userInfo credential];
                                               NSString *accessToken = [credential token];
                                               NSDate *expirationDate = [credential expired];
                                               NSString *uid = [userInfo uid];
                                               NSDictionary *dic = @{@"access_token":accessToken,@"uid":uid,@"expirationDate":expirationDate};
                                               [[HooUserManager manager] loginThirdPartyWith:dic block:^(BmobUser *user, NSError *error) {
                                                   if (user) {
                                                       [weakSelf loginSuccessDismiss];

                                                   }
                                               }];
                                               
                                           }
                                       }];
                                   }
                                   
                               }];
}

#pragma mark -  微信登录
- (IBAction)weixinLogin:(UIButton *)sender {
    if ([WXApi isWXAppInstalled]){
        SendAuthReq* req =[[SendAuthReq alloc ] init];
        req.scope = @"snsapi_userinfo,snsapi_base";
        req.state = @"0744" ;
        [WXApi sendReq:req];
    } else {
        [SVProgressHUD showErrorWithStatus:@"没有安装微信客户端"];
    }
}
#pragma mark -  QQ登录
- (IBAction)qqLogin:(UIButton *)sender {
    if ([TencentOAuth iphoneQQInstalled]) {
        //注册
        _tencentOAuth = [[TencentOAuth alloc] initWithAppId:@"1104733359" andDelegate:self];
        //授权
        NSArray *permissions = [NSArray arrayWithObjects:kOPEN_PERMISSION_GET_INFO,nil];
        [_tencentOAuth authorize:permissions inSafari:NO];
        //获取用户信息
        [_tencentOAuth getUserInfo];
    } else {
        [SVProgressHUD showErrorWithStatus:@"没有安装QQ"];
    }
}

- (void)tencentDidLogin{
    __weak typeof(self) weakSelf = self;

    if (_tencentOAuth.accessToken && 0 != [_tencentOAuth.accessToken length]){
        //  记录登录用户的OpenID、Token以及过期时间
        NSString *accessToken = _tencentOAuth.accessToken;
        NSString *uid = _tencentOAuth.openId;
        NSDate *expiresDate = _tencentOAuth.expirationDate;
        NSDictionary *dic = @{@"access_token":accessToken,@"uid":uid,@"expirationDate":expiresDate};
        
        //通过授权信息注册登录
        [[HooUserManager manager] loginThirdPartyWith:dic block:^(BmobUser *user, NSError *error) {
            if (error) {
                [SVProgressHUD showErrorWithStatus:@"第三方登录失败"];
            }
            if (user) {
                [weakSelf loginSuccessDismiss];
            }
            
        }];
    }else{
        [SVProgressHUD showErrorWithStatus:@"第三方登录失败"];
    }
    
}
- (void)tencentDidNotLogin:(BOOL)cancelled{
    [SVProgressHUD showErrorWithStatus:@"你取消了第三方登录"];
}

- (void)tencentDidNotNetWork{
    
    [SVProgressHUD showErrorWithStatus:@"第三方登录连接网络失败"];
}
- (void)dealloc
{
    HooLog(@"HooLoginController");
}

@end
