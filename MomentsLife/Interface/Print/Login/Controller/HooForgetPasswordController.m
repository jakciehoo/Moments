//
//  HooForgetPasswordController.m
//  MomentsLife
//
//  Created by HooJackie on 15/9/19.
//  Copyright (c) 2015年 jackieHoo. All rights reserved.
//
#import <BmobSDK/Bmob.h>
#import "HooForgetPasswordController.h"
#import "SVProgressHUD.h"
#import "NSString+Extension.h"

@interface HooForgetPasswordController ()<UITextFieldDelegate>{
    NSTimer *_countDownTimer;
    unsigned _secondsCountDown;
}
@property (weak, nonatomic) IBOutlet UITextField *phoneNumberTextField;
@property (weak, nonatomic) IBOutlet UITextField *verifyCodeTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;

@property (weak, nonatomic) IBOutlet UITextField *verifyPasswordTextField;
@property (weak, nonatomic) IBOutlet UIButton *verifyCodeButton;
@property (weak, nonatomic) IBOutlet UIButton *findConfirmButton;
@property (weak, nonatomic) IBOutlet UIButton *passwordButton;

@end

@implementation HooForgetPasswordController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [self setupView];
    
}

- (void)setupView
{
    self.title = @"注册";
    
    UIView *leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 30, 50)];
    self.phoneNumberTextField.leftViewMode = UITextFieldViewModeAlways;
    self.phoneNumberTextField.textColor = HooColor(80, 152, 200);
    [self.phoneNumberTextField setValue:HooColor(80, 152, 200) forKeyPath:@"_placeholderLabel.textColor"];
    self.phoneNumberTextField.leftView = leftView;
    
    UIView *leftView2 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 30, 50)];
    self.passwordTextField.leftViewMode = UITextFieldViewModeAlways;
    self.passwordTextField.leftView = leftView2;
    self.passwordTextField.textColor = HooColor(80, 152, 200);
    [self.passwordTextField setValue:HooColor(80, 152, 200) forKeyPath:@"_placeholderLabel.textColor"];
    self.passwordTextField.delegate = self;
    UIView *leftView4 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 30, 50)];
    self.verifyPasswordTextField.leftViewMode = UITextFieldViewModeAlways;
    self.verifyPasswordTextField.leftView = leftView4;
    self.verifyPasswordTextField.textColor = HooColor(80, 152, 200);
    [self.verifyPasswordTextField setValue:HooColor(80, 152, 200) forKeyPath:@"_placeholderLabel.textColor"];
    self.verifyPasswordTextField.delegate = self;
    
}

- (void)closeController
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)verifyCodeBtnClicked:(UIButton *)sender {
    
    //获取手机号
    NSString *mobilePhoneNumber = self.phoneNumberTextField.text;
    if (mobilePhoneNumber.length > 0) {
        if (![mobilePhoneNumber isPhoneNumber]) {
            [SVProgressHUD showErrorWithStatus:@"手机号码输入格式不正确，请检查"];
            return;
        }
        
        //请求验证码
        __weak typeof(self) weakSelf = self;
        [BmobSMS requestSMSCodeInBackgroundWithPhoneNumber:mobilePhoneNumber andTemplate:@"电话号码" resultBlock:^(int number, NSError *error) {
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

- (IBAction)findConfirmButtonClicked:(UIButton *)sender {
    
}
- (IBAction)passwordButtonClicked:(UIButton *)sender {
    

//    NSDictionary *dic = @{@"phone":self.phoneNumberTextField.text,@"password":self.passwordTextField.text};
//    //test对应你刚刚创建的云端代码名称
//    [BmobCloud callFunctionInBackground:@"test" withParameters:dic block:^(id object, NSError *error) {
//        
//        if (!error) {
//            //执行成功时调用
//            NSLog(@"error %@",[object description]);
//        }else{
//            //执行失败时调用
//            NSLog(@"error %@",[error description]);
//        }
//        
//    }] ;
    
}
#pragma mark 解决虚拟键盘挡住UITextField的方法

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    CGRect frame = textField.frame;
    int offset = frame.origin.y + 120 - (self.view.frame.size.height - 216.0);//键盘高度216
    NSTimeInterval animationDuration = 0.30f;
    [UIView beginAnimations:@"ResizeForKeyBoard" context:nil];
    [UIView setAnimationDuration:animationDuration];
    float width = self.view.frame.size.width;
    float height = self.view.frame.size.height;
    if(offset > 0)
    {
        CGRect rect = CGRectMake(0.0f, -offset,width,height);
        self.view.frame = rect;
    }
    [UIView commitAnimations];
}
#pragma mark 触摸背景来关闭虚拟键盘


- (void)closeKeyboard:(id)sender
{
    // When the user presses return, take focus away from the text field so that the keyboard is dismissed.
    NSTimeInterval animationDuration = 0.30f;
    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
    [UIView setAnimationDuration:animationDuration];
    CGRect rect = CGRectMake(0.0f, 20.0f, self.view.frame.size.width, self.view.frame.size.height);
    self.view.frame = rect;
    [UIView commitAnimations];
    
    [self.view endEditing:YES];
}
- (void)dealloc
{
    HooLog(@"HooForgetPasswordController");
}


@end
