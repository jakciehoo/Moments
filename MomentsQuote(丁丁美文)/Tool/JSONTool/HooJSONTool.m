//
//  HooJSONTool.m
//  MomentsQuote(丁丁美文)
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

+ (void)saveMoments
{
    if (_moments == nil) {
        //从program.json 将数据转化成数组
        NSURL *fileURL = [[NSBundle mainBundle] URLForResource:@"program.json" withExtension:nil];
        NSData *data = [NSData dataWithContentsOfURL:fileURL];
        NSDictionary *JSONDict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    
        NSArray *momentsArray = JSONDict[@"tasks"];
        NSArray *moments = [HooMoment objectArrayWithKeyValuesArray:momentsArray];
        
        
        //保存数据到数据库
        for (HooMoment *moment in moments) {
            
            [HooSqlliteTool addNewMoment:moment];
        }
    }
}

@end
