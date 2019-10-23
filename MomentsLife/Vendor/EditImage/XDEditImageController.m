//
//  XDEditImageController.m
//  DoodleTee
//
//  Created by xieyajie on 14-01-21.
//  Copyright (c) 2013年 XD. All rights reserved.
//

#import "XDEditImageController.h"
#import <QuartzCore/QuartzCore.h>
#import "UIImage+Utility.h"


@interface XDEditImageController ()
{
    UIImage *_originalImage;
    CGFloat _mainY;
}

- (void)saveImage;

- (void)rotateLeft:(id)sender;
- (void)rotateRight:(id)sender;

- (void)arrangeItemsForInterfaceOrientation:(UIInterfaceOrientation)forInterfaceOrientation;

@end

@implementation XDEditImageController

- (id)initWithImage:(UIImage *)image
{
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        _originalImage = image;
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"调整图片大小";
	// Do any additional setup after loading the view, typically from a nib.
    CGFloat version = [[[UIDevice currentDevice] systemVersion] floatValue];
    _mainY = 10;
    if (version >= 7.0) {
        _mainY = 74;
    }
    else{
        if (self.navigationController.navigationBar.translucent) {
            _mainY = 54;
        }
    }
    
    self.view.backgroundColor = [UIColor blackColor];
    _toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - 44, self.view.frame.size.width, 44)];
    _toolbar.barStyle = UIBarStyleBlackTranslucent;
    _toolbar.tintColor = [UIColor whiteColor];
    
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithTitle:@"左转" style:UIBarButtonItemStylePlain target:self action:@selector(rotateLeft:)];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithTitle:@"右转" style:UIBarButtonItemStylePlain target:self action:@selector(rotateRight:)];
    UIBarButtonItem *doneItem = [[UIBarButtonItem alloc] initWithTitle:@"确定" style:UIBarButtonItemStylePlain target:self action:@selector(doneAction:)];
    UIBarButtonItem *flexibleItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    [_toolbar setItems:@[leftItem, rightItem, flexibleItem, doneItem]];
    [self.view addSubview:_toolbar];
    
    CGRect editorFrame = CGRectMake(20, _mainY, self.view.frame.size.width - 40, _toolbar.frame.origin.y - 10 - _mainY);
    
    _simpleImageEditorView = [[AGSimpleImageEditorView alloc] initWithAsset:nil image:_originalImage andFrame:editorFrame];
    if (self.ratio != 0) {
      _simpleImageEditorView.ratio = self.ratio;
    }else{
        _simpleImageEditorView.ratio = 4.0 / 4.0;
    };
    _simpleImageEditorView.borderWidth = 1.f;
    _simpleImageEditorView.borderColor = [UIColor darkGrayColor];
    _simpleImageEditorView.ratioViewBorderWidth = 3.f;
    
    [self arrangeItemsForInterfaceOrientation:self.interfaceOrientation];
    [self.view addSubview:_simpleImageEditorView];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    [super willRotateToInterfaceOrientation:toInterfaceOrientation duration:duration];

    [self arrangeItemsForInterfaceOrientation:toInterfaceOrientation];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

#pragma mark - Private

- (void)arrangeItemsForInterfaceOrientation:(UIInterfaceOrientation)forInterfaceOrientation
{
    CGRect bounds = [[UIScreen mainScreen] bounds];
    CGFloat width = bounds.size.width;
    //CGFloat height = bounds.size.height;
    
    if (UIInterfaceOrientationIsLandscape(forInterfaceOrientation)) {
        width = bounds.size.height;
      //  height = bounds.size.width;
    }
    
    CGRect editorFrame = CGRectMake(20, _mainY, width - 40, _toolbar.frame.origin.y - 10 - _mainY);
    _simpleImageEditorView.frame = editorFrame;
}

- (void)rotateLeft:(id)sender
{
    [_simpleImageEditorView rotateLeft];
}

- (void)rotateRight:(id)sender
{
    [_simpleImageEditorView rotateRight];
}

- (void)doneAction:(id)sender
{
    NSData *data = UIImageJPEGRepresentation(_simpleImageEditorView.output, 1);

    [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationFinishEditImage object:data];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)saveImage
{
    NSData *data = UIImageJPEGRepresentation(_simpleImageEditorView.output, 1);
    [data writeToFile:@"/Users/arturgrigor/Documents/image.jpg" atomically:YES];
}
- (void)dealloc
{
    HooLog(@"dealloc");
}

@end
