//
//  HooPayPopView.m
//  MomentsLife
//
//  Created by HooJackie on 15/10/8.
//  Copyright (c) 2015年 jackieHoo. All rights reserved.
//

#import "HooPayPopView.h"

@interface HooPayPopView ()<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate>

@property (weak, nonatomic) IBOutlet UIView *payView;

@property (weak, nonatomic) IBOutlet UITableView *payTableView;

@property (weak, nonatomic) IBOutlet UIButton *payButton;

@property (strong, nonatomic)NSIndexPath *lastIndexPath;

@end

@implementation HooPayPopView

+ (instancetype)payPopView
{
    return [[NSBundle mainBundle] loadNibNamed:@"HooPayPopView" owner:nil options:nil].firstObject;
}


- (void)awakeFromNib
{
    self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.2];
    self.payView.layer.cornerRadius = 5;
    self.payTableView.delegate = self;
    self.payTableView.dataSource = self;

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.payArray.count;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellID = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellID];
    if (cell == nil) {
          cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellID];
    }
    NSDictionary *payDict = self.payArray[indexPath.row];
    cell.imageView.image = payDict[@"image"];
    cell.textLabel.text = payDict[@"name"];
    cell.detailTextLabel.text = payDict[@"description"];
    
    UIButton *accessoryButton = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *buttonSelectedImage = [UIImage imageNamed:@"pay_mode_selected"];
    UIImage *buttonNormalImage = [UIImage imageNamed:@"pay_mode_normal"];
    [accessoryButton setImage:buttonSelectedImage forState:UIControlStateSelected];
    [accessoryButton setImage:buttonNormalImage forState:UIControlStateNormal];
    accessoryButton.frame = CGRectMake(0, 0, buttonSelectedImage.size.width, buttonSelectedImage.size.height);
    cell.accessoryView = accessoryButton;
    if (indexPath.row == 0) {
        accessoryButton.selected = YES;
        self.lastIndexPath = indexPath;
    }

    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger newRow = [indexPath row];
    NSInteger oldRow = [self.lastIndexPath row];
    
    if (newRow != oldRow)
    {
        UITableViewCell *newCell = [tableView cellForRowAtIndexPath:
                                    indexPath];
        UIButton *newAccessoryButton = (UIButton *)newCell.accessoryView;
        newAccessoryButton.selected = YES;
        
        UITableViewCell *oldCell = [tableView cellForRowAtIndexPath:
                                    self.lastIndexPath];
        UIButton *oldAccessoryButton = (UIButton *)oldCell.accessoryView;
        oldAccessoryButton.selected = NO;
        
        self.lastIndexPath = indexPath;
    }
    UITableViewCell *selectedCell = [tableView cellForRowAtIndexPath:indexPath];
    UIButton *accessoryButton = (UIButton *)selectedCell.accessoryView;
    accessoryButton.selected = YES;
    if (indexPath.row == 0) {
        _payType = PayTypeAliPay;
    }
    if (indexPath.row == 1) {
        _payType = PayTypeWeChat;
    }
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *deSelectedCell = [tableView cellForRowAtIndexPath:indexPath];
    UIButton *accessoryButton = (UIButton *)deSelectedCell.accessoryView;
    accessoryButton.selected = NO;

}

- (IBAction)canelBtnClicked:(UIButton *)sender {
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"你确定要取消付款吗？" delegate:self cancelButtonTitle:@"否" otherButtonTitles:@"是", nil];
    [alertView show];
}
- (IBAction)payBtnClicked:(id)sender {
    
    if ([self.delegate respondsToSelector:@selector(payWithPayType:)]) {
        [self.delegate payWithPayType:self.payType];
    }
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        [self removeFromSuperview];
    }
}

@end
