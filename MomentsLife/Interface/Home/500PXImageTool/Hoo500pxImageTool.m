//
//  Hoo500pxImageTool.m
//  MomentsLife
//
//  Created by HooJackie on 15/9/11.
//  Copyright (c) 2015年 jackieHoo. All rights reserved.
//

#import "Hoo500pxImageTool.h"
#import "HooHttpTool.h"


#define PXURLString @"https://api.500px.com/v1/photos"
#define PXKey @"cCiBRldlPAKMkHRAn9c6DTPeT9g6o0WZE677BWFH"
#define PXSecret @"rdO1QXtSrwFOAh0QPF6NQRcbB3VFcz1NrLRnM3a6"

@implementation Hoo500pxImageTool

+(void)downloadImageProgress:(void(^)(NSInteger receivedSize, NSInteger expectedSize))progress completed:(void(^)(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL))completed
{
    NSInteger pageNumber = 1;
    NSDictionary *prams = @{@"consumer_key":PXKey,@"feature":@"popular",@"rpp":@"50",@"page":[NSString stringWithFormat:@"%ld",(long)pageNumber],@"image_size":@"4",@"only":@"Landscapes",@"except":@"Nude"};
    [HooHttpTool GET:PXURLString parameters:prams success:^(id responseObject) {
        NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        NSArray *photos = [jsonDict valueForKey:@"photos"];
        NSURL *imageURL = [photos[0] valueForKey:@"image_url"];
        SDWebImageManager *manager = [SDWebImageManager sharedManager];
        [manager downloadImageWithURL:imageURL options:SDWebImageRetryFailed progress:^(NSInteger receivedSize, NSInteger expectedSize) {
            if (progress) {
                progress(receivedSize,expectedSize);
            }
            
        } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
            if (completed) {
                completed(image,error,cacheType,finished,imageURL);
            }
        }];

        
    } failure:^(NSError *error) {
        HooLog(@"%@",error);
    }];

}
@end
