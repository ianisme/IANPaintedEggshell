//
//  PaintEggshellLogController.m
//  ZiroomerProject
//  日志文件列表页面
//  Created by ian on 16/3/7.
//  Copyright © 2016年 Chris. All rights reserved.
//

#import "PaintEggshellLogController.h"
#import "PaintEggshellDetailLogViewController.h"
#import "PaintEggshellLogRequestListViewController.h"
#import "PaintEggshellDetailLogTableViewCell.h"
#import <Masonry.h>
#import "PaintEggshellLogTableViewCell.h"
#import "IANNetworkLogPlistModel.h"
#import "IANUtil.h"
#import "PaintedEggshellCrashDetailViewController.h"


static NSString *const kCellReuseIdentifier = @"NetWorkLogCell";

@interface PaintEggshellLogController ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, copy) NSString *logPath;

@end

@implementation PaintEggshellLogController


#pragma mark - life style

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self configInitData];
    [self creatNavigationBar];
    [self addTableView];
    [self loadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - table delegate && datasource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PaintEggshellLogTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellReuseIdentifier forIndexPath:indexPath];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;

    NSString *filePath = [NSString stringWithFormat:@"%@%@",_logPath,self.dataArray[indexPath.row]];
    IANNetworkLogPlistModel *model = [[IANNetworkLogPlistModel alloc] init];
    model.leftLabelTitle = [IANUtil revertTime:self.dataArray[indexPath.row]];
    model.rightLabelTitle = [IANUtil fileSizeAtPath:filePath];
    [cell configCellWithModel:model];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *filePath = [NSString stringWithFormat:@"%@%@",_logPath,self.dataArray[indexPath.row]];
    
    if (_logType == PaintEggshellLogNetWorkType) {
        NSArray *array = [NSKeyedUnarchiver unarchiveObjectWithFile:filePath];
        
        PaintEggshellLogRequestListViewController *controller = [[PaintEggshellLogRequestListViewController alloc] init];
        controller.dataArray = array;
        [self.navigationController pushViewController:controller animated:YES];
    } else {
        NSError *error = nil;
        NSString *string = [[NSString alloc] initWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:&error];
        NSLog(@"%@", string);
        PaintedEggshellCrashDetailViewController *controller = [[PaintedEggshellCrashDetailViewController alloc] init];
        controller.dataArray = [@[string] mutableCopy];
        [self.navigationController pushViewController:controller animated:YES];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {

        [self deleteFile:self.dataArray[indexPath.row]];
        [self.dataArray removeObjectAtIndex:indexPath.row];

        [tableView beginUpdates];
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationLeft];
        [tableView endUpdates];
    }
    
}


#pragma mark - private method

- (void)configInitData
{
    NSArray *codePath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);

    if (_logType == PaintEggshellLogNetWorkType) {
        _logPath = [NSString stringWithFormat:@"%@/PaintedNetworkLog/",codePath[0]];
    } else {
        _logPath = [NSString stringWithFormat:@"%@/PaintedCrashLog/",codePath[0]];
    }
}

- (void)creatNavigationBar
{
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationController.navigationBar.tintColor = [UIColor blackColor];
    self.navigationItem.title = @"日志列表";
    
    UIBarButtonItem *spaceItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    spaceItem.width = -16;
    UIButton *saveBtn = [self creatBtn:@"一键删除" action:@selector(allDeleteBtnAction:)];
    saveBtn.frame = CGRectMake(0, 0, 88, 44);
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:saveBtn];
    self.navigationItem.rightBarButtonItems = @[spaceItem,rightItem];
}

- (void)loadData
{
    NSFileManager *fileManager = [NSFileManager defaultManager];

    self.dataArray = [NSMutableArray arrayWithArray:[fileManager contentsOfDirectoryAtPath:_logPath error:nil]];
    [_tableView reloadData];
}

- (void)addTableView
{
    UITableView *tableView = [[UITableView alloc] init];
    [self.view addSubview:tableView];
    [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    tableView.delegate = self;
    tableView.dataSource = self;
    [tableView registerClass:[PaintEggshellLogTableViewCell class] forCellReuseIdentifier:kCellReuseIdentifier];
    tableView.tableFooterView = [[UIView alloc] init];
    tableView.tableHeaderView = [[UIView alloc] init];
    tableView.separatorColor = [UIColor colorWithRed:230/255.f green:230/255.f blue:230/255.f alpha:1.0];
    tableView.backgroundColor = [UIColor colorWithRed:0xf0/255.0f green:0xf0/255.0f blue:0xf0/255.0f alpha:1];
    _tableView = tableView;
}

- (void)deleteFile:(NSString *)fileName
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *filePath = [NSString stringWithFormat:@"%@%@",_logPath,fileName];
    [fileManager removeItemAtPath:filePath error:nil];
}

- (void)deleteAllFile
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    [fileManager removeItemAtPath:_logPath error:nil];
}

- (UIButton *)creatBtn:(NSString *)title action:(SEL)selector
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:btn];
    btn.titleLabel.font = [UIFont systemFontOfSize:14.0f];
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    [btn addTarget:self action:selector forControlEvents:UIControlEventTouchUpInside];
    return btn;
}

#pragma mark - action method
- (void)allDeleteBtnAction:(UIButton *)btn
{
    [self deleteAllFile];
    [self loadData];
}



@end
