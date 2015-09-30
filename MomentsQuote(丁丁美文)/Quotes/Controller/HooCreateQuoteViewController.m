//
//  HooCreateQuoteViewController.m
//  MomentsQuote(丁丁美文)
//
//  Created by HooJackie on 15/9/14.
//  Copyright (c) 2015年 jackieHoo. All rights reserved.
//

#import "HooCreateQuoteViewController.h"
#import "HooTextViewCell.h"
#import "HooCreateCell.h"
#import "HooTextView.h"
#import "HooMoment.h"
#import "HooSqlliteTool.h"
#import "NSDate+Extension.h"

@interface HooCreateQuoteViewController ()<UITextViewDelegate>

@end

@implementation HooCreateQuoteViewController

- (HooMoment *)editMoment
{
    if (_editMoment == nil) {
        _editMoment = [[HooMoment alloc] init];
    }
    return _editMoment;
}

static NSString *ID = @"Cell";
static NSString *DeleteID = @"deleteCell";
- (instancetype)init
{
    if (self = [super init]) {
        self = [self initWithStyle:UITableViewStyleGrouped];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    

    [self.navigationController setNavigationBarHidden:NO animated:YES];
    self.tableView.estimatedRowHeight = 100;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    
    [self.tableView registerNib:[UINib nibWithNibName:@"HooTextViewCell" bundle:nil] forCellReuseIdentifier:ID];
        [self.tableView registerNib:[UINib nibWithNibName:@"HooCreateCell" bundle:nil] forCellReuseIdentifier:DeleteID];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return 1;
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return @"正文";
    }else if (section == 1){
    return @"签名";
    }
    return nil;

}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    HooTextViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID forIndexPath:indexPath];
    if (cell == nil) {
        cell = [[HooTextViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    
    if (indexPath.section == 0) {
        cell.textView.text = self.editMoment.quote;
        cell.textView.delegate = self;
    }
    if (indexPath.section == 1) {
        cell.textView.text = self.editMoment.author;
    }
    if (indexPath.section == 2) {
        HooCreateCell *deleteCell = [tableView dequeueReusableCellWithIdentifier:DeleteID];
        if (deleteCell == nil) {
            deleteCell = [[HooCreateCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:DeleteID];
        }
        deleteCell.createLabel.text = @"删除 >>";
        return deleteCell;
    }
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 2) {
        if (self.fromMine) {
            [HooSqlliteTool deleteMyMomentWith:self.editMoment.ID];
        }else{
            [HooSqlliteTool deleteMomentWith:self.editMoment.ID];
        }
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
}

#pragma mark - UITextViewDelegate
- (void)textViewDidChange:(UITextView *)textView
{
    if (textView.text.length>0) {
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"修改" style:UIBarButtonItemStyleDone target:self action:@selector(save)];
    }
    [self.tableView beginUpdates];
    [self.tableView endUpdates];
}
- (void)save
{
    HooTextViewCell *quoteCell = (HooTextViewCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    self.editMoment.quote = quoteCell.textView.text;
    
    HooTextViewCell *authorCell = (HooTextViewCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1]];
    self.editMoment.author = authorCell.textView.text;
    
    //设置创建和修改时间
    NSString *intervalString = [[NSDate date] convertDateTointervalString];
    self.editMoment.modified_date = intervalString;

    [self.navigationController popViewControllerAnimated:YES];
}

@end
