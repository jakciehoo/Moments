//
//  HooPhoneRegisterController.m
//  MomentsLife
//
//  Created by HooJackie on 15/9/19.
//  Copyright (c) 2015年 jackieHoo. All rights reserved.
//
#import <BmobSDK/Bmob.h>
#import "HooPhoneRegisterController.h"
#import "HooUserManager.h"
#import "NSString+Extension.h"
#import "SVProgressHUD.h"
#import "HooSaveTools.h"

@interface HooPhoneRegisterController (){
    NSTimer *_countDownTimer;
    unsigned _secondsCountDown;
}
@property (weak, nonatomic) IBOutlet UITextField *phoneTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UITextField *verifyCodeTextField;
@property (weak, nonatomic) IBOutlet UIButton *verifyCodeButton;
@property (weak, nonatomic) IBOutlet UIButton *registerButton;

@end

@implementation HooPhoneRegisterController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupView];
}

- (void)setupView
{
    self.title = @"手机注册";
    
    UIView *leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 30, 50)];
    self.phoneTextField.leftViewMode = UITextFieldViewModeAlways;
    self.phoneTextField.leftView = leftView;
    self.phoneTextField.textColor = HooColor(80, 152, 200);
    [self.phoneTextField setValue:HooColor(80, 152, 200) forKeyPath:@"_placeholderLabel.textColor"];
    
    UIView *leftView2 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 30, 50)];
    self.passwordTextField.leftViewMode = UITextFieldViewModeAlways;
    self.passwordTextField.leftView = leftView2;
    self.passwordTextField.textColor = HooColor(80, 152, 200);
    [self.passwordTextField setValue:HooColor(80, 152, 200) forKeyPath:@"_placeholderLabel.textColor"];

    self.verifyCodeTextField.textColor = HooColor(80, 152, 200);
    [self.verifyCodeTextField setValue:HooColor(80, 152, 200) forKeyPath:@"_placeholderLabel.textColor"];

    
}
- (void)closeController
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)verifyCodeBtnClicked:(UIButton *)sender {
    
    //获取手机号
    NSString *mobilePhoneNumber = self.phoneTextField.text;
    if (mobilePhoneNumber.length > 0) {
        if (![mobilePhoneNumber isValidateMobileNumber]) {
            [SVProgressHUD showErrorWithStatus:@"手机号码输入格式不正确，请检查"];
            return;
        }
        //请求验证码
        __weak typeof(self) weakSelf = self;
        [[HooUserManager manager] requestSMSCodeInBackgroundWithPhoneNumber:mobilePhoneNumber block:^(int number, NSError *error) {
            __strong __typeof(weakSelf)strongSelf = weakSelf;
            if (error) {
                NSLog(@"%@",error);
                UIAlertView *tip = [[UIAlertView alloc] initWithTitle:nil message:@"请输入正确的手机号码" delegate:strongSelf cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [tip show];
            } else {
                [SVProgressHUD showSuccessWithStatus:@"正在发送验证码到您的手机"];
                //获得smsID
                HooLog(@"sms ID：%d",number);
                //设置不可点击时间
                [strongSelf setRequestSmsCodeBtnCountDown];
            }

        }];
        
    }else{
        [SVProgressHUD showErrorWithStatus:@"请输入正确的手机号码"];
    }
    

    
}
-(void)setRequestSmsCodeBtnCountDown{
    [self.verifyCodeButton setEnabled:NO];
    self.verifyCodeButton.backgroundColor = [UIColor grayColor];
    _secondsCountDown = 60;
    
    _countDownTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(countDownTimeWithSeconds:) userInfo:nil repeats:YES];
    [_countDownTimer fire];
}

-(void)countDownTimeWithSeconds:(NSTimer*)timerInfo{
    if (_secondsCountDown == 0) {
        [self.verifyCodeButton setEnabled:YES];
        self.verifyCodeButton.backgroundColor = HooColor(80, 152, 200);
        [self.verifyCodeButton setTitle:@"获取验证码" forState:UIControlStateNormal];
        [_countDownTimer invalidate];
    } else {
        [self.verifyCodeButton setTitle:[[NSNumber numberWithInt:_secondsCountDown] description] forState:UIControlStateNormal];
        _secondsCountDown--;
    }
}


- (IBAction)registerBtnClicked:(UIButton *)sender {
    //获取手机号、验证码
    NSString *mobilePhoneNumber = self.phoneTextField.text;
    NSString *smsCode = self.verifyCodeTextField.text;
    NSString *password = self.passwordTextField.text;
    if ([mobilePhoneNumber isPhoneNumber] && smsCode.length > 0) {
        
        [self.phoneTextField resignFirstResponder];
        [self.verifyCodeTextField resignFirstResponder];
        
        //该方法可以进行注册和登录两步操作，如果已经注册过了就直接进行登录
        [[HooUserManager manager] registerWithPhoneNumber:mobilePhoneNumber andSMSCode:smsCode andPassword:password block:^(BmobUser *user, NSError *error) {
            if (user) {
                //跳转
                [self.navigationController popToRootViewControllerAnimated:YES];

                
            } else {
                HooLog(@"%@",error);
                [SVProgressHUD showErrorWithStatus:@"注册失败！请再试试"];
                
            }
        }];
        
        

    }else{
        [SVProgressHUD showErrorWithStatus:@"输入有误，请检查"];
    }
}

- (void)dealloc
{
    HooLog(@"HooPhoneRegisterController");
}


@end
