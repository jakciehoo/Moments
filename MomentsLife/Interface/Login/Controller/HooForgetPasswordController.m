//
//  HooForgetPasswordController.m
//  MomentsQuote(丁丁美文)
//
//  Created by HooJackie on 15/9/19.
//  Copyright (c) 2015年 jackieHoo. All rights reserved.
//
#import <BmobSDK/Bmob.h>
#import "HooForgetPasswordController.h"
#import "SVProgressHUD.h"
#import "NSString+Extension.h"

@interface HooForgetPasswordController (){
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
    // Do any additional setup after loading the view from its nib.
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


@end
