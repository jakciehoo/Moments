//
//  HooAddQuoteCell.m
//  MomentsLife
//
//  Created by HooJackie on 15/8/27.
//  Copyright (c) 2015年 jackieHoo. All rights reserved.
//

#import "HooAddQuoteCell.h"

@interface HooAddQuoteCell ()
@property (weak, nonatomic) IBOutlet UILabel *addQuoteLabel;

@end

@implementation HooAddQuoteCell

- (void)awakeFromNib {
    // Initialization code
    self.addQuoteLabel.textColor = HooTintColor;
    self.backgroundColor = [UIColor whiteColor];
}

@end
