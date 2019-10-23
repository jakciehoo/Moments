//
//  HooProductPickView.m
//  MomentsLife
//
//  Created by HooJackie on 15/10/14.
//  Copyright (c) 2015年 jackieHoo. All rights reserved.
//

#import "HooProductPickView.h"
#import "SVProgressHUD.h"
#import "HooProduct.h"
#import "HooProductCategory.h"
#import "MJExtension.h"

#define kDuration 0.3

@interface HooProductPickView ()<UIPickerViewDelegate, UIPickerViewDataSource>{
    NSArray *_categories, *_products;
}
@property (weak, nonatomic) IBOutlet UIPickerView *productPicker;

@property (weak, nonatomic) IBOutlet UILabel *productNameLabel;

@property (nonatomic, strong)HooProduct *product;

@end

@implementation HooProductPickView



- (instancetype)init
{
    self = [[[NSBundle mainBundle] loadNibNamed:@"HooProductPickView" owner:self options:nil] objectAtIndex:0];
    if (self) {
        self.productPicker.dataSource = self;
        self.productPicker.delegate = self;
        
        //加载数据
        NSString *plistPath = [HooDocumentDirectory stringByAppendingPathComponent:@"product.plist"];
        if (![[NSFileManager defaultManager] fileExistsAtPath:plistPath]) {
            [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
            [SVProgressHUD showInfoWithStatus:@"正在加载产品数据,请稍等"];
        }else{
            _categories = [HooProductCategory objectArrayWithFile:plistPath];
        }
    }
    return self;
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 2;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    switch (component) {
        case 0:
            return [_categories count];
            break;
        case 1:
            return [_products count];
            break;
        default:
            return 0;
            break;
    }
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if (component == 0) {
        HooProductCategory *category = _categories[row];
        return category.category_name;
    }if (component == 1) {
        HooProduct *product = _products[row];
        return product.product_name;
    }
    return @"";
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (component == 0) {
        if (_categories.count) {
            
            HooProductCategory *category = _categories[row];
                
            _products = category.products;

            [self.productPicker selectRow:0 inComponent:1 animated:YES];
            [self.productPicker reloadComponent:1];
        }
    }if (component == 1) {
        self.product = _products[row];
        if (self.product.product_name) {
            
            self.productNameLabel.text = [NSString stringWithFormat:@"您选择了产品：%@",self.product.product_name];
        }
    }
    
}


- (void)showInView:(UIView *) view
{
    [self.productPicker selectRow:0 inComponent:0 animated:YES];
    [self.productPicker reloadComponent:0];
    self.frame = CGRectMake(0, view.frame.size.height, self.frame.size.width, self.frame.size.height);
    [view addSubview:self];
    
    [UIView animateWithDuration:0.3 animations:^{
        self.frame = CGRectMake(0, view.frame.size.height - self.frame.size.height, self.frame.size.width, self.frame.size.height);
    }];
    
}

- (void)cancelPicker
{
    
    [UIView animateWithDuration:0.3
                     animations:^{
                         self.frame = CGRectMake(0, self.frame.origin.y+self.frame.size.height, self.frame.size.width, self.frame.size.height);
                     }
                     completion:^(BOOL finished){
                         [self removeFromSuperview];
                         
                     }];
    
}


- (IBAction)confirmButtonClicked:(UIButton *)sender {
    if (self.product == nil) {
        [SVProgressHUD showInfoWithStatus:@"请选择一款产品"];
        return;
    }
    
    if([self.delegate respondsToSelector:@selector(pickerDidSelectProduct:)]){
        [self.delegate pickerDidSelectProduct:self.product];
    }
    [self cancelPicker];
}


@end
