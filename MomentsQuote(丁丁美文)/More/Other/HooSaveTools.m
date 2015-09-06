//
//  HooSaveTools.m
//  HooLottery
//
//  Created by HooJackie on 15/7/7.
//  Copyright (c) 2015年 jackie. All rights reserved.
//

#import "HooSaveTools.h"

@implementation HooSaveTools

+ (void)setObject:(id)value forKey:(NSString *)defaultName
{
    [[NSUserDefaults standardUserDefaults] setObject:value forKey:defaultName];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
+ (id)objectForKey:(NSString *)defaultName
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:defaultName];
    

}


+ (void)setBool:(BOOL)value forKey:(NSString *)defaultName
{
    [[NSUserDefaults standardUserDefaults] setBool:value forKey:defaultName];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (BOOL)boolForkey:(NSString *)defaultName
{
    return  [[NSUserDefaults standardUserDefaults] boolForKey:defaultName];
}



@end
