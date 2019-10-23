//
//  HooShareTool.m
//  MomentsLife
//
//  Created by HooJackie on 15/9/13.
//  Copyright (c) 2015年 jackieHoo. All rights reserved.
//

#import "HooShareTool.h"
#import <ShareSDK/ShareSDK.h>

#define ShareCONTENT @"我正在使用《丁丁印记》APP分享我制作的图文海报。《丁丁印记》每天会推送一张精美海报，你也可以记录美图美文心情，并将你喜欢的图文海报进行自由设计，然后定制打印到各种生活用品上，将美好带进生活!"
#define ShareURL @"http://momentslife.bmob.cn/"

@implementation HooShareTool

+ (void)showshareAlertControllerIn:(UIView *)view WithImage:(UIImage *)image andFileName:(NSString *)fileName
{
    NSData *imageData = UIImageJPEGRepresentation(image, 0.5);
    
    //构造分享内容
    id<ISSContent> publishContent = [ShareSDK content:ShareCONTENT
                                       defaultContent:ShareCONTENT
                                                image:[ShareSDK imageWithData:imageData fileName:fileName mimeType:@"jpg"]
                                                title:@"来自丁丁印记(MomentLife)分享"
                                                  url:ShareURL
                                          description:ShareCONTENT
                                            mediaType:SSPublishContentMediaTypeImage];
    //创建弹出菜单容器
    id<ISSContainer> container = [ShareSDK container];
    [container setIPadContainerWithView:view arrowDirect:UIPopoverArrowDirectionAny];
    //[container setIPhoneContainerWithViewController:self];
    
    //自动授权
    id<ISSAuthOptions> authOptions = [ShareSDK authOptionsWithAutoAuth:YES
                                                         allowCallback:NO
                                                         authViewStyle:SSAuthViewStyleModal
                                                          viewDelegate:nil
                                               authManagerViewDelegate:nil];
    
    [authOptions setFollowAccounts:@{SHARE_TYPE_NUMBER(ShareTypeSinaWeibo):[ShareSDK userFieldWithType:SSUserFieldTypeName value:@"火炭糖－丁丁印记"]}];
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

+ (void)showshareAlertControllerIn:(UIView *)view WithImageURL:(NSString *)imageURL andFileName:(NSString *)fileName
{
    
    //构造分享内容
    id<ISSContent> publishContent = [ShareSDK content:ShareCONTENT
                                       defaultContent:ShareCONTENT
                                                image:[ShareSDK imageWithUrl:imageURL]
                                                title:@"来自丁丁印记(MomentLife)分享"
                                                  url:ShareURL
                                          description:ShareCONTENT
                                            mediaType:SSPublishContentMediaTypeImage];
    //创建弹出菜单容器
    id<ISSContainer> container = [ShareSDK container];
    [container setIPadContainerWithView:view arrowDirect:UIPopoverArrowDirectionAny];
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
