//
//  HooMoreViewController.m
//  MomentsQuote(丁丁美文)
//
//  Created by HooJackie on 15/8/3.
//  Copyright (c) 2015年 jackieHoo. All rights reserved.
//
#import <MessageUI/MessageUI.h>
#import "HooMoreViewController.h"
#import "HooSettingArrowItem.h"
#import "HooSettingGroup.h"
#import "HooSettingItem.h"
#import "HooSettingSwitchItem.h"
#import "HooSettingCell.h"
#import "HooReminderViewController.h"
#import "HooSaveTools.h"
#import "HooAuthorWeiboViewController.h"




@interface HooMoreViewController ()<HooReminderViewControllerDelegate,MFMessageComposeViewControllerDelegate,MFMailComposeViewControllerDelegate>

@property (nonatomic, strong) HooSettingArrowItem *reminder;

@property (nonatomic, weak) UITableViewCell *reminderCell;

@end

@implementation HooMoreViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"更多";
    
    //组1
    [self addGroup0];
    
    //组2
    [self addGroup1];
    
    //组3
    [self addGroup3];

    
}
- (void)addGroup0
{
    
    
    _reminder = [HooSettingArrowItem itemWithIcon:nil title:@"提醒我" destVcClass:[HooReminderViewController class]];
    NSString *dateStr = [HooSaveTools objectForKey:DatePicked];
    BOOL reminderState = [HooSaveTools boolForkey:SwitchState];
    if (reminderState) {
        if (dateStr.length > 0) {
            _reminder.subtitle = dateStr;
        }else{
            _reminder.subtitle = @"off";
        }
    }else{
        _reminder.subtitle = @"off";
    }

    

    
    HooSettingGroup *group0 = [[HooSettingGroup alloc] init];
    group0.items = @[_reminder];
    group0.header = @"设置";
    group0.footer = @"打开提醒，可以设置时间提醒你查看丁丁美图，建议起床时间提醒，一日之计在于晨嘛";
    [self.dataList addObject:group0];
    
}
- (void)addGroup1
{
    __weak typeof(self) weakSelf = self;
    HooSettingArrowItem *rate = [HooSettingArrowItem itemWithIcon:nil title:@"评分与评价" destVcClass:nil];
    rate.option = ^{
        
    };
    
    HooSettingArrowItem *about = [HooSettingArrowItem itemWithIcon:nil title:@"关于丁丁美文" destVcClass:nil];
    
    HooSettingArrowItem *feedback = [HooSettingArrowItem itemWithIcon:nil title:@"反馈与支持" destVcClass:nil];
    feedback.option = ^{
        // 不能发邮件
        if (![MFMailComposeViewController canSendMail]) return;
        
        MFMailComposeViewController *vc = [[MFMailComposeViewController alloc] init];
        
        // 设置邮件主题
        [vc setSubject:@"在这输入标题"];
        // 设置邮件内容
        [vc setMessageBody:@"在这输入内容" isHTML:NO];
        // 设置收件人列表
        [vc setToRecipients:@[@"niat05ethjh1112@163.com"]];
        
        // 添加附件（一张图片）
//        UIImage *image = [UIImage imageNamed:];
//        NSData *data = UIImagePNGRepresentation(image);
//        [vc addAttachmentData:data mimeType:@"image/png" fileName:@"阿狸头像.png"];
        // 设置代理
        vc.mailComposeDelegate = weakSelf;
        // 显示控制器
        [weakSelf presentViewController:vc animated:YES completion:nil];
    };
    
    HooSettingArrowItem *recomend = [HooSettingArrowItem itemWithIcon:nil title:@"推荐给朋友" destVcClass:nil];
    recomend.option = ^{

    };

    
    HooSettingGroup *group1 = [[HooSettingGroup alloc] init];
    group1.items = @[rate,about,feedback,recomend];
    group1.header = @"更多";
    
    [self.dataList addObject:group1];
}
- (void)addGroup3
{
    HooSettingArrowItem *author = [HooSettingArrowItem itemWithIcon:nil title:@"关注作者微博" destVcClass:[HooAuthorWeiboViewController class]];
    
    
    HooSettingGroup *group0 = [[HooSettingGroup alloc] init];
    group0.items = @[author];
    group0.header = @"关于作者";
    [self.dataList addObject:group0];
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:true];
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    HooSettingGroup *group = self.dataList[indexPath.section];
    HooSettingItem *item = group.items[indexPath.row];
    
    if (item.option) {
        item.option();
        return;
    }
    if ([item isKindOfClass:[HooSettingArrowItem class]]) {
        HooSettingArrowItem *arrowItem = (HooSettingArrowItem *)item;
        if (arrowItem.destVcClass) {
            UITableViewController *vc = [[arrowItem.destVcClass alloc] init];
            if (arrowItem == _reminder) {
                HooReminderViewController *reminder = (HooReminderViewController *)vc;
                self.reminderCell = cell;
                reminder.delegate = self;
            }
            vc.title = item.title;
            [self.navigationController pushViewController:vc animated:true];
            

        }
    }
    
}
#pragma mark - HooReminderViewControllerDelegate代理
- (void)datePick:(UIDatePicker *)picker pickeDate:(NSString *)date
{
    
    _reminder.subtitle = date;
    if (self.reminderCell) {
        
        self.reminderCell.detailTextLabel.text = date;
    }
    
}

#pragma MFMessageComposeViewControllerDelegate 实现信息发送完成返回原应用
- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result
{
    // 关闭短信界面
    [controller dismissViewControllerAnimated:YES completion:nil];
    
    if (result == MessageComposeResultCancelled) {
        HooLog(@"取消发送");
    } else if (result == MessageComposeResultSent) {
        HooLog(@"已经发出");
    } else {
        HooLog(@"发送失败");
    }
}
#pragma MFMailComposeViewControllerDelegate 实现完成邮件发送返回原应用
- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    // 关闭邮件界面
    [controller dismissViewControllerAnimated:YES completion:nil];
    
    if (result == MFMailComposeResultCancelled) {
        HooLog(@"取消发送");
    } else if (result == MFMailComposeResultSent) {
        HooLog(@"已经发出");
    } else {
        HooLog(@"发送失败");
    }
}


@end
