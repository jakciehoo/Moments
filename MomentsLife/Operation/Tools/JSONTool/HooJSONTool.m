//
//  HooJSONTool.m
//  MomentsLife
//
//  Created by HooJackie on 15/8/24.
//  Copyright (c) 2015年 jackieHoo. All rights reserved.
//

#import "HooJSONTool.h"
#import "HooMoment.h"
#import "MJExtension.h"
#import "HooSqlliteTool.h"

@implementation HooJSONTool

static NSArray *_moments;

+ (BOOL)saveMoments
{
    BOOL flag = NO;
    if (_moments == nil) {
        //从program.json 将数据转化成数组
        NSURL *fileURL = [[NSBundle mainBundle] URLForResource:@"program.json" withExtension:nil];
        NSData *data = [NSData dataWithContentsOfURL:fileURL];
        NSDictionary *JSONDict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    
        NSArray *momentsArray = JSONDict[@"tasks"];
        NSArray *moments = [HooMoment objectArrayWithKeyValuesArray:momentsArray];
        
        
        //保存数据到数据库
        for (HooMoment *moment in moments) {
            moment.fontColorR = 1.0;
            moment.fontColorG = 1.0;
            moment.fontColorB = 1.0;
            moment.fontSize = 17.0;
            moment.fontName = @"Avenir-HeavyOblique";
            flag = [HooSqlliteTool addNewMoment:moment];
        }
    }
    return flag;
}

@end
