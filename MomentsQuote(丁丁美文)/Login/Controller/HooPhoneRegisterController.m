//
//  HooPhoneRegisterController.m
//  MomentsQuote(丁丁美文)
//
//  Created by HooJackie on 15/9/19.
//  Copyright (c) 2015年 jackieHoo. All rights reserved.
//
#import <BmobSDK/Bmob.h>
#import "HooPhoneRegisterController.h"
#import "NSString+Extension.h"
#import "SVProgressHUD.h"

@interface HooPhoneRegisterController (){
    NSTimer *_countDownTimer;
    unsigned _secondsCountDown;
}
@property (weak, nonatomic) IBOutlet UITextField *phoneTextField;
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
//    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"corner_back_flat"] style:UIBarButtonItemStyleDone target:self action:@selector(back)];
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"login_bg"]];
    
    UIView *leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 30, 50)];
    self.phoneTextField.leftViewMode = UITextFieldViewModeAlways;
    self.phoneTextField.leftView = leftView;
    self.phoneTextField.textColor = HooColor(80, 152, 200);
    [self.phoneTextField setValue:HooColor(80, 152, 200) forKeyPath:@"_placeholderLabel.textColor"];
    
    

    self.verifyCodeTextField.textColor = HooColor(80, 152, 200);
    [self.verifyCodeTextField setValue:HooColor(80, 152, 200) forKeyPath:@"_placeholderLabel.textColor"];

    
}
- (IBAction)verifyCodeBtnClicked:(UIButton *)sender {
    
    //获取手机号
    NSString *mobilePhoneNumber = self.phoneTextField.text;
    if (mobilePhoneNumber.length > 0) {
        if (![mobilePhoneNumber isPhoneNumber]) {
            [SVProgressHUD showErrorWithStatus:@"手机号码输入格式不正确，请检查"];
            return;
        }
        
        //请求验证码
        [BmobSMS requestSMSCodeInBackgroundWithPhoneNumber:mobilePhoneNumber andTemplate:@"电话号码" resultBlock:^(int number, NSError *error) {
            if (error) {
                NSLog(@"%@",error);
                UIAlertView *tip = [[UIAlertView alloc] initWithTitle:nil message:@"请输入正确的手机号码" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [tip show];
            } else {
                [SVProgressHUD showSuccessWithStatus:@"正在发送验证码到您的手机"];
                //获得smsID
                HooLog(@"sms ID：%d",number);
                //设置不可点击时间
                [self setRequestSmsCodeBtnCountDown];
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
    if (mobilePhoneNumber.length > 0 && smsCode.length > 0) {
        
        [self.phoneTextField resignFirstResponder];
        [self.verifyCodeTextField resignFirstResponder];
        
        //该方法可以进行注册和登录两步操作，如果已经注册过了就直接进行登录
        [BmobUser signOrLoginInbackgroundWithMobilePhoneNumber:mobilePhoneNumber andSMSCode:smsCode block:^(BmobUser *user, NSError *error) {
            if (user) {
                //跳转
#warning 跳转代码
                UIAlertView *bindAlert = [[UIAlertView alloc] initWithTitle:nil message:@"验证成功，现在您可以绑定你的手机号了" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"绑定", nil];
                bindAlert.alertViewStyle = UIAlertViewStylePlainTextInput;

                [bindAlert show];
                
                
            } else {
                NSLog(@"%@",error);
                UIAlertView *tip = [[UIAlertView alloc] initWithTitle:nil message:@"验证码有误" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [tip show];
            }
        }];
    }else{
        [SVProgressHUD showErrorWithStatus:@"请完善信息"];
    }
}



@end
