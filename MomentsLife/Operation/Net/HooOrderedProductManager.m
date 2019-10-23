//
//  HooOderedProductManager.m
//  MomentsLife
//
//  Created by HooJackie on 15/10/7.
//  Copyright (c) 2015年 jackieHoo. All rights reserved.
//
#import <BmobSDK/BmobProFile.h>
#import <BmobSDK/Bmob.h>
#import "HooOrderedProductManager.h"
#import "OrderedProduct.h"

#define CustomErrorDomain @"com.jackiehoo.MomentsLife"
typedef enum {
    XDefultFailed = -1000,
    XRegisterFailed,
    XConnectFailed,
    XPhotoCountFailed
}CustomErrorFailed;

@implementation HooOrderedProductManager

static HooOrderedProductManager *deliveryManager;

+ (instancetype)manager
{
    static dispatch_once_t token;
    dispatch_once(&token, ^{
        deliveryManager = [[HooOrderedProductManager alloc] init];
        
    });
    return deliveryManager;
}
- (void)uploadOrderedProductWithOriginImageData:(NSData *)origin_imageData andDesignedImageData:(NSData *)designed_imageData WithOrderedProduct:(OrderedProduct *)orderedProduct WithResultBlock:(void(^)(BOOL isSuccessful, NSError *error))resultBlock andProgress:(void(^)(NSUInteger index, CGFloat progress))progress
{
    
    NSDictionary *dict1 = [[NSDictionary alloc] initWithObjectsAndKeys:@"origin_image.png",@"filename",origin_imageData,@"data", nil];
    NSDictionary *dict2 = [[NSDictionary alloc] initWithObjectsAndKeys:@"designed_image.png",@"filename",designed_imageData,@"data", nil];
    NSArray *imageDataArray = @[dict1,dict2];
    
    [BmobProFile uploadFilesWithDatas:imageDataArray resultBlock:^(NSArray *filenameArray, NSArray *urlArray, NSArray *bmobFileArray, NSError *error) {
        if (error) {
            resultBlock(false,error);
            return;
        }
        NSMutableArray *image_urlArray = [NSMutableArray array];
        NSMutableArray *imagefileNameArray = [NSMutableArray array];
        for (BmobFile* bmobFile in bmobFileArray ) {
            [image_urlArray addObject:bmobFile.url];
            [imagefileNameArray addObject:bmobFile.name];
        }
        if (image_urlArray.count < imageDataArray.count){
            NSDictionary *userInfo = [NSDictionary dictionaryWithObject:@"上传的图片个数不符合"                                                                      forKey:NSLocalizedDescriptionKey];
            NSError *error = [NSError errorWithDomain:CustomErrorDomain  code:XPhotoCountFailed userInfo:userInfo];
            resultBlock(false,error);
            return;
        }
        orderedProduct.origin_image_url = image_urlArray.firstObject;
        orderedProduct.designed_image_url = image_urlArray.lastObject;
        
        [BmobProFile thumbnailImageWithFilename:filenameArray.lastObject ruleID:1 resultBlock:^(BOOL isSuccessful, NSError *error, NSString *filename, NSString *url, BmobFile *file) {
            if (error) {
                resultBlock(false,error);
                return;
            }
            if (isSuccessful) {
                
                orderedProduct.designed_thumbImage_filename = filename;
                [orderedProduct sub_saveInBackgroundWithResultBlock:resultBlock];
            }
        }];
    } progress:progress];
}

- (void)downloadImageWithFilename:(NSString *)filename Withblock:(void(^)(BOOL isSuccessful, NSError *error, NSString *filepath))block andProgress:(void(^)(CGFloat progress))progress
{
    [BmobProFile downloadFileWithFilename:filename block:block progress:progress];
}

@end
