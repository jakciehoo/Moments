//
//  HooReminderViewController.m
//  MomentsQuote(丁丁美文)
//
//  Created by HooJackie on 15/8/9.
//  Copyright (c) 2015年 jackieHoo. All rights reserved.
//

#import "HooReminderViewController.h"
#import "HooSaveTools.h"


@interface HooReminderViewController ()
@property (weak, nonatomic) IBOutlet UIDatePicker *dataPicker;
@property (weak, nonatomic) IBOutlet UISwitch *reminderSwitch;
@property (weak, nonatomic) IBOutlet UILabel *reminderLabel;

@property (nonatomic, strong) NSDate *dueDate;

@property (nonatomic, strong) NSDateFormatter *formatter;

@end

@implementation HooReminderViewController

- (NSDateFormatter *)formatter
{
    if (_formatter == nil) {
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = @"HH:mm";
        _formatter = formatter;
    }
    return _formatter;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    //从沙盒中取值，并判断是否存在
    BOOL reminderSwithState = [HooSaveTools boolForkey:SwitchState];
    if (reminderSwithState) {
        self.dataPicker.alpha = 1.0;
        self.reminderLabel.alpha = 1.0;
    }else{
        self.dataPicker.alpha = 0.0;
        self.reminderLabel.alpha = 0.0;
    }
    
    self.reminderSwitch.on = reminderSwithState;

    
    NSString *dateStr = [HooSaveTools objectForKey:DatePicked];
    if (dateStr.length != 0) {
        
        self.dataPicker.date = [self.formatter dateFromString:dateStr];
    }else{
        NSString *defaultDate = @"07:00";
        
        self.dataPicker.date = [self.formatter dateFromString:defaultDate];
    }
    

    //添加值变化调用方法
    [self.dataPicker addTarget:self action:@selector(dateChanged:) forControlEvents:UIControlEventValueChanged];
}

- (void)dateChanged:(UIDatePicker *)picker
{
    self.dueDate = picker.date;
    
    NSString *dateStr = [self.formatter stringFromDate:self.dueDate];
    HooLog(@"%@",dateStr);
    NSDate *date = [self.formatter dateFromString:dateStr];
    NSLog(@"%@",date);
    NSString *alertBody = @"丁丁美文有新的美文啦，请打开查看，希望能让你喜欢";
    //发起通知
    [self scheduleNotification:date alertBody:alertBody];
    // 保存到沙盒
    [HooSaveTools setObject:dateStr forKey:DatePicked];
    //通知代理
    if ([self.delegate respondsToSelector:@selector(datePick:pickeDate:)]) {
        [self.delegate datePick:picker pickeDate:dateStr];
    }
    
    
    
    
}
#pragma mark - UISwith
- (IBAction)timeSwitch:(UISwitch *)sender {
    
    if (sender.on) {
        //ios8 需要用户授权通知
        if ([UIDevice currentDevice].systemVersion.floatValue >= 8.0){
            UIUserNotificationSettings *notificationSettings = [UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert | UIUserNotificationTypeBadge | UIUserNotificationTypeSound categories:nil];
            [[UIApplication sharedApplication] registerUserNotificationSettings:notificationSettings];
        }
        //显示控件
        [UIView animateWithDuration:0.5 animations:^{
            self.dataPicker.alpha = 1.0;
            self.reminderLabel.alpha = 1.0;
        }];
    }else{
        //隐藏控件
        [UIView animateWithDuration:0.5 animations:^{
            self.dataPicker.alpha = 0.0;
            self.reminderLabel.alpha = 0.0;
        } completion:^(BOOL finished) {
            //隐藏的话就是不希望收到通知那我们就删除通知
            [self cancelNotification];
        }];

    }
    //保存UISwitch的控件状态
    [HooSaveTools setBool:sender.on forKey:SwitchState];
    
}

//发起通知
- (void)scheduleNotification:(NSDate *)dueDate alertBody:(NSString *)alertBody
{
    //先删除之前定义过的通知
    [self cancelNotification];
    //再发起新的通知

        UILocalNotification *localNotification = [[UILocalNotification alloc] init];
        localNotification.fireDate = dueDate;
        localNotification.repeatInterval = NSCalendarUnitDay;
        localNotification.timeZone = [NSTimeZone defaultTimeZone];
        localNotification.alertBody = alertBody;
        localNotification.userInfo = @{@"reminderNotification":@"reminderNotification"};
        localNotification.soundName = UILocalNotificationDefaultSoundName;
        [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
}
//取消通知
- (void)cancelNotification
{
    NSArray *notifications = [[UIApplication sharedApplication] scheduledLocalNotifications];
    for (UILocalNotification *notification in notifications) {
        if (notification.userInfo[@"reminderNotification"]) {
            [[UIApplication sharedApplication] cancelLocalNotification:notification];
        }
    }
}


@end
