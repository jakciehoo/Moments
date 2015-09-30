//
//  HooShareTool.m
//  MomentsQuote(丁丁美文)
//
//  Created by HooJackie on 15/9/13.
//  Copyright (c) 2015年 jackieHoo. All rights reserved.
//

#import "HooShareTool.h"
#import <ShareSDK/ShareSDK.h>

@implementation HooShareTool

+ (void)showshareAlertControllerIn:(UIView *)view WithImage:(UIImage *)image andFileName:(NSString *)fileName
{
    NSData *imageData = UIImagePNGRepresentation(image);
    
    //构造分享内容
    id<ISSContent> publishContent = [ShareSDK content:@"我正在使用《丁丁印记》APP分享我制作的图文来记录我当下精彩时刻"
                                       defaultContent:@"我正在使用《丁丁印记》APP分享我制作的图文来记录我当下精彩时刻"
                                                image:[ShareSDK imageWithData:imageData fileName:fileName mimeType:@"png"]
                                                title:@"来自丁丁印记(MomentLife)分享"
                                                  url:@"http://weibo.com/hooyoo"
                                          description:@"我正在使用《丁丁印记》APP分享我制作的图文来记录我当下精彩时刻"
                                            mediaType:SSPublishContentMediaTypeImage];
    //创建弹出菜单容器
    id<ISSContainer> container = [ShareSDK container];
    [container setIPadContainerWithView:view arrowDirect:UIPopoverArrowDirectionUp];
    //[container setIPhoneContainerWithViewController:self];
    
    //弹出分享菜单
    [ShareSDK showShareActionSheet:container
                         shareList:nil
                           content:publishContent
                     statusBarTips:YES
                       authOptions:nil
                      shareOptions:nil
                            result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
                                
                                if (state == SSResponseStateSuccess)
                                {
                                    UIAlertView *successAlert = [[UIAlertView alloc] initWithTitle:@"分享成功"
                                                                                           message:nil
                                                                                          delegate:self
                                                                                 cancelButtonTitle:@"知道了"
                                                                                 otherButtonTitles:nil, nil];
                                    [successAlert show];
                                    
                                }
                                else if (state == SSResponseStateFail)
                                {
                                    UIAlertView *failAlert = [[UIAlertView alloc] initWithTitle:@"分享失败"
                                                                                        message:[NSString stringWithFormat:@"失败描述：%@",[error errorDescription]]
                                                                                       delegate:self
                                                                              cancelButtonTitle:@"知道了"
                                                                              otherButtonTitles:@"再试一次", nil];
                                    [failAlert show];
                                    
                                }
                            }];
}


@end
