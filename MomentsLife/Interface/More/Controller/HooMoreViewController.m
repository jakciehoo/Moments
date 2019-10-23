//
//  HooMoreViewController.m
//  MomentsLife
//
//  Created by HooJackie on 15/8/3.
//  Copyright (c) 2015年 jackieHoo. All rights reserved.
//
#import <MessageUI/MessageUI.h>
#import "HooMoreViewController.h"
#import "HooReminderViewController.h"
#import "HooAuthorWeiboViewController.h"
#import "HooAboutAppController.h"
#import "HooSettingArrowItem.h"
#import "HooSettingGroup.h"
#import "HooShareTool.h"
#import "HooSaveTools.h"
#import "SDImageCache.h"
#import "SVProgressHUD.h"
#import "HooVersionTool.h"




@interface HooMoreViewController ()<MFMessageComposeViewControllerDelegate,MFMailComposeViewControllerDelegate,UIAlertViewDelegate>

@property (nonatomic, strong) HooSettingArrowItem *reminder;
@property (nonatomic, strong) HooSettingArrowItem *clearDiskItem;


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
- (void)viewWillAppear:(BOOL)animated
{
    NSUInteger byteSize = [SDImageCache sharedImageCache].getSize;
    double size = byteSize / 1000.0 / 1000.0;
    self.clearDiskItem.subtitle = [NSString stringWithFormat:@"缓存大小(%.1fM)", size];
    
    [super viewWillAppear:animated];
    NSString *dateStr = [HooSaveTools objectForKey:DatePicked];
    BOOL reminderState = [HooSaveTools boolForkey:SwitchState];
    if (reminderState) {
        if (dateStr.length > 0) {
            _reminder.subtitle = dateStr;
        }else{
            _reminder.subtitle = @"关闭";
        }
    }else{
        _reminder.subtitle = @"关闭";
    }
    //刷新第一行
    NSIndexPath *indexPath0 = [NSIndexPath indexPathForRow:0 inSection:0];
    NSIndexPath *indexPath1 = [NSIndexPath indexPathForRow:1 inSection:0];
    [self.tableView reloadRowsAtIndexPaths:@[indexPath0,indexPath1] withRowAnimation:UITableViewRowAnimationFade];
}

- (void)addGroup0
{
    _reminder = [HooSettingArrowItem itemWithIcon:nil title:@"提醒我" destVcClass:[HooReminderViewController class]];
     _clearDiskItem = [HooSettingArrowItem itemWithIcon:nil title:@"清除缓存" destVcClass:nil];
   
    __weak HooSettingArrowItem *clearDisk = self.clearDiskItem;
    __weak typeof(self) weakSelf = self;
    self.clearDiskItem.option = ^{
        __strong typeof(self) strongSelf = weakSelf;
        [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
        [[SDImageCache sharedImageCache] clearDisk];
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        NSUInteger byteSize = [SDImageCache sharedImageCache].getSize;
        double size = byteSize / 1000.0 / 1000.0;
        clearDisk.subtitle = [NSString stringWithFormat:@"缓存大小(%.1fM)", size];
        NSIndexPath *indexPath0 = [NSIndexPath indexPathForRow:0 inSection:0];
        [strongSelf.tableView reloadRowsAtIndexPaths:@[indexPath0] withRowAnimation:UITableViewRowAnimationFade];

    };
    
    HooSettingGroup *group0 = [[HooSettingGroup alloc] init];
    group0.items = @[_clearDiskItem,_reminder];
    group0.header = @"设置";
    group0.footer = @"可以设置提醒你查看丁丁的时间";
    [self.dataList addObject:group0];
    
}


- (void)addGroup1
{
    __weak typeof(self) weakSelf = self;
    HooSettingArrowItem *rate = [HooSettingArrowItem itemWithIcon:nil title:@"评分与评价" destVcClass:nil];
    rate.option = ^{
        NSString *urlToOpen = @"itms-apps://itunes.apple.com/cn/app/id1049879738?mt=8";
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlToOpen]];
    };
    HooSettingArrowItem *about = [HooSettingArrowItem itemWithIcon:nil title:@"关于《丁丁印记》App" destVcClass:[HooAboutAppController class]];
    
    HooSettingArrowItem *feedback = [HooSettingArrowItem itemWithIcon:nil title:@"反馈与支持" destVcClass:nil];
    feedback.option = ^{
        __strong __typeof(weakSelf)strongSelf = weakSelf;
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
        vc.mailComposeDelegate = strongSelf;
        // 显示控制器
        [strongSelf presentViewController:vc animated:YES completion:nil];
    };
    
    HooSettingArrowItem *recomend = [HooSettingArrowItem itemWithIcon:nil title:@"推荐给朋友" destVcClass:nil];
    recomend.option = ^{
        //分享
        UITableViewCell *recomendCell = [weakSelf.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:3 inSection:1]];
        [HooShareTool showshareAlertControllerIn:recomendCell WithImage:[UIImage imageNamed:@"App_intro"] andFileName:@"MomentLife.png"];
    };
    
//    HooSettingArrowItem *version = [HooSettingArrowItem itemWithIcon:nil title:@"当前App版本" destVcClass:nil];
//    NSDictionary *appInfo = [[NSBundle mainBundle] infoDictionary];
//    NSString *currentVersion = [appInfo objectForKey:@"CFBundleVersion"];
//    version.subtitle = currentVersion;
//    checkNewViersion.option = ^{
//        [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
//        [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
//        [SVProgressHUD showWithStatus:@"正在检查新版本..."];
//        [HooVersionTool getAppVersionWithBlock:^(NSString *versionStr, NSError *error) {
//            [SVProgressHUD dismiss];
//            [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeNone];
//            
//            if (error) {
//                [SVProgressHUD showErrorWithStatus:@"网络出现意外，检查版本信息失败，请再试试"];
//            }
//            if (versionStr.length) {
//                NSDictionary *appInfo = [[NSBundle mainBundle] infoDictionary];
//                NSString *currentVersion = [appInfo objectForKey:@"CFBundleVersion"];
//                
//                if (![currentVersion isEqualToString:versionStr]) {
//                    NSString *message = [NSString stringWithFormat:@"检测到新版本，版本：%@，是否升级？", versionStr];
//                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"有新版可以更新" message:message delegate:weakSelf cancelButtonTitle:@"取消" otherButtonTitles:@"立即更新", nil];
//                    [alert show];
//
//                }else{
//                    [SVProgressHUD showInfoWithStatus:@"您当前的版本已经是最新版本"];
//                }
//                
//            }
//            
//        }];
//    };
    
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
            vc.title = item.title;
            [self.navigationController pushViewController:vc animated:true];
            

        }
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
#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        //https://itunes.apple.com/us/app/ding-ding-yin-ji-momentslife/id1049879738?ls=1&mt=8
        NSString *urlToOpen = @"itms-apps://itunes.apple.com/cn/app/ding-ding-yin-ji-momentslife/id1049879738?ls=1&mt=8";
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlToOpen]];
    }

}


@end
