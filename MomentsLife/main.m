//
//  main.m
//  MomentsLife
//
//  Created by HooJackie on 15/8/3.
//  Copyright (c) 2015年 jackieHoo. All rights reserved.
//
#import <BmobSDK/Bmob.h>
#import <UIKit/UIKit.h>
#import "AppDelegate.h"

int main(int argc, char * argv[]) {
    @autoreleasepool {
        //注册Bmob
        NSString *appKey = @"cb13185e9105e68d950ffc489a1c5658";
        [Bmob registerWithAppKey:appKey];
        //This function is called in the main entry point to create the application object and the application delegate and set up the event cycle.
        return UIApplicationMain(argc, argv, nil, NSStringFromClass([AppDelegate class]));
    }
}
