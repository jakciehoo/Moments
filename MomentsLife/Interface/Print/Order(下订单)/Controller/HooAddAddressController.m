//
//  HooAddAddressController.m
//  MomentsLife
//
//  Created by HooJackie on 15/10/3.
//  Copyright (c) 2015年 jackieHoo. All rights reserved.
//

#import "HooAddAddressController.h"
#import "HooTextView.h"
#import "HooAddressPickView.h"
#import "TOTextInputChecker.h"
#import "UITextFieldPadding.h"
#import "NSString+Extension.h"
#import "SVProgressHUD.h"
#import "OrderAddress.h"
#import "HooOrderAddressManager.h"

@interface HooAddAddressController ()<HooAddressPickViewDelegate,UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UITextFieldPadding *nameTextField;

@property (weak, nonatomic) IBOutlet UITextFieldPadding *phoneTexeField;

@property (weak, nonatomic) IBOutlet UITextFieldPadding *postalTextField;

@property (weak, nonatomic) IBOutlet UIButton *contryButton;

@property (weak, nonatomic) IBOutlet HooTextView *addressDetailTextView;

@property (weak, nonatomic) HooAddressPickView *locatePicker;

@property (strong, nonatomic) TOTextInputChecker *phoneNumberChecker;

@property (strong, nonatomic) TOTextInputChecker *nameChecker;

@property (strong, nonatomic) TOTextInputChecker *zipCodeChecker;


@end

@implementation HooAddAddressController
- (OrderAddress *)address
{
    if (_address == nil) {
        _address = [[OrderAddress alloc] init];
    }
    return _address;
}

- (TOTextInputChecker *)phoneNumberChecker
{
    if (_phoneNumberChecker == nil) {
        TOTextInputChecker *phoneNumberChecker = [TOTextInputChecker telChecker:YES];
        phoneNumberChecker.backgroundNomarl = @"input_bg_nomarl_out.png";
        phoneNumberChecker.backgroundHighlighted = @"input_bg_nomarl_on.png";
        phoneNumberChecker.backgroundError = @"input_bg_error_out.png";
        phoneNumberChecker.backgroundErrorHighlighted = @"input_bg_error_on.png";
        _phoneNumberChecker = phoneNumberChecker;
    }
    return _phoneNumberChecker;
}
- (TOTextInputChecker *)nameChecker
{
    if (_nameChecker == nil) {
        TOTextInputChecker *nameChecker = [[TOTextInputChecker alloc] init];
        nameChecker.characters = nil;
        nameChecker.minLen = 1;
        nameChecker.maxLen = 10;
        nameChecker.regex = @"[a-zA-Z\u4e00-\u9fa5][a-zA-Z0-9\u4e00-\u9fa5]+";
        
        nameChecker.backgroundNomarl = @"input_bg_nomarl_out.png";
        nameChecker.backgroundHighlighted = @"input_bg_nomarl_on.png";
        nameChecker.backgroundError = @"input_bg_error_out.png";
        nameChecker.backgroundErrorHighlighted = @"input_bg_error_on.png";
        _nameChecker = nameChecker;
    }
    return _nameChecker;
}
- (TOTextInputChecker *)zipCodeChecker
{
    if (_zipCodeChecker == nil) {
        TOTextInputChecker *zipCodeChecker = [TOTextInputChecker zipCodeChecker:YES];
        zipCodeChecker.backgroundNomarl = @"input_bg_nomarl_out.png";
        zipCodeChecker.backgroundHighlighted = @"input_bg_nomarl_on.png";
        zipCodeChecker.backgroundError = @"input_bg_error_out.png";
        zipCodeChecker.backgroundErrorHighlighted = @"input_bg_error_on.png";
        _zipCodeChecker = zipCodeChecker;
    }
    return _zipCodeChecker;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setupView];
    
}

- (void)setupView
{
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(saveAddress)];
    

    [self.contryButton setTitle:@"点击选择城市信息" forState:UIControlStateNormal];
    self.contryButton.backgroundColor = HooColor(234, 81, 96);
    [self.contryButton setTintColor:[UIColor whiteColor]];

    self.addressDetailTextView.placeholder = @"请输入详细地址";
    self.addressDetailTextView.layer.cornerRadius = 5;
    //电话号码验证
    self.phoneTexeField.delegate = self.phoneNumberChecker;

    [self.phoneTexeField setPadding:YES top:0 right:8 bottom:0 left:8];
    //用户名验证
    self.nameTextField.delegate = self.nameChecker;

    [self.nameTextField setPadding:YES top:0 right:8 bottom:0 left:8];
    //邮编验证
    self.postalTextField.delegate = self.zipCodeChecker;

    [self.postalTextField setPadding:YES top:0 right:8 bottom:0 left:8];
    
    
    self.addressDetailTextView.delegate = self;
    if (self.isEdittingAddress) {
        self.title = @"修改地址";
    }else{
        self.title = @"新增地址";
    }
    if (self.isEdittingAddress) {
        
        self.nameTextField.text = self.address.name;
        self.phoneTexeField.text = self.address.phone_number;
        self.postalTextField.text = self.address.zipCode;
        NSString *country = self.address.country_address;
        [self.contryButton setTitle:country forState:UIControlStateNormal];
        self.addressDetailTextView.text = self.address.detail_address;
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hideKeyBoard) name:UIKeyboardWillHideNotification object:nil];

    
}
//保存或更新地址
- (void)saveAddress
{
    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
    if (self.nameTextField.text.length < 2 || ![self.phoneTexeField.text isValidateMobileNumber] || self.postalTextField.text.length < 5 || self.addressDetailTextView.text.length == 0) {
        
        
        [SVProgressHUD showErrorWithStatus:@"您的输入可能不符合要求，请检查确认后再保存"];
        return;
    }
    
    self.address.name = self.nameTextField.text;
    self.address.phone_number = self.phoneTexeField.text;
    self.address.zipCode = self.postalTextField.text;
    self.address.country_address = self.contryButton.titleLabel.text;
    self.address.detail_address = self.addressDetailTextView.text;
    
    
    if (self.isEdittingAddress) {
        [[HooOrderAddressManager manager] updateAddressWith:self.address WithBlock:^(BOOL isSuccessful, NSError *error) {
            if (error) {
                HooLog(@"%@",error);
            }
            if (isSuccessful) {
               [SVProgressHUD showSuccessWithStatus:@"修改地址成功"];
                [self.navigationController popViewControllerAnimated:YES];
            }
        }];
        
    }else{
        self.address.is_default = @(NO);
        if (self.isFromOrder) {
            self.address.is_default = @(YES);
        }
        [[HooOrderAddressManager manager] newAddressWith:self.address WithBlock:^(BOOL isSuccessful, NSError *error) {
            if (isSuccessful) {
                [SVProgressHUD showSuccessWithStatus:@"新增地址成功"];
                [self.navigationController popViewControllerAnimated:YES];
            }
            if (error) {
                [SVProgressHUD showSuccessWithStatus:@"新增地址失败"];
                HooLog(@"%@",error);
            }
        }];

    }
    
    
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    
    [self cancelLocatePicker];
    [self backgroundTap];
    
}

- (IBAction)contryButtonClicked:(UIButton *)sender {
    [self.view endEditing:YES];
    [self cancelLocatePicker];
    HooAddressPickView *locatePicker = [[HooAddressPickView alloc] addressPickViewtWithStyle:HooAddressPickerWithStateAndCityAndDistrict delegate:self];;

    [locatePicker showInView:self.view];
    self.locatePicker = locatePicker;

}
#pragma mark - HooAddressPickViewDelegate
-(void)pickerDidChangeStatus:(HooAddressPickView *)picker
{
    if (picker.pickerStyle == HooAddressPickerWithStateAndCityAndDistrict) {
        NSString *contryTitle = [NSString stringWithFormat:@"%@ %@ %@", picker.locate.state, picker.locate.city, picker.locate.district];
        [self.contryButton setTitle:contryTitle forState:UIControlStateNormal];
    }
}

-(void)cancelLocatePicker
{
    [self.locatePicker cancelPicker];
    self.locatePicker.delegate = nil;
    self.locatePicker = nil;
}
#pragma mark 解决虚拟键盘挡住UITextField的方法


- (void)textViewDidBeginEditing:(UITextField *)textView
{
    CGRect frame = textView.frame;
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
-(void)backgroundTap
{
    [self.nameTextField resignFirstResponder];
    [self.addressDetailTextView resignFirstResponder];
    [self.phoneTexeField resignFirstResponder];
    [self.postalTextField resignFirstResponder];
}

- (void)hideKeyBoard
{
    // When the user presses return, take focus away from the text field so that the keyboard is dismissed.
    NSTimeInterval animationDuration = 0.30f;
    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
    [UIView setAnimationDuration:animationDuration];
    CGRect rect = CGRectMake(0.0f, 20.0f, self.view.frame.size.width, self.view.frame.size.height);
    self.view.frame = rect;
    [UIView commitAnimations];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


@end
