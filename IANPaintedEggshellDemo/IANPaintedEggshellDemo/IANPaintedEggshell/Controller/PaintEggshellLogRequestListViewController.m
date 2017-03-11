//
//  PaintEggshellLogRequestListViewController.m
//  IANPaintedEggshellDemo
//  网络日志request页面
//  Created by ian on 2017/3/8.
//  Copyright © 2017年 ian. All rights reserved.
//

#import "PaintEggshellLogRequestListViewController.h"
#import "PaintEggshellLogRequestListTableViewCell.h"
#import "IANNetworkLogModel.h"
#import <Masonry.h>
#import "PaintEggshellDetailLogViewController.h"

static NSString *const kCellReuseIdentifier = @"RequestListTableViewCell";

@interface PaintEggshellLogRequestListViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation PaintEggshellLogRequestListViewController


#pragma mark - life style

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"网络日志request列表";
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self addTableView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - table delegate && datasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PaintEggshellLogRequestListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellReuseIdentifier forIndexPath:indexPath];
    IANNetworkLogModel *model = (IANNetworkLogModel *)self.dataArray[indexPath.row];
    [cell configCellWithModel:model];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    IANNetworkLogModel *model = (IANNetworkLogModel *)self.dataArray[indexPath.row];
    return [PaintEggshellLogRequestListTableViewCell heightWithModel:model];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    PaintEggshellDetailLogViewController *paintEggshellDetailLogVC = [[PaintEggshellDetailLogViewController alloc] init];
    IANNetworkLogModel *model = (IANNetworkLogModel *)self.dataArray[indexPath.row];
    NSMutableArray *array = [NSMutableArray arrayWithObject:model];
    paintEggshellDetailLogVC.dataArray = array;
    [self.navigationController pushViewController:paintEggshellDetailLogVC animated:YES];
}

- (NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewRowAction *copyAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:@"复制" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        // 实现相关的逻辑代码
        // ...
        // 在最后希望cell可以自动回到默认状态，所以需要退出编辑模式
        IANNetworkLogModel *model = (IANNetworkLogModel *)self.dataArray[indexPath.row];
        NSString *contentStr = [NSString stringWithFormat:@"URL:%@\nMethod:%@\nBody:%@",model.urlString,model.httpMethodString,model.httpBodyString];
        UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
        pasteboard.string = contentStr;
        
        tableView.editing = NO;
    }];
    
    return @[copyAction];
}


#pragma mark - private method

- (void)addTableView
{
    UITableView *tableView = [[UITableView alloc] init];
    [self.view addSubview:tableView];
    [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    tableView.delegate = self;
    tableView.dataSource = self;
    [tableView registerClass:[PaintEggshellLogRequestListTableViewCell class] forCellReuseIdentifier:kCellReuseIdentifier];
    tableView.tableFooterView = [[UIView alloc] init];
    tableView.tableHeaderView = [[UIView alloc] init];
    tableView.separatorColor = [UIColor colorWithRed:230/255.f green:230/255.f blue:230/255.f alpha:1.0];
    tableView.backgroundColor = [UIColor colorWithRed:0xf0/255.0f green:0xf0/255.0f blue:0xf0/255.0f alpha:1];
    _tableView = tableView;
}

@end
