//
//  HooProductDataTool.m
//  MomentsLife
//
//  Created by HooJackie on 15/9/29.
//  Copyright (c) 2015年 jackieHoo. All rights reserved.
//

#import "HooProductDataTool.h"

@implementation HooProductDataTool

+ (void)createProductArraySuccess:(void(^)(BOOL flag, NSMutableArray *productArray))success
{
    __weak typeof(self) weakSelf = self;

    
    NSMutableArray *categoryArr = [NSMutableArray array];
    
    BmobQuery   *bquery = [BmobQuery queryWithClassName:@"Category"];
    [bquery findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
        
        if (error){
            HooLog(@"%@",[error description]);
            return;
        }
        for (BmobObject *obj in array) {
            NSMutableDictionary *categoryDict = [NSMutableDictionary dictionary];
            NSString *category_name = [obj objectForKey:@"category_name"];
            if (category_name) {
                [categoryDict setObject:category_name forKey:@"category_name"];
            }
            
            NSString *category_id = obj.objectId;
            [categoryDict setObject:category_id forKey:@"category_id"];
            
            [categoryArr addObject:categoryDict];
        }

            [weakSelf addProductInfoWithCategoryArr:categoryArr success:success];
        
    }];
}
//产品信息
+ (void)addProductInfoWithCategoryArr:(NSMutableArray *)categoryArr success:(void(^)(BOOL flag, NSMutableArray *productArray))success
{
    __weak typeof(self) weakSelf = self;

    
    for (NSMutableDictionary *categoryDict in categoryArr) {
        NSString *category_id = categoryDict[@"category_id"];
        
        BmobQuery   *bquery = [BmobQuery queryWithClassName:@"Product"];
        [bquery whereKey:@"category_id" equalTo:category_id];
        [bquery findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
            if (error) return;
            NSMutableArray *productArr = [NSMutableArray array];
            for (BmobObject *obj in array) {
                
                NSMutableDictionary *productDict = [NSMutableDictionary dictionary];
                
                NSString *product_id = obj.objectId;
                [productDict setObject:product_id forKey:@"product_id"];
                
                NSString *product_name = [obj objectForKey:@"product_name"];
                if (product_name) {
                    [productDict setObject:product_name forKey:@"product_name"];
                }
                
                BmobFile *iconFile = [obj objectForKey:@"product_icon"];
                NSString *product_icon = iconFile.url;
                if (product_icon) {
                    [productDict setObject:product_icon forKey:@"product_icon"];
                }
                
                BmobFile *product_size_infoFile = [obj objectForKey:@"product_size_info"];
                NSString *product_size_infoURL = product_size_infoFile.url;
                if (product_size_infoURL) {
                    [productDict setObject:product_size_infoURL forKey:@"product_size_infoURL"];
                }
                
                [productArr addObject:productDict];
            }
            [categoryDict setObject:productArr forKey:@"products"];
            [weakSelf addModelInfoWithCategoryArr:categoryArr success:success];
        }];
    }
}
//产品品质信息
+ (void)addModelInfoWithCategoryArr:(NSMutableArray *)categoryArr success:(void(^)(BOOL flag, NSMutableArray *productArray))success
{
    __weak typeof(self) weakSelf = self;

    for (NSMutableDictionary *categoryDict in categoryArr) {
        NSMutableArray *products = categoryDict[@"products"];
        
        for (NSMutableDictionary *productDict in products) {
            NSString *product_id = productDict[@"product_id"];
            
            BmobQuery *bquery = [BmobQuery queryWithClassName:@"QualityModel"];
            
            [bquery whereKey:@"product_id" equalTo:product_id];
            [bquery findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
                if (error) {
                    HooLog(@"%@",[error description]);
                    return;
                }
                NSMutableArray *modelArr = [NSMutableArray array];
                for (BmobObject *obj in array) {
                    NSMutableDictionary *modelDict = [NSMutableDictionary dictionary];
                    
                    NSString *model_id = obj.objectId;
                    [modelDict setObject:model_id forKey:@"model_id"];
                    
                    NSString *model_name = [obj objectForKey:@"model_name"];
                    if (model_name) {
                        [modelDict setObject:model_name forKey:@"model_name"];
                    }
                    
                    BmobFile *model_infoFile = [obj objectForKey:@"model_info"];
                    NSString *model_infoURL = model_infoFile.url;
                    if (model_infoURL) {
                        [modelDict setObject:model_infoURL forKey:@"model_infoURL"];
                    }
                    
                    NSString *model_price = [obj objectForKey:@"model_price"];
                    if (model_price) {
                        [modelDict setObject:model_price forKey:@"model_price"];
                    }
                    
                    
                    [modelArr addObject:modelDict];
                }
                [productDict setObject:modelArr forKey:@"models"];
                [weakSelf addGroupInfoWithCategoryArr:categoryArr success:success];
                
            }];
        }
    }
}
//产品社会群体（男女，儿童等）信息
+ (void)addGroupInfoWithCategoryArr:(NSMutableArray *)categoryArr success:(void(^)(BOOL flag, NSMutableArray *productArray))success
{
    __weak typeof(self) weakSelf = self;

    for (NSMutableDictionary *categoryDict in categoryArr) {
        NSMutableArray *products = categoryDict[@"products"];
        
        for (NSMutableDictionary *productDict in products) {
            NSMutableArray *models = productDict[@"models"];
    
            for (NSMutableDictionary *modelDict in models) {
                NSString *model_id = modelDict[@"model_id"];
                
                BmobQuery   *bquery = [BmobQuery queryWithClassName:@"SocialGroup"];
                [bquery whereKey:@"model_id" equalTo:model_id];
                [bquery findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
                    if (error) return;
                    NSMutableArray *groupArr = [NSMutableArray array];
                    for (BmobObject *obj in array) {
                        
                        NSMutableDictionary *groupDict = [NSMutableDictionary dictionary];
                        
                        NSString *group_id = obj.objectId;
                        [groupDict setObject:group_id forKey:@"group_id"];
                        
                        NSString *group_name = [obj objectForKey:@"group_name"];
                        if (group_name) {
                            [groupDict setObject:group_name forKey:@"group_name"];
                        }

                        
                        [groupArr addObject:groupDict];
                    }
                    [modelDict setObject:groupArr forKey:@"groups"];
                    [weakSelf addColorInfoWithCategoryArr:categoryArr success:success];
                }];
            }
        }
    }
}
//颜色信息
+ (void)addColorInfoWithCategoryArr:(NSMutableArray *)categoryArr success:(void(^)(BOOL flag, NSMutableArray *productArray))success
{
    __weak typeof(self) weakSelf = self;

    for (NSMutableDictionary *categoryDict in categoryArr) {
        NSMutableArray *products = categoryDict[@"products"];
        
        for (NSMutableDictionary *productDict in products) {
            NSMutableArray *models = productDict[@"models"];
            
            for (NSMutableDictionary *modelDict in models) {
                NSMutableArray *groups = modelDict[@"groups"];
                
                for (NSMutableDictionary *groupDict in groups) {
                    NSString *group_id = groupDict[@"group_id"];
                    
                    BmobQuery   *bquery = [BmobQuery queryWithClassName:@"Color"];
                    [bquery whereKey:@"group_id" equalTo:group_id];
                    [bquery findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
                        if (error) return;
                        NSMutableArray *colorArr = [NSMutableArray array];
                        for (BmobObject *obj in array) {
                            
                            NSMutableDictionary *colorDict = [NSMutableDictionary dictionary];
                            
                            NSString *color_id = obj.objectId;
                            [colorDict setObject:color_id forKey:@"color_id"];
                            
                            NSString *color_name = [obj objectForKey:@"title"];
                            if (color_name) {
                                [colorDict setObject:color_name forKey:@"color_name"];
                            }
                            
                            NSString *color_hexa = [obj objectForKey:@"color_hexa"];
                            if (color_hexa) {
                                [colorDict setObject:color_hexa forKey:@"color_hexa"];
                            }
                            BmobFile *productFile = [obj objectForKey:@"product_image"];
                            NSString *product_imageURL = productFile.url;
                            if (product_imageURL) {
                                [colorDict setObject:product_imageURL forKey:@"product_imageURL"];
                            }
                            
                            NSString *patern_size = [obj objectForKey:@"patern_size"];
                            if (patern_size) {
                                [colorDict setObject:patern_size forKey:@"patern_size"];
                            }
                            
                            NSNumber *size_ratio = [obj objectForKey:@"size_ratio"];
                            if (size_ratio) {
                                [colorDict setObject:size_ratio forKey:@"size_ratio"];
                            }
                            
                            NSString *product_inventory_count = [obj objectForKey:@"product_inventory_count"];
                            if (product_inventory_count) {
                                [colorDict setObject:product_inventory_count forKey:@"product_inventory_count"];
                            }
                            
                            [colorArr addObject:colorDict];
                        }
                        [groupDict setObject:colorArr forKey:@"colors"];
                        [weakSelf addSizeInfoWithCategoryArr:categoryArr success:success];
                    }];
                }
            }
        }
    }
}
//尺寸信息
+ (void)addSizeInfoWithCategoryArr:(NSMutableArray *)categoryArr success:(void(^)(BOOL flag, NSMutableArray *productArray))success
{
    __block BOOL flag;
    for (NSMutableDictionary *categoryDict in categoryArr) {
        NSMutableArray *products = categoryDict[@"products"];
        
        for (NSMutableDictionary *productDict in products) {
            NSMutableArray *models = productDict[@"models"];
            
            for (NSMutableDictionary *modelDict in models) {
                NSMutableArray *groups = modelDict[@"groups"];
                
                for (NSMutableDictionary *groupDict in groups) {
                    NSMutableArray *colors = groupDict[@"colors"];
                    
                    for (NSMutableDictionary *colorDict in colors) {
                        NSString *color_id = colorDict[@"color_id"];
                    
                        BmobQuery   *bquery = [BmobQuery queryWithClassName:@"Size"];
                        [bquery whereKey:@"color_id" equalTo:color_id];
                        [bquery findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
                            if (error) return;
                            NSMutableArray *sizeArr = [NSMutableArray array];
                            for (BmobObject *obj in array) {
                                
                                NSMutableDictionary *sizeDict = [NSMutableDictionary dictionary];
                                
                                NSString *size_id = obj.objectId;
                                [sizeDict setObject:size_id forKey:@"size_id"];
                                
                                NSString *size_value = [obj objectForKey:@"size_value"];
                                if (size_value) {
                                    [sizeDict setObject:size_value forKey:@"size_value"];
                                }
                                
                                NSString *size_unit = [obj objectForKey:@"size_unit"];
                                if (size_unit) {
                                    [sizeDict setObject:size_unit forKey:@"size_unit"];
                                }
                                [sizeArr addObject:sizeDict];
                            }
                            [colorDict setObject:sizeArr forKey:@"sizes"];
                            
                            flag = YES;
                            if (success) {
                                success(flag,categoryArr);
                                return;
                            }
                        }];
                    }
                }
            }
        }
    }
}

@end
