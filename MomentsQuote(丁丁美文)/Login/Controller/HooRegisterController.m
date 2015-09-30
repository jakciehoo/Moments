//
//  HooRegisterController.m
//  MomentsQuote(丁丁美文)
//
//  Created by HooJackie on 15/9/18.
//  Copyright (c) 2015年 jackieHoo. All rights reserved.
//

#import "HooRegisterController.h"
#import "NSString+Extension.h"
#import <BmobSDK/Bmob.h>
#import "SVProgressHUD.h"

@interface HooRegisterController ()
@property (weak, nonatomic) IBOutlet UITextField *userNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UITextField *verifyPasswordTextField;

@end

@implementation HooRegisterController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setupView];
}

- (void)setupView
{
    self.title = @"注册";
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
    UIView *leftView4 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 30, 50)];
    self.verifyPasswordTextField.leftViewMode = UITextFieldViewModeAlways;
    self.verifyPasswordTextField.leftView = leftView4;
    self.verifyPasswordTextField.textColor = HooColor(80, 152, 200);
    [self.verifyPasswordTextField setValue:HooColor(80, 152, 200) forKeyPath:@"_placeholderLabel.textColor"];
    
    UIView *leftView3 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 30, 50)];
    self.emailTextField.leftViewMode = UITextFieldViewModeAlways;
    self.emailTextField.leftView = leftView3;
    self.emailTextField.textColor = HooColor(80, 152, 200);
    [self.emailTextField setValue:HooColor(80, 152, 200) forKeyPath:@"_placeholderLabel.textColor"];
}
- (IBAction)register:(UIButton *)sender {
    if(self.userNameTextField.text.length < 3 || self.passwordTextField.text.length < 3){
        [SVProgressHUD showErrorWithStatus:@"用户名或密码长度不能小于3个字符"];
    }else if (![NSString validateEmail:self.emailTextField.text]){
        [SVProgressHUD showErrorWithStatus:@"邮箱格式不正确"];
    }else if (![self.passwordTextField.text isEqualToString:self.verifyPasswordTextField.text]){
        [SVProgressHUD showErrorWithStatus:@"两次输入的密码不同"];
    
    }else{
        BmobUser *user = [[BmobUser alloc] init];
        user.username = self.userNameTextField.text;
        user.password = self.passwordTextField.text;
        user.email = self.emailTextField.text;
        [user signUpInBackgroundWithBlock:^(BOOL isSuccessful, NSError *error) {
            if(isSuccessful){
                [SVProgressHUD showSuccessWithStatus:@"注册成功"];
            }else{
                NSString *errorStr = [error description];
                if([errorStr containsString:@"already taken"]){
                    [SVProgressHUD showSuccessWithStatus:@"邮箱已经被使用过了"];
                }else{
                    [SVProgressHUD showSuccessWithStatus:@"注册失败，请再试试"];
                }
                
            }
        }];
    }
}
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.userNameTextField resignFirstResponder];
    [self.passwordTextField resignFirstResponder];
    [self.emailTextField resignFirstResponder];
    [self.verifyPasswordTextField resignFirstResponder];
}

@end
