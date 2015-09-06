//
//  HooSqlliteTool.m
//  MomentsQuote(丁丁美文)
//
//  Created by HooJackie on 15/8/24.
//  Copyright (c) 2015年 jackieHoo. All rights reserved.
//

#import "HooSqlliteTool.h"
#import "FMDB.h"
#import "HooMoment.h"
#import "HooPhoto.h"
#import "MJExtension.h"
#import "NSDate+Extension.h"

@implementation HooSqlliteTool

static FMDatabase *_db;

//类第一次使用时调用，在这里创建数据库HooMoments.sqlite和t_moment表
+(void)initialize
{
    NSString *dbFilePath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)[0] stringByAppendingPathComponent:@"HooMoments.sqlite"];
    
    _db = [FMDatabase databaseWithPath:dbFilePath];
    if ([_db open]) {
        HooLog(@"打开数据库成功");
    }else{
        HooLog(@"打开数据库失败");
    }
    
    BOOL flag = [_db executeUpdate:@"CREATE TABLE IF NOT EXISTS t_moment (id integer PRIMARY KEY,description text,author text, fontName text NOT NULL DEFAULT 'American Typewriter',fontColorR real NOT NULL DEFAULT 0.0,fontColorG real NOT NULL DEFAULT 0.0,fontColorB real NOT NULL DEFAULT 0.0,fontSize NOT NULL DEFAULT 17.0,style text,positionX real NOT NULL DEFAULT 0.0,positionY real NOT NULL DEFAULT 0.0,image_filename text,image_thumb_filename text,isFavorite integer  NOT NULL DEFAULT 0,isMine integer NOT NULL DEFAULT 0,created_date text  NOT NULL,modified_date text NOT NULL)"];
    if (flag) {
        HooLog(@"创建表格成功");
    }else{
        HooLog(@"创建表格失败");
    }
}


+ (NSArray *)momentsBeforeDate:(NSString *)date andIsStared:(BOOL)isStared containText:(NSString *)text limitCount:(NSInteger)count
{
    NSString *sql = @"SELECT * FROM t_moment";
    
    if (date.length || isStared || text.length) {
        sql = [sql stringByAppendingString:@" where"];
    }
    
    if (date.length) {
        NSString *dateStr = [NSString stringWithFormat:@" modified_date < '%@'",date];
        sql = [sql stringByAppendingString:dateStr];
        
    }

    if (isStared) {
        NSString *starStr = [NSString stringWithFormat:@" and isFavorite = %d", isStared];
        sql = [sql stringByAppendingString:starStr];
    }

    if (text.length) {
        NSString *textStr = [NSString stringWithFormat:@" and description like '%%%@%%'",text];
        sql = [sql stringByAppendingString:textStr];
    }

    if (count) {
        NSString *countStr = [NSString stringWithFormat:@" order by modified_date desc limit %ld",count];
        sql = [sql stringByAppendingString:countStr];
    }
    
    FMResultSet *set = [_db executeQuery:sql];
    NSMutableArray *arrM = [NSMutableArray array];
    
    while ([set next]) {
        HooMoment *moment = [[HooMoment alloc] init];
        HooPhoto *photo = [[HooPhoto alloc] init];
        moment.quote = [set stringForColumn:@"description"];
        moment.author = [set stringForColumn:@"author"];
        moment.fontName = [set stringForColumn:@"fontName"];
        moment.fontColorR = [set doubleForColumn:@"fontColorR"];
        moment.fontColorG = [set doubleForColumn:@"fontColorG"];
        moment.fontColorG = [set doubleForColumn:@"fontColorG"];
        moment.fontColorG = [set doubleForColumn:@"fontColorG"];
        
        photo.style = [set stringForColumn:@"style"];
        photo.positionX = [set doubleForColumn:@"positionX"];
        photo.positionY = [set doubleForColumn:@"positionY"];
        photo.image_filename = [set stringForColumn:@"image_filename"];
        photo.image_thumb_filename = [set stringForColumn:@"image_thumb_filename"];
        photo.isFavorite = [set intForColumn:@"isFavorite"];
        moment.photo = photo;
        moment.isMine = [set intForColumn:@"isMine"];
        moment.created_date = [set stringForColumn:@"created_date"];
        moment.modified_date = [set stringForColumn:@"modified_date"];
        [arrM addObject:moment];
    }
    
    return arrM;
}


+ (HooMoment *)momentWithModified_date:(NSString *)modified_date
{
    NSMutableArray *momentArr = [NSMutableArray array];
    
       NSString *sql = [NSString stringWithFormat:@"select * from t_moment where modified_date = '%@';",modified_date];
        FMResultSet *set = [_db executeQuery:sql];
        while ([set next]) {
            HooMoment *moment = [[HooMoment alloc] init];
            HooPhoto *photo = [[HooPhoto alloc] init];
            moment.quote = [set stringForColumn:@"description"];
            moment.author = [set stringForColumn:@"author"];
            moment.fontName = [set stringForColumn:@"fontName"];
            moment.fontColorR = [set doubleForColumn:@"fontColorR"];
            moment.fontColorG = [set doubleForColumn:@"fontColorG"];
            moment.fontColorG = [set doubleForColumn:@"fontColorG"];
            moment.fontColorG = [set doubleForColumn:@"fontColorG"];
            
            photo.style = [set stringForColumn:@"style"];
            photo.positionX = [set doubleForColumn:@"positionX"];
            photo.positionY = [set doubleForColumn:@"positionY"];
            photo.image_filename = [set stringForColumn:@"image_filename"];
            photo.image_thumb_filename = [set stringForColumn:@"image_thumb_filename"];
            photo.isFavorite = [set intForColumn:@"isFavorite"];
            moment.photo = photo;
            moment.isMine = [set intForColumn:@"isMine"];
            moment.created_date = [set stringForColumn:@"created_date"];
            moment.modified_date = [set stringForColumn:@"modified_date"];
            [momentArr addObject:moment];
        }
    
    return momentArr[0];
}
+ (HooMoment *)momentWithID:(NSInteger)ID
{
    NSNumber *IDNumber = [NSNumber numberWithInteger:ID];
    NSMutableArray *momentArr = [NSMutableArray array];
    
    NSString *sql = [NSString stringWithFormat:@"select * from t_moment where id = '%@';",IDNumber];
    FMResultSet *set = [_db executeQuery:sql];
    while ([set next]) {
        HooMoment *moment = [[HooMoment alloc] init];
        HooPhoto *photo = [[HooPhoto alloc] init];
        moment.quote = [set stringForColumn:@"description"];
        moment.author = [set stringForColumn:@"author"];
        moment.fontName = [set stringForColumn:@"fontName"];
        moment.fontColorR = [set doubleForColumn:@"fontColorR"];
        moment.fontColorG = [set doubleForColumn:@"fontColorG"];
        moment.fontColorG = [set doubleForColumn:@"fontColorG"];
        moment.fontColorG = [set doubleForColumn:@"fontColorG"];
        
        photo.style = [set stringForColumn:@"style"];
        photo.positionX = [set doubleForColumn:@"positionX"];
        photo.positionY = [set doubleForColumn:@"positionY"];
        photo.image_filename = [set stringForColumn:@"image_filename"];
        photo.image_thumb_filename = [set stringForColumn:@"image_thumb_filename"];
        photo.isFavorite = [set intForColumn:@"isFavorite"];
        moment.photo = photo;
        moment.isMine = [set intForColumn:@"isMine"];
        moment.created_date = [set stringForColumn:@"created_date"];
        moment.modified_date = [set stringForColumn:@"modified_date"];
        [momentArr addObject:moment];
    }
    
    return momentArr[0];
}



+ (void)updateMoment:(HooMoment *)moment
{
    NSString *description = moment.quote;
    NSString *author = moment.author;
    NSString *fontName = moment.fontName;
    NSNumber *fontColorR = [NSNumber numberWithFloat:moment.fontColorR];
    NSNumber *fontColorG = [NSNumber numberWithFloat:moment.fontColorG];
    NSNumber *fontColorB = [NSNumber numberWithFloat:moment.fontColorB];
    NSNumber *fontSize = [[NSNumber numberWithFloat:moment.fontSize] isEqualToNumber:@(0)] ? @(17.0):[NSNumber numberWithFloat:moment.fontSize];
    NSString *style = moment.photo.style;
    NSNumber *positionX = [NSNumber numberWithFloat:moment.photo.positionX];
    NSNumber *positionY = [NSNumber numberWithFloat:moment.photo.positionY];
    NSString *image_filename = moment.photo.image_filename;
    NSString *image_thumb_filename = moment.photo.image_thumb_filename;
    NSNumber *isFavorite = [NSNumber numberWithBool:moment.photo.isFavorite];
    NSNumber *isMine = [NSNumber numberWithBool:moment.isMine];
    NSString *created_date = moment.created_date;
    NSString *modified_date = moment.modified_date;
    
    BOOL flag = [_db executeUpdate:@"UPDATE t_moment SET description = ?, author = ?, fontName = ?, fontColorR = ?, fontColorG = ?, fontColorB = ?, fontSize = ?, style = ?, positionX = ?, positionY = ?, image_thumb_filename = ?, isFavorite = ?, isMine = ?, modified_date = ?  WHERE created_date = ? AND image_filename = ? ",description, author, fontName, fontColorR, fontColorG, fontColorB, fontSize, style, positionX, positionY, image_thumb_filename, isFavorite, isMine, modified_date, created_date, image_filename];
    
    if (flag) {
        HooLog(@"更新成功");
    }else{
        HooLog(@"更新失败");
    }

}




+ (void)addNewMoment:(HooMoment *)moment
{
    
    NSString *description = moment.quote;
    NSString *author = moment.author;
    NSString *fontName;
    if (moment.fontName != nil) {
        
       fontName = moment.fontName;
    }else{
        fontName = @"American Typewriter";
    }
    NSNumber *fontColorR = [NSNumber numberWithFloat:moment.fontColorR];
    NSNumber *fontColorG = [NSNumber numberWithFloat:moment.fontColorG];
    NSNumber *fontColorB = [NSNumber numberWithFloat:moment.fontColorB];
    NSNumber *fontSize = [[NSNumber numberWithFloat:moment.fontSize] isEqualToNumber:@(0)] ? @(17.0):[NSNumber numberWithFloat:moment.fontSize];
    NSString *style = moment.photo.style;
    NSNumber *positionX = [NSNumber numberWithFloat:moment.photo.positionX];
    NSNumber *positionY = [NSNumber numberWithFloat:moment.photo.positionY];
    NSString *image_filename = moment.photo.image_filename;
    NSString *image_thumb_filename = moment.photo.image_thumb_filename;
    NSNumber *isFavorite = [NSNumber numberWithBool:moment.photo.isFavorite];
    NSNumber *isMine = [NSNumber numberWithBool:moment.isMine];
    NSString *created_date = moment.created_date;
    NSString *modified_date = moment.modified_date;
    
    BOOL flag = [_db executeUpdate:@"INSERT INTO t_moment (description, author, fontName, fontColorR, fontColorG, fontColorB, fontSize, style, positionX, positionY, image_filename, image_thumb_filename, isFavorite, isMine, created_date, modified_date) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)",description, author, fontName, fontColorR, fontColorG, fontColorB, fontSize, style, positionX, positionY, image_filename, image_thumb_filename, isFavorite, isMine, created_date, modified_date];
    
    if (flag) {
        HooLog(@"插入成功");
    }else{
        HooLog(@"插入失败");
    }
}


@end
