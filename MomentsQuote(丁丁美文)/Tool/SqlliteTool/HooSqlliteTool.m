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
#import "NSDate+Extension.h"
#import "MJExtension.h"


@interface HooSqlliteTool ()

@property (nonatomic,strong)NSMutableDictionary *momentParams;

@end

@implementation HooSqlliteTool

-(NSMutableDictionary *)momentParams
{
    if (_momentParams ) {
        _momentParams = [NSMutableDictionary dictionary];
    }
    return _momentParams;
}


static FMDatabase *_db;

//类第一次使用时调用，在这里创建数据库HooMoments.sqlite和t_moment表
+(void)initialize
{
    NSString *dbFilePath = [HooDocumentDirectory stringByAppendingPathComponent:@"HooMoments.sqlite"];
    
    _db = [FMDatabase databaseWithPath:dbFilePath];
    if ([_db open]) {
        HooLog(@"打开数据库成功");
    }else{
        HooLog(@"打开数据库失败");
    }
    
    BOOL flag = [_db executeUpdate:@"CREATE TABLE IF NOT EXISTS t_moment (id integer PRIMARY KEY,description text,author text, fontName text NOT NULL DEFAULT 'Avenir-HeavyOblique',fontColorR real NOT NULL DEFAULT 1.0,fontColorG real NOT NULL DEFAULT 1.0,fontColorB real NOT NULL DEFAULT 1.0,fontSize NOT NULL DEFAULT 17.0,style text,positionX real NOT NULL DEFAULT 0.0,positionY real NOT NULL DEFAULT 0.0,image_filename text,image_thumb_filename text, image_filtername text,isFavorite integer  NOT NULL DEFAULT 0, show_date text,created_date text  NOT NULL,modified_date text NOT NULL)"];
    if (flag) {
        HooLog(@"创建表格t_moment成功");
    }else{
        HooLog(@"创建表格t_moment失败");
    }
    flag = [_db executeUpdate:@"CREATE TABLE IF NOT EXISTS t_myMoment (id integer PRIMARY KEY,description text,author text, fontName text NOT NULL DEFAULT 'Avenir-HeavyOblique',fontColorR real NOT NULL DEFAULT 1.0,fontColorG real NOT NULL DEFAULT 1.0,fontColorB real NOT NULL DEFAULT 1.0,fontSize NOT NULL DEFAULT 17.0,style text,positionX real NOT NULL DEFAULT 0.0,positionY real NOT NULL DEFAULT 0.0,image_filename text,image_thumb_filename text, image_filtername text,isFavorite integer  NOT NULL DEFAULT 0,created_date text  NOT NULL,modified_date text NOT NULL)"];
    if (flag) {
        HooLog(@"创建表格t_myMoment成功");
    }else{
        HooLog(@"创建表格t_myMoment失败");
    }
}
/*----------------------------查数据----------------------------------------*/
+ (NSArray *)getMyMomentsBefore:(NSString *)date LimitCount:(NSInteger)count
{
    NSString *sql =[NSString stringWithFormat:@"SELECT * FROM t_myMoment WHERE modified_date < %@ ORDER BY modified_date DESC limit %ld",date ,count] ;
    
    NSArray *momentArr = [self momentResultsWithSql:sql];
    
    return momentArr;
    
}
+ (NSInteger)momentsCount
{
    NSString *sql = @"SELECT COUNT(*) FROM t_moment";
    NSInteger count = [_db intForQuery:sql];
    return count;
}
+ (NSInteger)myMomentsCount
{
    NSString *sql = @"SELECT COUNT(*) FROM t_myMoment";
    NSInteger count = [_db intForQuery:sql];
    return count;
}




+ (NSArray *)momentsBeforeDate:(NSString *)date andIsStared:(BOOL)isStared containText:(NSString *)text limitCount:(NSInteger)count
{
    NSString *sql = @"SELECT * FROM t_moment";
    
    if (date.length || isStared || text.length) {
        sql = [sql stringByAppendingString:@" where image_filename NOTNULL"];
    }
    
    if (date.length) {
        NSString *dateStr = [NSString stringWithFormat:@" and modified_date < '%@'",date];
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
    NSArray *momentArr = [self momentResultsWithSql:sql];
    
    return momentArr;
}


+ (HooMoment *)myMomentWithID:(NSInteger)ID
{
    NSNumber *IDNumber = [NSNumber numberWithInteger:ID];
    
    NSString *sql = [NSString stringWithFormat:@"select * from t_myMoment where id = '%@';",IDNumber];
    NSArray *momentArr = [self momentResultsWithSql:sql];
    
    if (momentArr.count>0) {
        return momentArr[0];
    }else{
        return nil;
    }
}

+ (HooMoment *)myOlderMomentOfMyMomentWithID:(NSInteger)ID
{
    NSNumber *IDNumber = [NSNumber numberWithInteger:ID];
    
    NSString *sql = [NSString stringWithFormat:@"select * from t_myMoment where id < '%@' ORDER BY id DESC LIMIT 1;",IDNumber];
    NSArray *momentArr = [self momentResultsWithSql:sql];
    
    if (momentArr.count>0) {
        return momentArr[0];
    }else{
        return nil;
    }
}

+ (HooMoment *)myMomentWithMaxID
{
    NSString *sql = @"select * from t_myMoment ORDER BY id DESC LIMIT 1;";
    NSArray *momentArr = [self momentResultsWithSql:sql];
    
    if (momentArr.count>0) {
        return momentArr[0];
    }else{
        return nil;
    }
}
+ (HooMoment *)myRandomMoment
{
    NSString *sql = @"select * from t_myMoment ORDER BY id DESC LIMIT 1;";
    NSArray *momentArr = [self momentResultsWithSql:sql];
    
    if (momentArr.count>0) {
        return momentArr[0];
    }else{
        return nil;
    }
}

+ (HooMoment *)momentWithID:(NSInteger)ID
{
    NSNumber *IDNumber = [NSNumber numberWithInteger:ID];
    
    NSString *sql = [NSString stringWithFormat:@"select * from t_moment where id = '%@';",IDNumber];
    NSArray *momentArr = [self momentResultsWithSql:sql];
    
    if (momentArr.count>0) {
        return momentArr[0];
    }else{
        return nil;
    }
}

+ (HooMoment *)olderMomentOfMomentWithID:(NSInteger)ID
{
    NSNumber *IDNumber = [NSNumber numberWithInteger:ID];
    
    NSString *sql = [NSString stringWithFormat:@"select * from t_moment where id < '%@' ORDER BY id DESC LIMIT 1;",IDNumber];
    NSArray *momentArr = [self momentResultsWithSql:sql];
    
    if (momentArr.count>0) {
        return momentArr[0];
    }else{
        return nil;
    }
}

+ (HooMoment *)momentWithMaxID
{
    NSString *sql = @"select * from t_moment ORDER BY id DESC LIMIT 1;";
    NSArray *momentArr = [self momentResultsWithSql:sql];
    
    if (momentArr.count>0) {
        return momentArr[0];
    }else{
        return nil;
    }
}

+ (HooMoment *)randomMoment
{
    NSString *sql = @"SELECT * FROM t_moment ORDER BY random() LIMIT 1;";
    NSArray *momentArr = [self momentResultsWithSql:sql];
    
    if (momentArr.count>0) {
        return momentArr[0];
    }else{
        return nil;
    }
}

+ (HooMoment *)momentWithshowDate:(NSDate *)date
{
    NSMutableArray *momentArr = [NSMutableArray array];
    
    NSString *dateStr = [date dateWithMMDDAndConvertToString];
    NSString *sql = [NSString stringWithFormat:@"select * from t_moment where show_date = '%@' ORDER BY id DESC limit 1;",dateStr];
    [momentArr addObjectsFromArray:[self momentResultsWithSql:sql]];
    if (momentArr.count == 0) {
        sql = @"SELECT * FROM t_moment WHERE show_date ISNULL and image_filename NOTNULL ORDER BY id DESC limit 1";
        [momentArr addObjectsFromArray:[self momentResultsWithSql:sql]];
    }
    
    if (momentArr.count>0) {
        return momentArr[0];
    }else{
        return nil;
    }
}

//公共方法
+ (NSArray *)momentResultsWithSql:(NSString *)sql
{
    NSMutableArray *momentArr = [NSMutableArray array];
    FMResultSet *set = [_db executeQuery:sql];
    while ([set next]) {
        HooMoment *moment = [[HooMoment alloc] init];
        HooPhoto *photo = [[HooPhoto alloc] init];
        moment.ID = [set intForColumn:@"id"];
        moment.quote = [set stringForColumn:@"description"];
        moment.author = [set stringForColumn:@"author"];
        moment.fontName = [set stringForColumn:@"fontName"];
        moment.fontColorR = [set doubleForColumn:@"fontColorR"];
        moment.fontColorG = [set doubleForColumn:@"fontColorG"];
        moment.fontColorB = [set doubleForColumn:@"fontColorB"];
        
        photo.style = [set stringForColumn:@"style"];
        photo.positionX = [set doubleForColumn:@"positionX"];
        photo.positionY = [set doubleForColumn:@"positionY"];
        photo.image_filename = [set stringForColumn:@"image_filename"];
        photo.image_thumb_filename = [set stringForColumn:@"image_thumb_filename"];
        photo.image_filtername = [set stringForColumn:@"image_filtername"];
        photo.isFavorite = [set intForColumn:@"isFavorite"];
        moment.photo = photo;
        moment.created_date = [set stringForColumn:@"created_date"];
        moment.modified_date = [set stringForColumn:@"modified_date"];
        [momentArr addObject:moment];
    }
    return momentArr;

}


/*----------------------------修改数据----------------------------------------*/

+ (BOOL)updateMyMoment:(HooMoment *)moment
{
    NSNumber *ID = @(moment.ID);
    NSString *description = moment.quote;
    NSString *author = moment.author;
    NSString *fontName;
    if (moment.fontName != nil) {
        
        fontName = moment.fontName;
    }else{
        fontName = @"Avenir-HeavyOblique";
    }
    NSNumber *fontColorR = [NSNumber numberWithFloat:moment.fontColorR];
    NSNumber *fontColorG = [NSNumber numberWithFloat:moment.fontColorG];
    NSNumber *fontColorB = [NSNumber numberWithFloat:moment.fontColorB];
    NSNumber *fontSize = [[NSNumber numberWithFloat:moment.fontSize] isEqualToNumber:@(0)] ? @(17.0):[NSNumber numberWithFloat:moment.fontSize];
    NSString *style = moment.photo.style;
    NSNumber *positionX = [NSNumber numberWithFloat:moment.photo.positionX];
    NSNumber *positionY = [NSNumber numberWithFloat:moment.photo.positionY];
    //NSString *image_filename = moment.photo.image_filename;
    NSString *image_thumb_filename = moment.photo.image_thumb_filename;
    NSString *image_filtername = moment.photo.image_filtername;
    NSNumber *isFavorite = [NSNumber numberWithBool:moment.photo.isFavorite];
    //NSString *created_date = moment.created_date;
    NSString *modified_date = moment.modified_date;
    
    BOOL flag = [_db executeUpdate:@"UPDATE t_myMoment SET description = ?, author = ?, fontName = ?, fontColorR = ?, fontColorG = ?, fontColorB = ?, fontSize = ?, style = ?, positionX = ?, positionY = ?, image_thumb_filename = ?, image_filtername = ?,isFavorite = ?, modified_date = ?  WHERE id = ? ",description, author, fontName, fontColorR, fontColorG, fontColorB, fontSize, style, positionX, positionY, image_thumb_filename, image_filtername,isFavorite, modified_date, ID];
    
    if (flag) {
        HooLog(@"更新成功");
    }else{
        HooLog(@"更新失败");
    }
    
    return flag;
    
}

+ (BOOL)updateMoment:(HooMoment *)moment
{
    NSNumber *ID = @(moment.ID);
    NSString *description = moment.quote;
    NSString *author = moment.author;
    NSString *fontName;
    if (moment.fontName != nil) {
        
        fontName = moment.fontName;
    }else{
        fontName = @"Avenir-HeavyOblique";
    }
    NSNumber *fontColorR = [NSNumber numberWithFloat:moment.fontColorR];
    NSNumber *fontColorG = [NSNumber numberWithFloat:moment.fontColorG];
    NSNumber *fontColorB = [NSNumber numberWithFloat:moment.fontColorB];
    NSNumber *fontSize = [[NSNumber numberWithFloat:moment.fontSize] isEqualToNumber:@(0)] ? @(17.0):[NSNumber numberWithFloat:moment.fontSize];
    NSString *style = moment.photo.style;
    NSNumber *positionX = [NSNumber numberWithFloat:moment.photo.positionX];
    NSNumber *positionY = [NSNumber numberWithFloat:moment.photo.positionY];
    //NSString *image_filename = moment.photo.image_filename;
    NSString *image_thumb_filename = moment.photo.image_thumb_filename;
    NSString *image_filtername = moment.photo.image_filtername;
    NSNumber *isFavorite = [NSNumber numberWithBool:moment.photo.isFavorite];
    NSString *show_date = moment.show_date;
    //NSString *created_date = moment.created_date;
    NSString *modified_date = moment.modified_date;
    
    BOOL flag = [_db executeUpdate:@"UPDATE t_moment SET description = ?, author = ?, fontName = ?, fontColorR = ?, fontColorG = ?, fontColorB = ?, fontSize = ?, style = ?, positionX = ?, positionY = ?, image_thumb_filename = ?, image_filtername = ?,isFavorite = ?, show_date = ?, modified_date = ?  WHERE id = ?",description, author, fontName, fontColorR, fontColorG, fontColorB, fontSize, style, positionX, positionY, image_thumb_filename, image_filtername,isFavorite, show_date, modified_date, ID];
    
    if (flag) {
        HooLog(@"更新成功");
    }else{
        HooLog(@"更新失败");
    }
    return flag;

}




/*----------------------------增加数据----------------------------------------*/
+ (BOOL)addNewMyMoment:(HooMoment *)moment
{
    
    NSString *description = moment.quote;
    NSString *author = moment.author;
    NSString *fontName;
    if (moment.fontName != nil) {
        
        fontName = moment.fontName;
    }else{
        fontName = @"Avenir-HeavyOblique";
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
    NSString *image_filtername = moment.photo.image_filtername;
    NSNumber *isFavorite = [NSNumber numberWithBool:moment.photo.isFavorite];

    NSDate *dateNow = [NSDate date];
    long interval = [dateNow timeIntervalSince1970];
    NSString *intervalString = [NSString stringWithFormat:@"%ld",interval];
    NSString *created_date = moment.created_date == nil ? intervalString : moment.created_date;
    NSString *modified_date = moment.modified_date == nil ? intervalString : moment.modified_date;
    
    BOOL flag = [_db executeUpdate:@"INSERT INTO t_myMoment (description, author, fontName, fontColorR, fontColorG, fontColorB, fontSize, style, positionX, positionY, image_filename, image_thumb_filename, image_filtername, isFavorite, created_date, modified_date) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)",description, author, fontName, fontColorR, fontColorG, fontColorB, fontSize, style, positionX, positionY, image_filename, image_thumb_filename, image_filtername, isFavorite, created_date, modified_date];
    if (flag) {
        HooLog(@"插入成功");
    }else{
        HooLog(@"插入失败");
    }
    return flag;
}


+ (BOOL)addNewMoment:(HooMoment *)moment
{
    
    NSString *description = moment.quote;
    NSString *author = moment.author;
    NSString *fontName;
    if (moment.fontName != nil) {
        
       fontName = moment.fontName;
    }else{
        fontName = @"Avenir-HeavyOblique";
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
    NSString *image_filtername = moment.photo.image_filtername;
    NSNumber *isFavorite = [NSNumber numberWithBool:moment.photo.isFavorite];
    
    NSString *show_date = moment.show_date;
    NSDate *dateNow = [NSDate date];
    long interval = [dateNow timeIntervalSince1970];
    NSString *intervalString = [NSString stringWithFormat:@"%ld",interval];
    NSString *created_date = moment.created_date == nil ? intervalString : moment.created_date;
    NSString *modified_date = moment.modified_date == nil ? intervalString : moment.modified_date;
    
    BOOL flag = [_db executeUpdate:@"INSERT INTO t_moment (description, author, fontName, fontColorR, fontColorG, fontColorB, fontSize, style, positionX, positionY, image_filename, image_thumb_filename, image_filtername, isFavorite, show_date, created_date, modified_date) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)",description, author, fontName, fontColorR, fontColorG, fontColorB, fontSize, style, positionX, positionY, image_filename, image_thumb_filename, image_filtername, isFavorite, show_date, created_date, modified_date];
    if (flag) {
        HooLog(@"插入成功");
    }else{
        HooLog(@"插入失败");
    }
    return flag;
}

/*----------------------------删数据----------------------------------------*/

+ (BOOL)deleteMyMomentWith:(NSInteger)ID
{
    NSString *sql = [NSString stringWithFormat:@"DELETE FROM t_myMoment WHERE id = %ld",(long)ID];
    BOOL flag = [_db executeUpdate:sql];
    if (flag) {
        HooLog(@"删除数据成功");
    }else{
        HooLog(@"删除失败");
    }
    return flag;
}

+ (BOOL)deleteMomentWith:(NSInteger)ID
{
    NSString *sql = [NSString stringWithFormat:@"DELETE FROM t_moment WHERE id = %ld",ID];
    BOOL flag = [_db executeUpdate:sql];
    if (flag) {
        HooLog(@"删除数据成功");
    }else{
        HooLog(@"删除失败");
    }
    return flag;
}


@end
