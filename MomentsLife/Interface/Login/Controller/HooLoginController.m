//
//  HooLoginController.m
//  MomentsQuote(丁丁美文)
//
//  Created by HooJackie on 15/9/18.
//  Copyright (c) 2015年 jackieHoo. All rights reserved.
//
#import <BmobSDK/Bmob.h>
#import "HooLoginController.h"
#import "HooRegisterController.h"
#import "HooPhoneRegisterController.h"
#import "HooForgetPasswordController.h"
#import "SVProgressHUD.h"
#import "NSString+Extension.h"
#import "WeiboSDK.h"
#import "WXApi.h"
#import "HooSaveTools.h"


@interface HooLoginController ()
@property (weak, nonatomic) IBOutlet UITextField *userNameTextField;

@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;

@property (weak, nonatomic) IBOutlet UIButton *forgetButton;
@end

@implementation HooLoginController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.

    [self setupView];
    
}
- (void)setupView
{
    self.title = @"登录";
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"corner_back_flat"] style:UIBarButtonItemStyleDone target:self action:@selector(back)];
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"login_bg"]];
    
    UIView *leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 30, 50)];
    self.userNameTextField.leftViewMode = UITextFieldViewModeAlways;
    self.userNameTextField.textColor = HooColor(80, 152, 200);
    [self.userNameTextField setValue:HooColor(80, 152, 200) forKeyPath:@"_placeholderLabel.textColor"];
    self.userNameTextField.leftView = leftView;
    UIView *leftView2 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 30, 50)];
    self.passwordTextField.leftViewMode = UITextFieldViewModeAlways;
    self.passwordTextField.leftView = leftView2;
    self.passwordTextField.textColor = HooColor(80, 152, 200);
    [self.passwordTextField setValue:HooColor(80, 152, 200) forKeyPath:@"_placeholderLabel.textColor"];
    NSMutableAttributedString *title = [[NSMutableAttributedString alloc] initWithString:@"忘记密码"];
    [title addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:NSMakeRange(0, title.length)];
    [title addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:NSMakeRange(0, title.length)];
    [self.forgetButton setAttributedTitle:title forState:UIControlStateNormal];

}
- (void)back
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)forgetButtonClicked:(UIButton *)sender {
    HooForgetPasswordController *forgetCtrl = [[HooForgetPasswordController alloc] init];
    [self.navigationController pushViewController:forgetCtrl animated:YES];
}

#pragma mark - 登录按钮点击
- (IBAction)login:(UIButton *)sender {
    if([self.userNameTextField.text isEmpty]){
        [SVProgressHUD showErrorWithStatus:@"用户名不能为空"];
    }else if([self.passwordTextField.text isEmpty]){
        [SVProgressHUD showErrorWithStatus:@"密码不能为空"];
    }else{
        [BmobUser loginInbackgroundWithAccount:self.userNameTextField.text andPassword:self.passwordTextField.text block:^(BmobUser *user, NSError *error) {
            if (error) {
                [SVProgressHUD showErrorWithStatus:@"登录失败"];
            }else{
                [SVProgressHUD showSuccessWithStatus:@"登录成功"];
                [HooSaveTools setObject:self.userNameTextField.text forKey:HooUserName];
                [self dismissViewControllerAnimated:YES completion:nil];
            }
        }];
    }
}


#pragma mark - 注册按钮点击
- (IBAction)registerBtnClicked:(UIButton *)sender {
    //选择注册方式
    [self showPhotoSelectMenu];
    
}

//显示选择按钮
- (void)showPhotoSelectMenu
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
    [self presentViewController:alertCtrl animated:YES completion:nil];
}
#pragma mark -  微博登录
- (IBAction)weiboLogin:(UIButton *)sender {
    if ([WeiboSDK isWeiboAppInstalled]) {
        //向新浪发送请求
        WBAuthorizeRequest *request = [WBAuthorizeRequest request];
        request.redirectURI = @"https://api.weibo.com/oauth2/default.html";
        request.scope = @"all";
        [WeiboSDK sendRequest:request];
    }else{
        [SVProgressHUD showErrorWithStatus:@"没有安装微博客户端"];
    }
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
        _tencentOAuth = [[TencentOAuth alloc] initWithAppId:@"1104720526" andDelegate:self];
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
    if (_tencentOAuth.accessToken && 0 != [_tencentOAuth.accessToken length]){
        //  记录登录用户的OpenID、Token以及过期时间
        NSString *accessToken = _tencentOAuth.accessToken;
        NSString *uid = _tencentOAuth.openId;
        NSDate *expiresDate = _tencentOAuth.expirationDate;
        NSLog(@"acessToken:%@",accessToken);
        NSLog(@"UserId:%@",uid);
        NSLog(@"expiresDate:%@",expiresDate);
        NSDictionary *dic = @{@"access_token":accessToken,@"uid":uid,@"expirationDate":expiresDate};
        
        //通过授权信息注册登录
        [BmobUser loginInBackgroundWithAuthorDictionary:dic platform:BmobSNSPlatformQQ block:^(BmobUser *user, NSError *error) {
            if (error) {
                NSLog(@"weibo login error:%@",error);
            } else if (user){
                NSLog(@"user objectid is :%@",user.objectId);
                //跳转
                          }
        }];
    }
    
}
- (void)tencentDidNotLogin:(BOOL)cancelled{
}

- (void)tencentDidNotNetWork{
}

@end
